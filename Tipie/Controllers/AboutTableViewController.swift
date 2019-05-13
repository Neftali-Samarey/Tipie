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
    
    // CONSTRAINT OUTLETS ITEMS
    @IBOutlet weak var rateCell: UITableViewCell!
    @IBOutlet weak var feedbackCell: UITableViewCell!
    @IBOutlet weak var shareCell: UITableViewCell!
    
    @IBOutlet weak var rateImageIcon: UIImageView!
    @IBOutlet weak var feedbackImageIcon: UIImageView!
    @IBOutlet weak var shareImageIcon: UIImageView!
    @IBOutlet weak var rateTipieLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    
    @IBOutlet weak var buildVersionLabel: UILabel!
    
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
        self.setConstraints()
        styleTableViewController()
       
        self.getSoftwareBuildVersion()
        
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
    
    func getSoftwareBuildVersion() {
        
        if let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            buildVersionLabel.text = text
        }
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
             rateTipie()
        case 4:
             sendEmail()
        case 5:
             shareTipie()
        default:
            print("None selected")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func rateTipie() {
        rateApp(appId: "1454194057") { success in
            print("RateApp \(success)")
        }
    }
    
    // Rate app method
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    // MARK: - SEND EMAIL
    
    func sendEmail() {
        
        if let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
           
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["neftalisamarey@gmail.com"])
            mail.setMessageBody("<style>body {background-color: #fff;} p {font-family: avenir; line-height: 7px;} </style><p>App: Tipie</p><p>Build Version: \(text)</p><br/><div><span>----- YOUR MESSAGE BELOW -----</span></div><br/><br/>", isHTML: true)
            
            present(mail, animated: true, completion: nil)
        } else {
            // Fail alert
            self.errorMessage()
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    let errorMessage = {() -> Void in
        SweetAlert().showAlert("Email client error", subTitle: "Your email client has not been setup with an email account. Please go to accounts under settings menu to set up an email account.", style: AlertStyle.error)
    }
    
    // MARK: - SHARE APP
    func shareTipie() {
        
    }
    
    
    
    // MARK: - PROGRAMMATIC AUTOLAYOUT CONSTRAINT METHOD
    fileprivate func setConstraints() {
        // turn em' off
        rateImageIcon.translatesAutoresizingMaskIntoConstraints = false
        feedbackImageIcon.translatesAutoresizingMaskIntoConstraints = false
       
        
        rateTipieLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
    
        
        // temp
      
        
        rateImageIcon.contentMode = .scaleAspectFit
        feedbackImageIcon.contentMode = .scaleAspectFit
      
        // constrain em'
       
        
        // CELL 1
        rateImageIcon.leadingAnchor.constraint(equalTo: self.rateCell.leadingAnchor, constant: 5).isActive = true
        rateImageIcon.trailingAnchor.constraint(equalTo: self.rateTipieLabel.leadingAnchor, constant: 5).isActive = true
        rateImageIcon.centerYAnchor.constraint(equalTo: rateCell.centerYAnchor, constant: 0).isActive = true
        rateImageIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        rateImageIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        // LABEL
        rateTipieLabel.trailingAnchor.constraint(equalTo: self.rateCell.trailingAnchor, constant: -10).isActive = true
        rateTipieLabel.leadingAnchor.constraint(equalTo: self.rateCell.leadingAnchor, constant: 60).isActive = true
        rateTipieLabel.topAnchor.constraint(equalTo: self.rateCell.topAnchor, constant: 5).isActive = true
        rateTipieLabel.bottomAnchor.constraint(equalTo: self.rateCell.bottomAnchor, constant: -5).isActive = true
        
        
        
        // CELL 2
        feedbackImageIcon.leadingAnchor.constraint(equalTo: self.feedbackCell.leadingAnchor, constant: 5).isActive = true
        feedbackImageIcon.trailingAnchor.constraint(equalTo: self.feedbackLabel.leadingAnchor, constant: 5).isActive = true
        feedbackImageIcon.centerYAnchor.constraint(equalTo: feedbackCell.centerYAnchor, constant: 0).isActive = true
        feedbackImageIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        feedbackImageIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        // LABEL
        feedbackLabel.trailingAnchor.constraint(equalTo: self.feedbackCell.trailingAnchor, constant: -10).isActive = true
        feedbackLabel.leadingAnchor.constraint(equalTo: self.feedbackCell.leadingAnchor, constant: 60).isActive = true
        feedbackLabel.topAnchor.constraint(equalTo: self.feedbackCell.topAnchor, constant: 5).isActive = true
        feedbackLabel.bottomAnchor.constraint(equalTo: self.feedbackCell.bottomAnchor, constant: -5).isActive = true
        
      
        
    }
    
}
