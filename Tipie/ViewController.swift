//
//  ViewController.swift
//  Tippin'
//
//  Created by Neftali Samarey on 1/17/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//  Updated to iOS 13 on December 3, 2019

// NOTES: If Percentage is selected before input is made, 0 index value will be calculated first.

import UIKit

enum TipPercentage : Float {
    
    case Fiften = 0.15
    case Twenty = 0.20
    case TwentyFive = 0.25
}

class ViewController: UIViewController, SliderPercentageInputDelegate, didSlideThroughDelegate {
    
    
    var customSegmentControlView = HoverView()
    var typeSlider : Slider?
    var sliderTipIsActive : Bool?
    let roundingDefaults = UserDefaults.standard
    var tipRoundingAvailable: Bool?
    
    // Main background (level 0)
    @IBOutlet var topViewContainer: UIView!
    
    // Submain background (level 1)
    
    // LABELS
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    // IMAGE REFERENCES
    @IBOutlet weak var dueIconReference: UIImageView!
    @IBOutlet weak var tipIconReference: UIImageView!
    @IBOutlet weak var totalIconReference: UIImageView!
    
    // Dynamic labels
    @IBOutlet weak var titledDueLabel : UILabel!
    @IBOutlet weak var titledTipLabel: UILabel!
    @IBOutlet weak var titledTotalLabel: UILabel!
    
    
    @IBOutlet weak var dueParentView: UIView!
    @IBOutlet weak var tipParentView: UIView!
    @IBOutlet weak var totalParentView: UIView!
    @IBOutlet weak var segmentControlParentView: UIView!
    
   
    
   // CONTROL COMPONENTS
    @IBOutlet weak var splitButtonReference: UIBarButtonItem!
    @IBOutlet weak var splitButton: UIBarButtonItem!
    @IBOutlet weak var tipSegmentParentView: UIView!
    @IBOutlet weak var tipSegmentControl: UISegmentedControl!
    
    var cleanSlate : Bool?
    var decimalCounter = 0
    var selectedIndex = 0
    let navigatorBar = UIView()
    var overlayTouchArea = UIView()
    var layoutInPlace = true
   
    // COMPUTING VARIABLE
    var displayQuantity : Float = 0.0
    var tip: Float = 0.0
    var total: Float = 0.0
    var recievingInputString = String()
    
    
    // FEEDBACK GENERATOR
    let selectedFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    let clearedGenerator = UINotificationFeedbackGenerator()
    var tapGestureRecorgnizer : UITapGestureRecognizer?
    
    @IBOutlet var keyboardOutlets: [UIButton]!
    let relativeFontConstant : CGFloat = 0.046
    
    // CONSTRAINT REFERENCE VARIABLES
    @IBOutlet weak var yourTipValueLabel: UILabel!
    @IBOutlet weak var yourTipLabel: UILabel!
    
    var bottomTipLabelConstrain : NSLayoutConstraint?
    var bottomTitledTipLabelConstrain : NSLayoutConstraint?
    
    // TOTAL DUE ELEMENTS
    @IBOutlet weak var yourTotalLabel: UILabel!
    @IBOutlet weak var yourTotalValue: UILabel!
    
    var bottomTotalLabelConstrain : NSLayoutConstraint?
    var bottomTitledTotalLabelConstraint : NSLayoutConstraint?
    
    var userSelectedZero : Bool!
    
