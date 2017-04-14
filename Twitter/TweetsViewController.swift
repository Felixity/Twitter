//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Laura on 4/12/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        // Set dimmensions for table cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        setupRefreshControl()
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweetsResponse: [Tweet]) in
            self.tweets = tweetsResponse
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        
        // Add an action for the refresh control
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        
        // Add refresh controll to the table view
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    @objc private func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweetsResponse: [Tweet]) in
            
            self.tweets = tweetsResponse
            self.tableView.reloadData()
            
            // Tell refresh control to end refreshing
            refreshControl.endRefreshing()
            
        }, failure: { (error: Error) in
            
            // Tell refresh control to end refreshing
            refreshControl.endRefreshing()
            
            print(error.localizedDescription)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as? UINavigationController
        if let destinationVC = navigationController?.topViewController as? ComposeTweetViewController {
            destinationVC.delegate = self
        }
        
    }
}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

extension TweetsViewController: ComposeTweetViewControllerDelegate {
    func composeTweetViewController(composeTweetViewController: ComposeTweetViewController, didUpdateTweets tweet: Tweet) {
        // The new posted tweet must be insterted in the first position, so that it is visible in the table view, on top of the old tweets
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
}
