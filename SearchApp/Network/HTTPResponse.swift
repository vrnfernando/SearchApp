//
//  HTTPResponse.swift
//  SearchApp
//
//  Created by Vishwa Fernando on 6/12/22.
//  Copyright © 2022 ncs. All rights reserved.
//

import Foundation
import UIKit

class HTTPResponse: NSObject {
    
    var responseStatus  : Bool  = true
    var responseResult  : JSON?
    var responseError   : RestClientError?
    
    init(status: Bool, result: JSON? = nil, error: RestClientError? = nil) {
        self.responseStatus     = status
        self.responseResult     = result
        self.responseError      = error
    }
    
    init(result: JSON? = nil, error: RestClientError? = nil) {
        self.responseResult     = result
        self.responseError      = error
    }
}