    // COMPUTING BASED ON INPUT
    @IBAction func actionKey(_ sender: UIButton) {
        
    
        
        selectedFeedbackGenerator.impactOccurred()
        
        self.tipSegmentControl.isEnabled = true
        self.splitButton.isEnabled = true
        
        // Testing to check
        if displayQuantity == 0 {
            userSelectedZero = true
            if let didSetZero = userSelectedZero {
                print("Zero: \(didSetZero)")
            }
        }
        
        
        // Removes the 0 during initial presentation
        if let slateClean = cleanSlate {
            if slateClean == false {
                self.dueLabel.text = ""
            }
        }
    
        cleanSlate = true
     
        self.dueLabel.text! = self.dueLabel.text! + String(sender.tag-1)
       // print("Label Test: \(String(describing: self.appendExtranousCharacter(label: dueLabel!)))") // test
        displayQuantity = Float(self.dueLabel.text!)!
        
       // print("Zero: \(displayQuantity)")
       
        // Also handling rounding mechanism here
        if let userToggledRounding = tipRoundingAvailable {
            if userToggledRounding {
                tip = displayQuantity * TipPercentage.Fiften.rawValue
                total = displayQuantity + tip
                self.tipLabel.text = String(format: "$%0.2f",tip.rounded())
                self.totalLabel.text = String(format: "$%0.2f",total.rounded())
            } else {
                tip = displayQuantity * TipPercentage.Fiften.rawValue
                total = displayQuantity + tip
                self.tipLabel.text = String(format: "$%0.2f",tip)
                self.totalLabel.text = String(format: "$%0.2f",total)
            }
        }
        

//        if let didCleanSlate = cleanSlate {
//           // print("Reporting: \(didCleanSlate)")
//        }
       
        
    }
    
    
    fileprivate func revokeZeroInputCharacter() {
        
    }
    
    
    // MARK: - Helper function to convert the string to desired label
    func appendExtranousCharacter(label: UILabel?) -> UILabel {
        let modifiedLabel =  UILabel()
        if let availableData = label {
            modifiedLabel.text = "$\(String(describing: availableData.text!))"
        }
        return modifiedLabel
    }
    

    // MARK: - DECIMAL INSERTION METHOD
    @IBAction func decimalInsertion(_ sender: UIButton) {
        
        selectedFeedbackGenerator.impactOccurred()

        let decimalChar: [Int: String] = [sender.tag-1: "."]
        
        guard displayQuantity != 0.0  else {
            return
        }

        if decimalCounter == 0 {
            self.dueLabel.text = self.dueLabel.text! + decimalChar[sender.tag-1]!
        }
        
        // Increment the counter
        decimalCounter += 1
    }
    
