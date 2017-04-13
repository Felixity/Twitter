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
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweetsResponse: [Tweet]) in
            self.tweets = tweetsResponse
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
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
