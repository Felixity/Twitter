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
    
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        // Set dimmensions for table cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        setupRefreshControl()
        customizeNavigationBar()
        
        setupLoadingIndicator()

        loadData()
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
        TwitterClient.sharedInstance?.homeTimeLine(numberOfRecordsToRetrieve: nil, lastRecordRetrievedID: nil , success: { (tweetsResponse: [Tweet]) in
            
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
        if let destinationVC = navigationController?.topViewController as? TweetDetailsViewController {
            let index = tableView.indexPath(for: sender as! TweetTableViewCell)
            destinationVC.tweet = tweets[(index?.row)!]
        }
    }
    
    @IBAction func onBackUnwindToTweetsViewController(segue: UIStoryboardSegue) {
    }
    
    @IBAction func onReplyUnwindToTweetsViewController(segue: UIStoryboardSegue) {
    }
    
    func loadData() {
        
        let lastTweetID: NSNumber? = tweets.last?.id != nil ? (tweets.last?.id)! : nil
        
        TwitterClient.sharedInstance?.homeTimeLine(numberOfRecordsToRetrieve: 20, lastRecordRetrievedID: lastTweetID, success: { (tweetsResponse: [Tweet]) in
            
            // Update loading flag
            self.isMoreDataLoading = false

            // Stop the loading indicator
            self.loadingMoreView?.stopAnimating()
            
            // Update the tweets collection
            self.tweets = self.tweets + tweetsResponse
            
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    private func customizeNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 64/255, green: 153/255, blue: 255/255, alpha: 1)
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = .white
            
            let attributeColor = UIColor.white
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: attributeColor]
        }
    }
    
    func getIndicatorFrame() -> CGRect {
        let indicatorOrigin = CGPoint(x: 0, y: tableView.contentSize.height)
        let indicatorSize = CGSize(width: tableView.contentSize.width, height: InfiniteScrollActivityView.defaultHeight)
        return CGRect(origin: indicatorOrigin, size: indicatorSize)
    }
    
    private func setupLoadingIndicator() {
        let frame = getIndicatorFrame()
        
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView?.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TweetsViewController: ComposeTweetViewControllerDelegate {
    func composeTweetViewController(composeTweetViewController: ComposeTweetViewController, didUpdateTweets tweet: Tweet) {
        // The new posted tweet must be insterted in the first position, so that it is visible in the table view, on top of the old tweets
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
}

extension TweetsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            
            // Calculate the position of one screen lenght before the bottom of the results
            let scollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scollViewContentHeight - tableView.bounds.size.height
            
            // When user has scrolled past the threshold, start requesting
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
                
                isMoreDataLoading = true
                
                // Update position of LoadingMoreView, and start loading indicator
                loadingMoreView?.frame = getIndicatorFrame()
                loadingMoreView?.startAnimating()
                
                // Load more results
                loadData()
            }
        }
    }
}
