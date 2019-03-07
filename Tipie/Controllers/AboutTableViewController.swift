//
//  AboutTableViewController.swift
//  Tippin'
//
//  Created by Neftali Samarey on 1/19/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

import UIKit
import MessageUI

// Delegates
protocol UserToggledControlsDelegate: class {
    func userToggledRounding(value: Bool)
}

class AboutTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
   
    weak var delegate: UserToggledControlsDelegate? = nil
    
    @IBOutlet weak var toggleRoundingReference: UISwitch!
    
    @IBAction func toggleRoundingAction(_ sender: Any) {
       // work on the sender 
    }
    

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
