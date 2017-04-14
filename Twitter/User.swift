//
//  User.swift
//  Twitter
//
//  Created by Laura on 4/11/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let didLogOutNotification = "UserLoggedOut"
    private static let currentUserDataKey = "currentUserData"
    
    var name: String? {
        return dictionary["name"] as? String
    }

    var screenName: String? {
        return dictionary["screen_name"] as? String
    }
    
    var profileURL: URL? {
        guard let progileImageStringURL = dictionary["profile_image_url_https"] as? String else {
            return nil
        }
        return URL(string: progileImageStringURL)
    }
    
    var tagline: String? {
        return dictionary["description"] as? String
    }
    
    private let dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    
    // Intermidiate variable used store the current user's data, in order to avoid reading it each time from disk
    private static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                guard let userData = UserDefaults.standard.object(forKey: currentUserDataKey) as? Data else {
                    return nil
                }
                guard let dictionary = try? JSONSerialization.jsonObject(with: userData, options: []) as? NSDictionary else {
                    return nil
                }
                _currentUser = User(dictionary: dictionary!)
            }
            return _currentUser
        }
        
        set(user) {
            if let user = user {
                let userData = try? JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                UserDefaults.standard.set(userData, forKey: currentUserDataKey)
            }
            else {
                UserDefaults.standard.set(nil, forKey: currentUserDataKey)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
}