    // MARK: - DELETE ENTIRE ENTRY (CLEAR ALL)
    @IBAction func deleteEntry(_ sender: Any) {
        
        self.tipSegmentControl.isEnabled = false
        self.decimalCounter = 0
        self.displayQuantity = 0
        self.tip = 0
        self.total = 0
        self.dueLabel.text = "0"
        self.tipLabel.text = "0"
        self.totalLabel.text = "0"
        self.cleanSlate = false
        self.tipSegmentControl.selectedSegmentIndex = 0
        resetSegmentBarPosition()
        self.splitButton.isEnabled = false
        clearedGenerator.notificationOccurred(.success)
        //slideTipComponentsAway(sliderType: .Split)
    }
    
    
    // MARK: - SEGMENT CONTROL (Styling & constraints)
    fileprivate func loadCustomSegmentControl() {
        
        tipSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        tipSegmentControl.backgroundColor = .clear
        tipSegmentControl.tintColor = .clear
        
        // Style the segment control
        tipSegmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Lato-Light", size: 20)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .normal)
        
        tipSegmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Lato-Semibold", size: 20)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .selected)
  
        tipSegmentControl.apportionsSegmentWidthsByContent = true
        navigatorBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Segment control anchors (tipSegmentParentView)
        tipSegmentControl.topAnchor.constraint(equalTo: self.tipSegmentParentView.topAnchor, constant: 10).isActive = true
        tipSegmentControl.bottomAnchor.constraint(equalTo: self.tipSegmentParentView.bottomAnchor, constant: -10).isActive = true
        tipSegmentControl.leadingAnchor.constraint(equalTo: self.tipSegmentParentView.leadingAnchor, constant: 3).isActive = true
        tipSegmentControl.trailingAnchor.constraint(equalTo: self.tipSegmentParentView.trailingAnchor, constant: -3).isActive = true
        
        
        tipSegmentParentView.insertSubview(navigatorBar, belowSubview: tipSegmentControl)
        
        // SEGMENT CONTROL BACKGROUND ANIMATION SLIDER
        
        navigatorBar.topAnchor.constraint(equalTo: self.tipSegmentParentView.topAnchor, constant: 0).isActive = true
        //navigatorBar.heightAnchor.constraint(equalToConstant: self.tipSegmentParentView.bounds.height).isActive = true
        navigatorBar.widthAnchor.constraint(equalToConstant: self.tipSegmentParentView.bounds.width/4).isActive = true
        //self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
       
        navigatorBar.clipsToBounds = true
        self.navigatorBar.layer.masksToBounds = false;

        tipSegmentParentView.bottomAnchor.constraint(equalTo: navigatorBar.bottomAnchor).isActive = true
        navigatorBar.backgroundColor = UIColor.PinkOverlay()
       
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         loadSavedRoundingPreferences()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.traitCollection.userInterfaceStyle == .dark {
            print("Dark mode")
        } else {
            print("Light mode")
        }
        
        self.title = "Tipie"
        
        userSelectedZero = false
        // Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.userChoseRounding(_:)),name: NSNotification.Name(rawValue: notificationKey),object: nil)
       
        self.cleanSlate = false
        self.splitButton.isEnabled = false
        
        loadCustomSegmentControl()
        hideSplitSublabels()
       styleTipControllerContainer()
        iniiateConstraintReferences()
        // Keyboard Inits
        for buttonLabels in keyboardOutlets {
         buttonLabels.titleLabel?.font = buttonLabels.titleLabel?.font.withSize(self.view.frame.height * relativeFontConstant)
        }
        
        // Dynamic labels
//        self.dueLabel.font = dueLabel.font.withSize(self.view.frame.height * relativeFontConstant)
//        self.tipLabel.font = tipLabel.font.withSize(self.view.frame.height * relativeFontConstant)
//        self.totalLabel.font = totalLabel.font.withSize(self.view.frame.height * relativeFontConstant)
        
        
        
        // Static labels
       
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont(name: "Lato-Light", size: 24)!
        ]
        

        navigationController?.navigationBar.titleTextAttributes = attributes
        selectedFeedbackGenerator.prepare()
        self.tipSegmentControl.isEnabled = false
        self.overlayTouchArea.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func loadSavedRoundingPreferences() {
        tipRoundingAvailable = UserDefaults.standard.bool(forKey: "rounding")
    }
    
    func hideSplitSublabels() {
        yourTipValueLabel.isHidden = true
        yourTipLabel.isHidden = true
        
        yourTotalLabel.isHidden = true
        yourTotalValue.isHidden = true
    }
    
