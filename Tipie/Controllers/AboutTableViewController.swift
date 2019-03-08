//
//  AboutTableViewController.swift
//  Tippin'
//
//  Created by Neftali Samarey on 1/19/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

import UIKit
import MessageUI

// Notification keys
let notificationKey = "nt100"

class AboutTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    let defaults = UserDefaults.standard
    @IBOutlet weak public var toggleRoundingReference: UISwitch!
    
    // MARK: - ROUNDING TOGGLING
    @IBAction func toggleRoundingAction(_ sender: UISwitch) {
        
        // work on the sender
        // Posting notification
        if sender.isOn {
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: self, userInfo: ["on" : true])
            defaults.set(true, forKey: "toggled")
          //NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: self)
        } else {
             NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: self, userInfo: ["off" : false])
             defaults.set(false, forKey: "toggled")
         //NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: self)
        }
    }
    
    @objc func userDismissedView(notification :NSNotification) {
       
    }
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleRoundingReference.isOn =  UserDefaults.standard.bool(forKey: "toggled")
        self.title = "About Tipie"
        styleTableViewController()
       
        
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont(name: "Lato-Light", size: 24)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        // notification
         NotificationCenter.default.addObserver(self, selector: #selector(self.userDismissedView(notification:)), name: NSNotification.Name(notificationKey), object: nil)
    }
    
    // MARK: - Table Styles
    fileprivate func styleTableViewController() {
        self.tableView.backgroundColor = UIColor.white
    }

    // MARK: - Controller Methods
    @IBAction func dismissAboutController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index: \(indexPath.section)")
        
        switch indexPath.section {
        case 0:
            print("1st")
        case 1:
            print("2")
        case 2:
            print("2")
        case 3:
             sendEmail()
        case 4:
            shareTipie()
        default:
            print("None selected")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK: - SEND EMAIL
    func sendEmail() {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["neftalisamarey@gmail.com"])
            mail.setMessageBody("<p> </p>", isHTML: true)
            
            present(mail, animated: true, completion: nil)
        } else {
            // Fail alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - SHARE APP
    func shareTipie() {
        
    }
    
}
