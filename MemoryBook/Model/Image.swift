//
//  Image.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-16.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class Image: NSObject {
    var category : String?
    var userId : String?
    var imageUrl : String?
    
    init(dictionary : [String : String]) {
        if dictionary["category"] != nil {
            category = dictionary["category"]
        }
        
        if dictionary["userId"] != nil {
            userId = dictionary["userId"]
        }
        
        if dictionary["imageUrl"] != nil {
            imageUrl = dictionary["imageUrl"]
        }
    }
}