    func iniiateConstraintReferences() {
        // Set all init lables to false for the default constraints
        self.tipSegmentControl.isHidden = false // TODO: - UNHIDE SEGMENT CONTROL
        
        dueIconReference.translatesAutoresizingMaskIntoConstraints = false
        tipIconReference.translatesAutoresizingMaskIntoConstraints = false
        totalIconReference.translatesAutoresizingMaskIntoConstraints = false
       // totalIconReference.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - IF ERRORS, LOOK HERE FOR THE CONSTRAIN REFERENCE
        dueLabel.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Titled Due label
        titledDueLabel.translatesAutoresizingMaskIntoConstraints = false
        titledDueLabel.topAnchor.constraint(equalTo: self.dueParentView.topAnchor, constant: 10).isActive = true
        titledDueLabel.leadingAnchor.constraint(equalTo: self.dueIconReference.trailingAnchor, constant: 8).isActive = true
        // optional bottom constraint
        titledDueLabel.bottomAnchor.constraint(equalTo: self.dueParentView.bottomAnchor, constant: -10).isActive = true
        
        // Due label constraints
        dueIconReference.contentMode = .scaleAspectFit
        dueIconReference.leadingAnchor.constraint(equalTo: self.dueParentView.leadingAnchor, constant: 8).isActive = true
        dueIconReference.heightAnchor.constraint(equalToConstant: self.dueParentView.bounds.height - 45).isActive = true
        dueIconReference.widthAnchor.constraint(equalToConstant: self.dueParentView.bounds.height - 45).isActive = true
        dueIconReference.centerYAnchor.constraint(equalTo: self.dueParentView.centerYAnchor, constant: 0).isActive = true
        
        dueLabel.topAnchor.constraint(equalTo: self.dueParentView.topAnchor, constant: 10).isActive = true
        dueLabel.trailingAnchor.constraint(equalTo: self.dueParentView.trailingAnchor, constant: -10).isActive = true
        dueLabel.leadingAnchor.constraint(equalTo: self.titledDueLabel.trailingAnchor, constant: 0).isActive = true
        dueLabel.bottomAnchor.constraint(equalTo: self.dueParentView.bottomAnchor, constant: -10).isActive = true
        
        // end
        // Total constraints
        totalIconReference.contentMode = .scaleAspectFit
        totalIconReference.leadingAnchor.constraint(equalTo: self.totalParentView.leadingAnchor, constant: 8).isActive = true
        totalIconReference.heightAnchor.constraint(equalToConstant: self.totalParentView.bounds.height - 45).isActive = true
        totalIconReference.widthAnchor.constraint(equalToConstant: self.totalParentView.bounds.height - 45).isActive = true
        totalIconReference.centerYAnchor.constraint(equalTo: self.totalParentView.centerYAnchor, constant: 0).isActive = true
        
        totalLabel.topAnchor.constraint(equalTo: self.totalParentView.topAnchor, constant: 10).isActive = true
        totalLabel.trailingAnchor.constraint(equalTo: self.totalParentView.trailingAnchor, constant: -10).isActive = true
        totalLabel.leadingAnchor.constraint(equalTo: self.titledTotalLabel.trailingAnchor, constant: 0).isActive = true
       // totalLabel.bottomAnchor.constraint(equalTo: self.totalParentView.bottomAnchor, constant: -10).isActive = true
      
     
//        totalLabel.layer.borderWidth = 1
//        titledTotalLabel.layer.borderWidth = 1
        /****  MARK: DUE DYNAMIC CONSTRAINTS ****/
        titledTipLabel.translatesAutoresizingMaskIntoConstraints = false
       
        tipIconReference.contentMode = .scaleAspectFit
        // Image constraint
        tipIconReference.leadingAnchor.constraint(equalTo: self.tipParentView.leadingAnchor, constant: 8).isActive = true
        tipIconReference.heightAnchor.constraint(equalToConstant: self.tipParentView.bounds.height - 45).isActive = true
        tipIconReference.widthAnchor.constraint(equalToConstant: self.tipParentView.bounds.height - 45).isActive = true
        tipIconReference.centerYAnchor.constraint(equalTo: self.tipParentView.centerYAnchor, constant: 0).isActive = true
        
        // Tip label (default dynamic label)
        bottomTipLabelConstrain = tipLabel.bottomAnchor.constraint(equalTo: self.tipParentView.bottomAnchor, constant: -10)
        tipLabel.topAnchor.constraint(equalTo: self.tipParentView.topAnchor, constant: 10).isActive = true
        tipLabel.trailingAnchor.constraint(equalTo: self.tipParentView.trailingAnchor, constant: -10).isActive = true
        
        // Tip label title only**
        bottomTitledTipLabelConstrain = titledTipLabel.bottomAnchor.constraint(equalTo: self.tipParentView.bottomAnchor, constant: -10)
        titledTipLabel.topAnchor.constraint(equalTo: self.tipParentView.topAnchor, constant: 10).isActive = true
        titledTipLabel.leadingAnchor.constraint(equalTo: self.tipIconReference.trailingAnchor, constant: 8).isActive = true
        
        // Constraints below are defined to work as normal constraints
        tipLabel.leadingAnchor.constraint(equalTo: self.titledTipLabel.trailingAnchor, constant: 0).isActive = true
        
        /****  MARK: TOTAL DYNAMIC CONSTRAINTS ****/
         titledTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Total label title only**
        bottomTitledTotalLabelConstraint = titledTotalLabel.bottomAnchor.constraint(equalTo: self.totalParentView.bottomAnchor, constant: -10)
        titledTotalLabel.topAnchor.constraint(equalTo: self.totalParentView.topAnchor, constant: 10).isActive = true
        titledTotalLabel.leadingAnchor.constraint(equalTo: self.totalIconReference.trailingAnchor, constant: 8).isActive = true
        
        // Total label (default dynamic label)
        bottomTotalLabelConstrain = totalLabel.bottomAnchor.constraint(equalTo: self.totalParentView.bottomAnchor, constant: -10)
        totalLabel.topAnchor.constraint(equalTo: self.totalParentView.topAnchor, constant: 10).isActive = true
        totalLabel.trailingAnchor.constraint(equalTo: self.totalParentView.trailingAnchor, constant: -10).isActive = true
        
        bottomTitledTotalLabelConstraint?.isActive = true
        bottomTotalLabelConstrain?.isActive = true
        
        bottomTipLabelConstrain?.isActive = true // Pins the tip label 10 points from the parent bottom
        bottomTitledTipLabelConstrain?.isActive = true
    }
    
