//
//  InfiniteScrollActivityView.swift
//  Yelp
//
//  Created by Laura on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class InfiniteScrollActivityView: UIView {

    var activityViewIndicatorView = UIActivityIndicatorView()
    static let defaultHeight: CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityViewIndicatorView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
    }
    
    func setupActivityIndicator() {
        activityViewIndicatorView.activityIndicatorViewStyle = .gray
        activityViewIndicatorView.hidesWhenStopped = true
        self.addSubview(activityViewIndicatorView)
    }
    
    func startAnimating() {
        self.isHidden = false
        activityViewIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        activityViewIndicatorView.stopAnimating()
        self.isHidden = true
    }

}
