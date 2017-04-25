//
//  MenuTableViewController.swift
//  Twitter
//
//  Created by Laura on 4/21/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class MenuTableViewController: UIViewController {

    var menuOptions = ["Profile", "Timeline", "Mentions"]
    
    private var profileNavigationController: UIViewController!
    private var timelineNavigationController: UIViewController!
    var mentionsNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = .white
        tableView.backgroundColor = UIColor(red: 64/255, green: 153/255, blue: 255/255, alpha: 1)

        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TimelineNavigationController")
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(timelineNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        // setup the screen displayed after launching
        hamburgerViewController.contentViewController = timelineNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MenuTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = menuOptions[indexPath.row]
        
        cell.backgroundColor = UIColor(red: 64/255, green: 153/255, blue: 255/255, alpha: 1)
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightGray
        tableView.cellForRow(at: indexPath)?.selectedBackgroundView = backgroundView
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if viewControllers[indexPath.row] == mentionsNavigationController {
            let tweetsViewController = mentionsNavigationController.childViewControllers.first as! TimelineViewController
            tweetsViewController.isMentionsView = true
        }
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let backgroundColor = UIColor(red: 64/255, green: 153/255, blue: 255/255, alpha: 1)
        cell.contentView.backgroundColor = backgroundColor
        
    }
    
}
