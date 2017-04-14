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
                let elapsedTimeInSec = timestamp.timeIntervalSinceNow
                
                // Display the elapsed time in other format than seconds: minutes, hours, days or month and day
                let formatter = DateComponentsFormatter()
                formatter.maximumUnitCount = 1
                formatter.unitsStyle = .abbreviated
                formatter.allowedUnits = [.calendar, .day, .hour, .minute, .second]
                
                timestampLabel.text = formatter.string(from: elapsedTimeInSec)
            }
            tweetTextLabel.text = tweet.text
        }
    }
}
