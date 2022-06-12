//
//  HTTPService.swift
//  SearchApp
//
//  Created by Vishwa Fernando on 6/12/22.
//  Copyright © 2022 ncs. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum NetworkManagerError: Error {
  case badResponse(URLResponse?)
  case badData
  case badLocalUrl
}

protocol SearchListAPIDelegate :  AnyObject {
    
    func getSearchResults(res: [Movie])
    func getSearchResults(_ error: RestClientError)
    
}

class HTTPService: NSObject {
    
    weak var searchAPIDelegate  : SearchListAPIDelegate?
    
    var baseUrl         : NSString?
    var parameters      : [String : AnyObject]?
    var headers         : HTTPHeaders
    var timeoutInterval : Double = 20
    var APIKey          : NSString?
    var images = NSCache<NSString, NSData>()
    let session: URLSession
    
    init(baseUrl: NSString! = "https://www.omdbapi.com") {
        
        self.baseUrl    = baseUrl
        parameters      = [:]
        self.headers    = [
            "Content-Type":"application/json"]
        self.APIKey     = "b831f50c"
        
        let config  = URLSessionConfiguration.default
            session = URLSession(configuration: config)
    }
    
    //Get Requests
    func getRequest(_ parameters: [String: AnyObject]?, contextPath: NSString, completionHandler: @escaping (HTTPResponse) -> Void) {
        
        let urlString   = "\(self.baseUrl!)\(contextPath)&apikey=\(self.APIKey!)" as URLConvertible
        
        Alamofire.request(urlString, method: .get, parameters: self.parameters!, headers: self.headers).responseJSON { (response) in
            
            var httpResponse: HTTPResponse! = nil
            
            if let errorCode        = response.result.error,
               let errorMessage    = response.result.error?.localizedDescription {
                httpResponse                = HTTPResponse(result: nil, error: nil)
                print("alamofire error")
                print("getRequest -> error code: \(errorCode)")
                print("getRequest -> error message: \(errorMessage)")
                
            } else {
                
                do {
                    let jsonResult = try JSON(data: response.data!)
                    print("jsonResult:   \(jsonResult)")
                    if response.response!.statusCode >= 200 && response.response!.statusCode < 300 {    /// check
                        httpResponse        = HTTPResponse(result: jsonResult, error: nil)
                    } else if response.response!.statusCode == 401 {
                        // Error
                    }else{
                        let exception       = RestClientError.init(jsonResult: jsonResult)
                        httpResponse        = HTTPResponse(result: nil, error: exception)
                    }
                    
                } catch {
                    let exception           = RestClientError.jsonParseError(errorCode: "0" , errorMessage: "Error")
                    httpResponse            = HTTPResponse(result: nil, error: exception)
                }
            }
            if httpResponse != nil {
                completionHandler(httpResponse)
            }
        }
    }
    
    func download(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        if let imageData = images.object(forKey: imageURL.absoluteString as NSString) {
            print("using cached images")
            completion(imageData as Data, nil)
            return
        }
        
        let task = session.downloadTask(with: imageURL) { localUrl, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkManagerError.badResponse(response))
                return
            }
            
            guard let localUrl = localUrl else {
                completion(nil, NetworkManagerError.badLocalUrl)
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                self.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}


extension HTTPService: SearchListProtocol{
    
    func getSearchList(sText: NSString){
        
        let context = "/?s=\(sText)"
        
        getRequest(nil, contextPath: context as NSString) { (response) in
            
            let responseError = response.responseError
            let responseResult  = response.responseResult
            
            if let error = responseError {
                self.searchAPIDelegate?.getSearchResults(error)
                return
            }
            
            if let json = responseResult {
                if let jsonArray    = json["Search"].array {       //access requested data here
                    var movies      = [Movie]()
                    for jsonObj in jsonArray {
                        if let jsonString   = jsonObj.rawString() {
                            if let movie     = Mapper<Movie>().map(JSONString: jsonString) {
                                movies.append(movie)
                            }
                        }
                    }
                    self.searchAPIDelegate?.getSearchResults(res: movies)
                } else {
                    let exception               = RestClientError.jsonParseError(errorCode: "0", errorMessage: "Error")
                    self.searchAPIDelegate?.getSearchResults(exception)
                    return
                }
            }
            
            print("handle default error here: getModesDetails")
            return
        }
        
    }
    
//    func getImageForURL(url: NSString){
        
    func image(url: NSString,completion: @escaping (Data?, Error?) -> (Void)) {
        let url = URL(string: url as String)!
           download(imageURL: url, completion: completion)
        }
         
        
//    }
    
}
