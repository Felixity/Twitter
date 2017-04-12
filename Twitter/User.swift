//
//  User.swift
//  Twitter
//
//  Created by Laura on 4/11/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileURL: URL?
    var tagline: String?
    
    init(dictionary: NSDictionary) {
    
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileURL = URL(string: profileUrlString)
        }
        tagline = dictionary["description"] as? String
    }
}
