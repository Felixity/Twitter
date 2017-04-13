//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Laura on 4/12/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        // reset existing content
        
        profileImageView.image = nil
        usernameLabel.text = nil
        timestampLabel.text = nil
        tweetTextLabel.text = nil
        
        if let tweet = tweet {
            if let url = tweet.profileImageURL {
                print("url: \(url)")
                profileImageView.setImageWith(url)
            }
            if let username = tweet.username {
                usernameLabel.text = username
            }
            if let timestamp = tweet.timestamp {
                print("timestamp: \(timestamp)")
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd"
                timestampLabel.text = formatter.string(from: timestamp)
            }
            tweetTextLabel.text = tweet.text
        }
    }
}
