//
//  User.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-05.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class User: NSObject {
    var lastName : String?
    var firstName : String?
    var email : String?
    var imageIds : [String]?
    var likeImageUrls : [String]?
    
    init(dictionary: [String : Any]) {
        if dictionary["lastName"] != nil {
            lastName = dictionary["lastName"] as? String
        }
        
        if dictionary["firstName"] != nil {
            firstName = dictionary["firstName"] as? String
        }
        
        if dictionary["email"] != nil {
            email = dictionary["email"] as? String
        }
        
        if dictionary["imageIds"] != nil {
            imageIds = dictionary["imageIds"] as? [String]
        }else {
            imageIds = [String]()
        }
        
        
        if dictionary["likeImageUrls"] != nil {
            likeImageUrls = dictionary["likeImageUrls"] as? [String]
        }else {
            likeImageUrls = [String]()
        }
    }
}
