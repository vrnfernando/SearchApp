//
//  imageExtention.swift
//  SearchApp
//
//  Created by Kasper - Vishwa on 2022-06-14.
//  Copyright © 2022 ncs. All rights reserved.
//

import Foundation
import UIKit

    
func image(data: Data?) -> UIImage? {
    if let data = data {
        return UIImage(data: data)
    }
    return UIImage(systemName: "bgpng")
}
