//
//  TwitterClient.swift
//  Twitter
//
//  Created by Laura on 4/11/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    private static let baseStringURL = "https://api.twitter.com/"
    private static let clientID = "rXeDXpD5NsId6ZGbIIcbQbZ5C"
    private static let clientSecret = "ZQGYUxQOLYv7UMz98hofvmPVgGd9ygm6KSZDGKPhJqCyvOuW6z"
    
    private let requestTokenEndpoint = "oauth/request_token"
    private let accessTokenEndpoint = "oauth/access_token"
    private let authorizeEndpoint = "oauth/authorize"
    private let authorizeTokenParameter = "?oauth_token="
    
    private let homeTimeLineEndpoint = "1.1/statuses/home_timeline.json"
    private let currentAccountEndpoint = "1.1/account/verify_credentials.json"
    private let createNewTweetEndpoint = "1.1/statuses/update.json"
    private let retweetEndpoint = "1.1/statuses/retweet/:id.json"
    private let markAsFavoriteEndpoint = "1.1/favorites/create.json"
    private let getUserProfileEndpoint = "1.1/users/show.json"
    private let getUserTimelineEndpoint = "1.1/statuses/user_timeline.json"
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: baseStringURL), consumerKey: clientID, consumerSecret: clientSecret)
   
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        // In order to clear the avoid a fliker, we have to logout before we try to login
        deauthorize()
        
        // If access is granted, the twitter client will recieve a one time use unique token that can be excanged to an access token
        // The callbackURL needs to be sent as a parameter, in order to reopen the app, after user grants access
        fetchRequestToken(withPath: requestTokenEndpoint, method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            let token = requestToken?.token
            let authStringURL = TwitterClient.baseStringURL + self.authorizeEndpoint + self.authorizeTokenParameter + token!
            if let authURL = URL(string: authStringURL) {
                UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
            }
            
        }, failure: { (error: Error?) in
            self.loginFailure?(error!)
            print("error: \(error?.localizedDescription)")
            
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        // Go back to the Login window
        NotificationCenter.default.post(name: NSNotification.Name(User.didLogOutNotification), object: nil)
    }
    
    func handleOpenURL(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        // Send a request to the server to create a new access token
        fetchAccessToken(withPath: accessTokenEndpoint, method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            // fetch and store the current user's account
            self.currentAccount(success: { (user: User) in
                
                User.currentUser = user
                self.loginSuccess!()
                
            }, failure: { (error: Error) in
                self.loginFailure!(error)
                
            })
            
        }) { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure!(error!)
            
        }
    }
    
    func currentAccount(success: @escaping (User)-> (), failure: @escaping (Error) -> ()) {
        get(currentAccountEndpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let user = User(dictionary: response as! NSDictionary)
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        })
    }
    
    func homeTimeLine(numberOfRecordsToRetrieve count: Int?, lastRecordRetrievedID id: NSNumber?, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        var param: [String: AnyObject]? = [:]
        
        if let count = count {
            param?["count"] = count as AnyObject
        }
        
        if let id = id {
            param?["max_id"] = id as AnyObject
        }
        
        get(homeTimeLineEndpoint, parameters: param, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let response = response as? [NSDictionary]
            {
                let tweets = Tweet.tweetsWithArray(dictionaries: response)
                success(tweets)
            }
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        }
    }
    
    func createNewTweet(withMessage text: String, success: @escaping (Tweet) -> () , failure: @escaping (Error) -> ()) {
        let param: [String: Any] = ["status": text]
        post(createNewTweetEndpoint, parameters: param, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        }
    }
    
    func retweeting(withID id: NSNumber, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let retweetingEndpoint = retweetEndpoint.replacingOccurrences(of: ":id", with: "\(id)")
        let param: [String: Any] = ["id": id]
        post(retweetingEndpoint, parameters: param, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func markAsFavorite(withID id: NSNumber, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let param: [String: Any] = ["id": id]
        post(markAsFavoriteEndpoint, parameters: param, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func getUserProfile(withScreenName screenName: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        let param: [String: Any] = ["screen_name": screenName]
        get(getUserProfileEndpoint, parameters: param, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let user = User(dictionary: response as! NSDictionary)
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getUserTimeline(withScreenName screenName: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        let param: [String: Any] = ["screen_name": screenName]
        get(getUserTimelineEndpoint, parameters: param, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let response = response as? [NSDictionary]
            {
                let tweets = Tweet.tweetsWithArray(dictionaries: response)
                success(tweets)
            }
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
}
