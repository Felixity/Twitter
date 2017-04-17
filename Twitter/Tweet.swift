//
//  Tweet.swift
//  Twitter
//
//  Created by Laura on 4/11/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var profileImageURL: URL? {
        if let retweetedStatus = dictionary.value(forKey: "retweeted_status") as? NSDictionary {
            guard let user = retweetedStatus["user"] as? NSDictionary else {
                return nil
            }
            guard let profileImageStringURL = user["profile_image_url"] as? String else {
                return nil
            }
            return URL(string: profileImageStringURL)
        }
        else {
            guard let user = dictionary.value(forKeyPath: "user") as? NSDictionary else {
                return nil
            }
            guard let profileImageStringURL = user["profile_image_url"] as? String else {
                return nil
            }
            return URL(string: profileImageStringURL)
        }
    }
    
    var username: String? {
        if let retweetedStatus = dictionary.value(forKey: "retweeted_status") as? NSDictionary {
            guard let user = retweetedStatus["user"] as? NSDictionary else {
                return nil
            }
            return user["name"] as? String
        }
        else {
            guard let user = dictionary.value(forKeyPath: "user") as? NSDictionary else {
                return nil
            }
            return user["name"] as? String
        }
    }
    
    var text: String? {
        return dictionary["text"] as? String
    }
    
    var timestamp: Date? {
        guard let timestampString = dictionary["created_at"] as? String else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        return formatter.date(from: timestampString)
    }
    
    var retweetCount: Int {
        return (dictionary["retweet_count"] as? Int) ?? 0
    }
    
    var favoritesCount: Int {
        return (dictionary["favourites_count"] as? Int) ?? 0
    }
    
    var screenName: String? {
        if let retweetedStatus = dictionary.value(forKey: "retweeted_status") as? NSDictionary {
            guard let user = retweetedStatus["user"] as? NSDictionary else {
                return nil
            }
            return user["screen_name"] as? String
        }
        else {
            guard let user = dictionary.value(forKeyPath: "user") as? NSDictionary else {
                return nil
            }
            return user["screen_name"] as? String
        }        
    }
    
    var retweetedBy: String? {    
        return nil
    }
    
    var id: NSNumber? {
        return dictionary["id"] as? NSNumber
    }
    
    private var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        print("tweet: \(dictionary)")
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