    func styleTipControllerContainer() {
        
        self.segmentControlParentView.backgroundColor = UIColor.TipiePink()
    }
    
  
    // MARK: - CUSTOM SEGMENTED CONTROL PROGRAMMATICALLY
//     func initiateCustomSegmentControl() {
//
//        customSegmentControlView.translatesAutoresizingMaskIntoConstraints = false
//
//        // Custom
//
//
//        segmentControlParentView.addSubview(customSegmentControlView)
//
//            // Constraints
//
//            customSegmentControlView.topAnchor.constraint(equalTo: self.segmentControlParentView.topAnchor, constant: 0).isActive = true
//            customSegmentControlView.bottomAnchor.constraint(equalTo: self.segmentControlParentView.bottomAnchor, constant: 0).isActive = true
//            customSegmentControlView.leadingAnchor.constraint(equalTo: self.segmentControlParentView.leadingAnchor, constant: 0).isActive = true
//            customSegmentControlView.trailingAnchor.constraint(equalTo: self.segmentControlParentView.trailingAnchor, constant: 0).isActive = true
//    }
    
    
    
    private func instantiateSubLabelConstraints(enableConstraints: Bool, count: Int) {
        
        yourTipLabel.translatesAutoresizingMaskIntoConstraints = false
        yourTipValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        yourTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        yourTotalValue.translatesAutoresizingMaskIntoConstraints = false
        
        if (enableConstraints == true) {
            DispatchQueue.main.async {
                self.yourTipLabel.leadingAnchor.constraint(equalTo: self.tipIconReference.trailingAnchor, constant: 8).isActive = true
                self.yourTipLabel.bottomAnchor.constraint(equalTo: self.tipParentView.bottomAnchor, constant: -10).isActive = true
                self.yourTipLabel.topAnchor.constraint(equalTo: self.tipLabel.bottomAnchor, constant: 0).isActive = true
                self.yourTipValueLabel.topAnchor.constraint(equalTo: self.tipLabel.bottomAnchor, constant: 0).isActive = true
                self.yourTipValueLabel.trailingAnchor.constraint(equalTo: self.tipParentView.trailingAnchor, constant: -10).isActive = true
                self.yourTipValueLabel.leadingAnchor.constraint(equalTo: self.yourTipLabel.trailingAnchor, constant: 0).isActive = true
                self.yourTipValueLabel.bottomAnchor.constraint(equalTo: self.tipParentView.bottomAnchor, constant: -10).isActive = true
                
                // Total cell
                self.yourTotalLabel.leadingAnchor.constraint(equalTo: self.totalIconReference.trailingAnchor, constant: 8).isActive = true
                self.yourTotalLabel.bottomAnchor.constraint(equalTo: self.totalParentView.bottomAnchor, constant: -10).isActive = true
                self.yourTotalLabel.topAnchor.constraint(equalTo: self.totalLabel.bottomAnchor, constant: 0).isActive = true
                self.yourTotalValue.topAnchor.constraint(equalTo: self.totalLabel.bottomAnchor, constant: 0).isActive = true
                self.yourTotalValue.trailingAnchor.constraint(equalTo: self.totalParentView.trailingAnchor, constant: -10).isActive = true
                self.yourTotalValue.leadingAnchor.constraint(equalTo: self.yourTotalLabel.trailingAnchor, constant: 0).isActive = true
                self.yourTotalValue.bottomAnchor.constraint(equalTo: self.totalParentView.bottomAnchor, constant: -10).isActive = true
            }
        } else if count < 2{
            //print("Disabling them")
            self.yourTipLabel.leadingAnchor.constraint(equalTo: self.tipIconReference.trailingAnchor, constant: 0).isActive = false
            self.yourTipLabel.bottomAnchor.constraint(equalTo: self.tipParentView.bottomAnchor, constant: -10).isActive = false
            self.yourTipLabel.topAnchor.constraint(equalTo: self.tipLabel.bottomAnchor, constant: 0).isActive = false
            self.yourTipValueLabel.topAnchor.constraint(equalTo: self.tipLabel.bottomAnchor, constant: 0).isActive = false
            self.yourTipValueLabel.trailingAnchor.constraint(equalTo: self.tipParentView.trailingAnchor, constant: -10).isActive = false
            self.yourTipValueLabel.leadingAnchor.constraint(equalTo: self.yourTipLabel.trailingAnchor, constant: 0).isActive = false
            self.yourTipValueLabel.bottomAnchor.constraint(equalTo: self.tipParentView.bottomAnchor, constant: -10).isActive = false
        }
       
    }
    
    
    func resetSegmentBarPosition() {
        UIView.animate(withDuration: 0.2) {
             self.navigatorBar.frame.origin.x = (self.tipSegmentParentView.frame.width / CGFloat(self.tipSegmentControl.numberOfSegments)) * CGFloat(self.tipSegmentControl.selectedSegmentIndex)
        }
    }
    
    
    @IBAction func tipControl(_ sender: Any) {
        
        selectedFeedbackGenerator.impactOccurred()
        selectedIndex = tipSegmentControl.selectedSegmentIndex
        
        // Update the Bottom bar
        UIView.animate(withDuration: 0.2) {
            
            self.navigatorBar.frame.origin.x = (self.tipSegmentParentView.frame.width / CGFloat(self.tipSegmentControl.numberOfSegments)) * CGFloat(self.tipSegmentControl.selectedSegmentIndex)
        }
        
        guard displayQuantity != 0.0 else {
            return
        }
        
       
        
        switch tipSegmentControl.selectedSegmentIndex {
        case 0:
            tip = displayQuantity * TipPercentage.Fiften.rawValue
            total = displayQuantity + tip
            self.animateLabelsWith(tip: tip, total: total)

        case 1:
            tip = displayQuantity * TipPercentage.Twenty.rawValue
             total = displayQuantity + tip
          
            self.animateLabelsWith(tip: tip, total: total)

        case 2:
            tip = displayQuantity * TipPercentage.TwentyFive.rawValue
            total = displayQuantity + tip
            self.animateLabelsWith(tip: tip, total: total)

        case 3:
            slideCustomViewWithType(type: .Tip)
           
        default:
           return
        }
    }
    
 
    
