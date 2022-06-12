//
//  RestClientError.swift
//  SearchApp
//
//  Created by Vishwa Fernando on 6/12/22.
//  Copyright © 2022 ncs. All rights reserved.
//

import Foundation

public enum RestClientError: Error {
    case databaseError(httpErrorCode: String, errorMessage: String)                     // 1001
    
    case invalidInputError(httpErrorCode: String, errorMessage: String)                 // 1002
    
    case connectionCouldntConnetToServerError(errorCode: String, errorMessage: String)  // -1004
    
    case connectionLostError(errorCode: String, errorMessage: String)                   // -1005
    
    case connectionError(errorCode: String, errorMessage: String)                       // -1009
    
    case jsonParseError(errorCode: String, errorMessage: String)                        // -1008
    
    case undefinedError(errorCode: String, errorMessage: String)
    
    case unAuthorized(errorCode: String, errorMessage: String)                          // -1007
    
    case md5NotMatchedError(errorCode: String, errorMessage: String)                    // -1006
}

extension RestClientError {
    init(errorCodeString: Int, message: String) {
        switch errorCodeString {
            
        case 1001:
            self    = .databaseError(httpErrorCode: "1001", errorMessage: message)                                      //"Database Error"
            
        case -1004:
            self    = .connectionCouldntConnetToServerError(errorCode: "-1004", errorMessage: message)                  //"Connection Could not connect to the server"
        case -1005:
            self    = .connectionLostError(errorCode: "-1005", errorMessage: message)                                   //"Connection Lost Error"
            
        case -1009:
            self    = .connectionError(errorCode: "-1009", errorMessage: message)                                       //"Connection Error"
            
        case -1007:
            self   = .unAuthorized(errorCode: "-1007", errorMessage: message)
            
        case -1008:
            self    = .jsonParseError(errorCode: "-1008", errorMessage: message)                                        //"Json Parse Error"
            //        case "":
            //            self    = .unAuthorized(errorCode: "-1007", errorMessage: message)
            
        default:
            print("RestClientError -> first init, code: \(errorCodeString),message: \(message)")
            self    = .undefinedError(errorCode: "-1007", errorMessage: message)                                        //"Undefined Error
        }
    }
    
    
    init(jsonResult: JSON?) {
        if let errorCodeString  = jsonResult?["code"].stringValue,
           let message         = jsonResult?["message"].stringValue {
            switch errorCodeString {
                
            case "1001":
                self    = .databaseError(httpErrorCode: "1001", errorMessage: message)                                  //"Database Error"
                
            case "-1004":
                self    = .connectionCouldntConnetToServerError(errorCode: "-1004", errorMessage: message)              //"Connection Could not connect to the server"
            case "-1005":
                self    = .connectionLostError(errorCode: "-1005", errorMessage: message)                               //"Connection Lost Error"
                
            case "-1006":
                self    = .md5NotMatchedError(errorCode: "-1006", errorMessage: message)                               //"Connection Lost Error"
                
            case "-1009":
                self    = .connectionError(errorCode: "-1009", errorMessage: message)                                   //"Connection Error"
                
            case "-1007":
                self    = .unAuthorized(errorCode: "-1007", errorMessage: message)
                
            case "-1008":
                self    = .jsonParseError(errorCode: "-1008", errorMessage: message)                                    //"Json Parse Error"
            case "":
                self    = .unAuthorized(errorCode: "-1007", errorMessage: message)
                
            default:
                print("RestClientError -> second init, code: \(errorCodeString), message: \(message)")
                self    = .undefinedError(errorCode: "-1007", errorMessage: message)                                    //"Undefined Error
            }
        }else {
            print("RestClientError -> second init, result nil")
            self    = .undefinedError(errorCode: "-1007", errorMessage:"commented 93");
            //            String(AppConfig.si.undefinedError.msg)      //"Undefined Error
        }
    }
}
