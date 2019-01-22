//
//  AboutTableViewController.swift
//  Tippin'
//
//  Created by Neftali Samarey on 1/19/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "About Tipie"
        styleTableViewController()
       
        
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont(name: "Lato-Light", size: 24)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    // MARK: - Table Styles
    fileprivate func styleTableViewController() {
        self.tableView.backgroundColor = UIColor.white
    }

    // MARK: - Controller Methods
    @IBAction func dismissAboutController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