      // MARK: - SPLIT BILL
    @IBAction func splitBillView(_ sender: Any) {
        splitButtonReference.isEnabled = false
        slideCustomViewWithType(type: .Split)
    }
    
    // MARK: DELEGATES
    func updateTipPercentage(currentPercentage: Float?) {
        if let percentile = currentPercentage {
           let roundedValue = (percentile * 100).rounded() / 100
            computeCustomTip(input: roundedValue)
        }
    }
    
    // TODO: - NEW DELEGATES
    func updateTipPercentageTo(currentPercentage: Float?) {
        if let percentile = currentPercentage {
            let roundedValue = (percentile * 100).rounded() / 100
            computeCustomTip(input: roundedValue)
        }
    }


    // MARK: - ROUNDING NOTIFICATION METHOD
    @objc func userChoseRounding(_ notification:Notification) {
        
        if let data = notification.userInfo as? [String: Bool]{
            if data["on"] == true {
                roundingDefaults.set(true, forKey: "rounding")
            } else if data["off"] == false {
                roundingDefaults.set(false, forKey: "rounding")
            }
        }
    }
    
   
    // TODO: *******************    ROUND ALL INPUT NUMBERS *************************
    func updateNumberOfPeopleSplit(count: Int?) {
        
        // Without affecting the global amount due, I am using local variables to compute the tip
        let splitTotalAmount = displayQuantity
        let splitTipAmount = tip
        
        if let amount = count {
            // Compute the bill
            
            if (amount > 1) {
                // Halve all the elements that are dynamic
                bottomTipLabelConstrain?.constant = -(self.tipParentView.bounds.height/2)
                bottomTitledTipLabelConstrain?.constant = -(self.tipParentView.bounds.height/2)
                
                bottomTotalLabelConstrain?.constant = -(self.totalParentView.bounds.height/2)
                bottomTitledTotalLabelConstraint?.constant = -(self.totalParentView.bounds.height/2)
                self.instantiateSubLabelConstraints(enableConstraints: true, count: amount)
                UIView.animate(withDuration: 0.2) {
                    self.yourTipLabel.isHidden = false
                    self.yourTipValueLabel.isHidden = false
                    
                    self.yourTotalLabel.isHidden = false
                    self.yourTotalValue.isHidden = false
                    self.view.layoutIfNeeded()
                }
                
                layoutInPlace = false
                // Master label
                tipLabel.font = tipLabel.font.withSize(27)
                // Sublabel
                yourTipValueLabel.font = yourTipValueLabel.font.withSize(27)
           
                let tipYouGive = splitTipAmount/Float(amount)
                let totalSplit = splitTotalAmount/Float(amount)
                let grandTotalDueByPerson = tipYouGive + totalSplit
                
                // Check to see user toggled rounded option. if so, round the tip
                if let roundedBoolean = tipRoundingAvailable {
                    
                    if (roundedBoolean) {
                      
                        // Hidden split labels
                        yourTipValueLabel.text = String(format: "$%0.2f", tipYouGive.rounded())
                        yourTotalValue.text = String(format: "$%0.2f", grandTotalDueByPerson.rounded())
                        
                    } else {
                        // Hidden split label
                         yourTipValueLabel.text = String(format: "$%0.2f", tipYouGive)
                         yourTotalValue.text = String(format: "$%0.2f", grandTotalDueByPerson)
                    }
                }
                
            }
            else if (amount == 1) {
                // Close all halves of constrains to a single entity
                slideTipComponentsAway(sliderType: .Split)
                layoutInPlace = true
            }
        }
    }
    
