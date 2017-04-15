//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Laura on 4/13/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit
import AFNetworking

protocol ComposeTweetViewControllerDelegate {
    func composeTweetViewController(composeTweetViewController: ComposeTweetViewController, didUpdateTweets tweet: Tweet)
}

class ComposeTweetViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetMessageTextView: UITextView!
    
    var newTweetMessage: String?
    var delegate: ComposeTweetViewControllerDelegate?
    
    var countDownBarItem: UIBarButtonItem!
    let tweetCharactersLimit = 140
    var nbOfRemainingCharacters = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetMessageTextView.becomeFirstResponder()
        tweetMessageTextView.delegate = self
        
        setupCountDownBarItem()
        setupUI()
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        tweetMessageTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onTwet(_ sender: UIBarButtonItem) {
        
        tweetMessageTextView.resignFirstResponder()
        
        if let newTweetMessage = newTweetMessage {
            
            // Post the new tweet om Twitter
            TwitterClient.sharedInstance?.createNewTweet(withMessage: newTweetMessage, success: { (tweet: Tweet) in
                
                self.delegate?.composeTweetViewController(composeTweetViewController: self, didUpdateTweets: tweet)
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        if let profileImageUrl = User.currentUser?.profileURL {
            profileImageView.setImageWith(profileImageUrl)
        }
        
        usernameLabel.text = User.currentUser?.name
        screenNameLabel.text = User.currentUser?.screenName
    }
    
    private func setupCountDownBarItem() {
        countDownBarItem = UIBarButtonItem(title: "\(tweetCharactersLimit)", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        navigationItem.rightBarButtonItems?.append(countDownBarItem)
    }
}

extension ComposeTweetViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        newTweetMessage = textView.text
        
        if let nbOfAddedCharacters = newTweetMessage?.characters.count {
            nbOfRemainingCharacters = tweetCharactersLimit - nbOfAddedCharacters
            
            // Update the countDown item with the new value
            countDownBarItem.title = "\(nbOfRemainingCharacters)"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return text.characters.count <= nbOfRemainingCharacters
    }
}
