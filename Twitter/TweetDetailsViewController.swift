//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Laura on 4/14/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailsViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetDescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        customizeNavigationBar()
    }

    @IBAction func onReply(_ sender: UIButton) {
    }
    
    @IBAction func onRetweet(_ sender: UIButton) {
        if let id = tweet?.id {
            TwitterClient.sharedInstance?.retweeting(withID: id, success: { (tweet: Tweet) in

                // Update tweet's data
                self.tweet = tweet
                sender.setImage(UIImage(named: "retweetOn"), for: UIControlState.normal)
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func onFavorite(_ sender: UIButton) {
        if let id = tweet?.id {
            TwitterClient.sharedInstance?.markAsFavorite(withID: id, success: { (tweet: Tweet) in
                
                // Update tweet's data
                self.tweet = tweet
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    }
    
    private func updateUI() {
        if viewIfLoaded == nil {
            return
        }
        
        if let tweet = tweet {
            if let url = tweet.profileImageURL {
                profileImageView.setImageWith(url)
            }
            
            if let _ = tweet.retweetedBy {
                retweetLabel.isHidden = false
            }
            else {
                retweetLabel.isHidden = true
            }
            
            usernameLabel.text = tweet.username
            screenNameLabel.text = tweet.screenName
            tweetDescriptionLabel.text = tweet.text
            
            if let timestamp = tweet.timestamp {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/DD/YYYY, hh:mm a"
                dateLabel.text = formatter.string(from: timestamp)
            }
            
            retweetsCountLabel.text = "\(tweet.retweetCount)"
            favoritesCountLabel.text = "\(tweet.favoritesCount)"
        }
    }
    
    private func customizeNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 64/255, green: 153/255, blue: 255/255, alpha: 1)
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = .white
            
            let attributeColor = UIColor.white
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: attributeColor]
        }
    }
}