    func slideTipComponentsAway(sliderType: SliderType) {
      
        if sliderType == .Split {
            if !layoutInPlace {
                self.bottomTipLabelConstrain?.constant = -10
                self.bottomTitledTipLabelConstrain?.constant = -10
                
                self.bottomTotalLabelConstrain?.constant = -10
                self.bottomTitledTotalLabelConstraint?.constant = -10
                
                self.instantiateSubLabelConstraints(enableConstraints: false, count: 0)
                // Animation
//                self.tipLabel.textColor = UIColor.black
//                self.titledTipLabel.textColor = UIColor.black
//                self.titledTotalLabel.textColor = UIColor.black
//                self.totalLabel.textColor = UIColor.black
                
                UIView.animate(withDuration: 0.2) {
                    
                    // Set the opacity back to default
                   
                    
                    self.yourTipValueLabel.isHidden = true
                    self.yourTipLabel.isHidden = true
                    self.yourTotalValue.isHidden = true
                    self.yourTotalLabel.isHidden = true
                    self.resetLabelFontSizes()
                    self.view.layoutIfNeeded()
                }
            }
            layoutInPlace = true
        }
     
    }
    
    fileprivate func resetLabelFontSizes() {
       
        self.tipLabel.font = self.tipLabel.font.withSize(27)
    }
    
