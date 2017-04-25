//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Laura on 4/21/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var tweetsCounterLabel: UILabel!
    @IBOutlet weak var followingCounterLabel: UILabel!
    @IBOutlet weak var followersCounterLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet] = []
    var user: User! {
        didSet {
            updateUI()
        }
    }
    
    var screenName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let screenName = screenName {
            TwitterClient.sharedInstance?.getUserProfile(withScreenName: screenName, success: { (userResponse: User) in
                
                self.user = userResponse
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            TwitterClient.sharedInstance?.getUserTimeline(withScreenName: screenName, success: { (tweetsResponse: [Tweet]) in
                
                self.tweets = self.tweets + tweetsResponse
                self.tableView.reloadData()
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            navigationItem.leftBarButtonItem?.title = "Timeline"
        }
        else {
            user = User.currentUser

            TwitterClient.sharedInstance?.homeTimeLine(numberOfRecordsToRetrieve: 20, lastRecordRetrievedID: nil, success: { (tweetsResponse: [Tweet]) in
    
                // Update the tweets collection
                self.tweets = self.tweets + tweetsResponse
    
                self.tableView.reloadData()
    
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        updateUI()
        customizeNavigationBar()
    }

    private func updateUI() {
    
        if viewIfLoaded == nil {
            return
        }
        if let user = user {
         
            if let coverURL = user.coverURL {
                print("coverURL: \(coverURL)")
                coverImage.setImageWith(coverURL)
            }
            else {
                print("coverURL is nil")
            }
            if let profileURL = user.profileURL {
                print("profileURL: \(profileURL)")
                profileImage.setImageWith(profileURL)
            }
            usernameLabel.text = user.name
            tweetsCounterLabel.text = "\(user.tweetCount)"
            followersCounterLabel.text = "\(user.followersCount)"
            followingCounterLabel.text = "\(user.followingCount)"

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
    
    @IBAction func onSignOut(_ sender: UIBarButtonItem) {
        if screenName != nil {
            self.dismiss(animated: false, completion: nil)
        }
        else {
            TwitterClient.sharedInstance?.logout()
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }

}

