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
    var imageUrls : [String]?
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
        
        if dictionary["imageUrls"] != nil {
            imageUrls = dictionary["imageUrls"] as? [String]
        }
        
        if dictionary["likeImageUrls"] != nil {
            likeImageUrls = dictionary["likeImageUrls"] as? [String]
        }
    }
}
