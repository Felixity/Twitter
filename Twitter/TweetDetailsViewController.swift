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
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    @IBAction func onReply(_ sender: UIButton) {
    }
    
    @IBAction func onRetweet(_ sender: UIButton) {
    }
    
    @IBAction func onFavorite(_ sender: UIButton) {
    }
    
    private func setupUI() {
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
}
