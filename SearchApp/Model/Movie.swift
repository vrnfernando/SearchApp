//
//  Movie.swift
//  SearchApp
//
//  Created by Kasper - Vishwa on 2022-06-12.
//  Copyright © 2022 ncs. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Movie: NSObject, Mappable {
    
    var title    : NSString = ""
    var year     : NSString = ""
    var imdbID   : NSString = ""
    var type     : NSString = ""
    var poster   : NSString = ""
    
    internal init(title: NSString, year: NSString, imdbID: NSString, type: NSString, poster: NSString) {
        self.title   = title
        self.year    = year
        self.imdbID  = imdbID
        self.type    = type
        self.poster  = poster
    }
    
    required internal init?(map: Map){ }
    
    internal func mapping(map: Map) {
        title       <- map["Title"]
        year        <- map["Year"]
        imdbID      <- map["imdbID"]
        type        <- map["Type"]
        poster      <- map["Poster"]
    }
    
    deinit {
        print("deinit - Movie")
    }
}
