//
//  SearchListAPI.swift
//  SearchApp
//
//  Created by Vishwa Fernando on 6/12/22.
//  Copyright © 2022 ncs. All rights reserved.
//

import Foundation

protocol SearchListProtocol {
    
    func getSearchList(sText: NSString)
//    func getImageForURL(url: NSString)
    func image(url: NSString,completion: @escaping (Data?, Error?) -> (Void))
    
}
