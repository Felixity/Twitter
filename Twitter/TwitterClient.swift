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
            print("Error: \(error?.localizedDescription)")
            
        })
    }
    
    func handleOpenURL(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        // Send a request to the server to create a new access token
        fetchAccessToken(withPath: accessTokenEndpoint, method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.loginSuccess!()
            
        }) { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            
            self.loginFailure!(error!)
        }
    }
}
