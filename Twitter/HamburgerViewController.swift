//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Laura on 4/21/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuViewController.willMove(toParentViewController: self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil  {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            self.addChildViewController(contentViewController)
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            // After the content view is selected, the menu view disappears automatically
            UIView.animate(withDuration: 0.3) { 
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            originalLeftMargin = leftMarginConstraint.constant
        }
        else if sender.state == .changed {
            // In order to be able hold the contentView while dragging
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        }
        else if sender.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                }
                else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
    }
}
