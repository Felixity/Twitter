//
//  Tweet.swift
//  Twitter
//
//  Created by Laura on 4/11/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var profileImageURL: URL?
    var username: String?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(dictionary: NSDictionary) {
        
        if let user = dictionary.value(forKeyPath: "user") as? NSDictionary {
            if let profileImageStringURL = user["profile_image_url"] as? String {
                profileImageURL = URL(string: profileImageStringURL)
            }
            username = user["name"] as? String
        }
        text = dictionary["text"] as? String
        
        if let timestampString = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets: [Tweet] = []
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