    // MARK: - SLIDER CALCULATION
    func computeCustomTip(input: Float!)  {
        print("Recieved: \(input!)")
        tip = displayQuantity * Float(input)
        total = displayQuantity + self.tip
        animateLabelsWith(tip: tip, total: total)
    }

    
    // MARK: - ANIMATION & TIP ROUNDING HANDLING METHOD
    fileprivate func animateLabelsWith(tip: Float, total: Float) {
        
        // Toggled rounding
        if let roundedBoolean = tipRoundingAvailable {
            if (roundedBoolean) {
                let userDefinedRoundingTip = tip
                let userDefinedRoundingTotal = total
                UIView.animate(withDuration: 0.2) {
                    self.tipLabel.text = String(format: "$%0.2f", userDefinedRoundingTip.rounded())
                    self.totalLabel.text = String(format: "$%0.2f", userDefinedRoundingTotal.rounded())
                }
            } else {
                // This is only handled if the user has not toggled 'rounding' in settings
                let localUnroundedValueTip = (tip * 100).rounded() / 100
                let localUnroundedTotal = (total * 100).rounded() / 100
                UIView.animate(withDuration: 0.2) {
                    self.tipLabel.text = String(format: "$%0.2f", localUnroundedValueTip)
                    self.totalLabel.text = String(format: "$%0.2f", localUnroundedTotal)
                }
            }
        }

    }
    
    
    
    // MARK: - Slider Component
    
    func slideCustomViewWithType(type: SliderType) {
      
     // Determine the type of slider that will be invoked in this segment
        
        typeSlider = Slider(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3))
        typeSlider?.translatesAutoresizingMaskIntoConstraints = false
        if let slider = typeSlider {
            splitButtonReference.isEnabled = false // MARK: - IF ERROR, LOOK HERE
            slider.style(slidertype: type)
            view.addSubview(slider)
            view.addSubview(overlayTouchArea)
            slider.delegate = self
            // Touch area
            overlayTouchArea.backgroundColor = UIColor.clear
            overlayTouchArea.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            overlayTouchArea.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            overlayTouchArea.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: 0).isActive = true
            invokeTouchArea()
            
            
            
            // FIXME: - Fixing the view to end at the bottom of the total view bottom
            // slider.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height/2) + 60).isActive = true
            self.tipSegmentParentView.topAnchor.constraint(equalTo: slider.topAnchor, constant: 0).isActive = true
            slider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        
        }
    }
    

    // Remove from the main view
    @objc func slideViewDown() {

        if let slider = typeSlider {
        
            // MAK: - Computing the overall height of the main view to be dismissed
            //slider.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height/2) + 60).isActive = true
            self.tipSegmentParentView.topAnchor.constraint(equalTo: slider.topAnchor, constant: 0).isActive = true
            slider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
           
            slideTipComponentsAway(sliderType: slider.getSliderType())
            
            UIView.animate(withDuration: 0.2, animations: {
                
                // Slide the view down below the bottom anchor of the main view
                slider.center = CGPoint(x: self.view.center.x, y: self.view.frame.height + self.typeSlider!.frame.height/2)
                self.view.layoutIfNeeded()
                
            }, completion: { (s) in
                
                slider.removeFromSuperview()
                self.overlayTouchArea.removeFromSuperview()
                self.typeSlider = nil
            })
            
        }
        splitButtonReference.isEnabled = true
        
        
       
    }
    
    // MARK: - Overlay custom area
    func invokeTouchArea() {
        tapGestureRecorgnizer = UITapGestureRecognizer(target: self, action: #selector(self.slideViewDown))
        overlayTouchArea.addGestureRecognizer(tapGestureRecorgnizer!)
    }
    
    
    
    
}
