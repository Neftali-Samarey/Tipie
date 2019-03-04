//
//  ViewController.swift
//  Tippin'
//
//  Created by Neftali Samarey on 1/17/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

// NOTES: If Percentage is selected before input is made, 0 index value will be calculated first.

import UIKit

enum TipPercentage : Float {
    case Fiften = 0.15
    case Twenty = 0.20
    case TwentyFive = 0.25
}

class ViewController: UIViewController, SliderPercentageInputDelegate, didSlideThroughDelegate {
   
    var typeSlider : Slider?
    
    // LABELS
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    // IMAGE REFERENCES
    @IBOutlet weak var tipIconReference: UIImageView!
    
    // Dynamic labels
    @IBOutlet weak var titledTipLabel: UILabel!
    
    @IBOutlet weak var tipParentView: UIView!
    @IBOutlet weak var totalParentView: UIView!
    
   
    
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
    
    // COMPUTING BASED ON INPUT
    @IBAction func actionKey(_ sender: UIButton) {
        
        selectedFeedbackGenerator.impactOccurred()
        
        self.tipSegmentControl.isEnabled = true
        self.splitButton.isEnabled = true
        
        // Remove the 0 during initial presentation
        if let slateClean = cleanSlate {
            if slateClean == false {
                self.dueLabel.text = ""
            }
        }
        
        cleanSlate = true
        
        self.dueLabel.text! = self.dueLabel.text! + String(sender.tag-1)
        print("Label Test: \(String(describing: self.appendExtranousCharacter(label: dueLabel!)))") // test
        displayQuantity = Float(self.dueLabel.text!)!
        
        //FIXME: - PROPOSED SOLUTION
        /*
         
        self.recievingInputString = self.recievingInputString + String(sender.tag-1)
        displayQuantity = Float(self.recievingInputString)!
        print("Display QTY: \(displayQuantity)")
 
        */
     
        
        // Hiding this label
//        self.dueLabel.isHidden = true
        
        // Set the dynamic label in place
//        let defLabel = appendExtranousCharacter(label: dueLabel!)
//        defLabel.frame = CGRect(x: 10, y: 10, width: 320, height: 30)
//       self.totalParentView.addSubview(defLabel)
        
        print("Zero: \(displayQuantity)")
       
        tip = displayQuantity * TipPercentage.Fiften.rawValue
        total = displayQuantity + tip
        
//        if let didCleanSlate = cleanSlate {
//           // print("Resporting: \(didCleanSlate)")
//        }
       
        self.tipLabel.text = String(format: "$%0.2f",tip)
        self.totalLabel.text = String(format: "$%0.2f",total)
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
           // self.recievingInputString = self.recievingInputString + decimalChar[sender.tag-1]! // MARK : - TEST (to be removed)
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
    
    
    // MARK: - Styling and constraining the Segmented control
    fileprivate func loadCustomSegmentControl() {
        
        tipSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        tipSegmentControl.backgroundColor = .clear
        tipSegmentControl.tintColor = .clear
        
        // Style the segment control
        tipSegmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Lato-Light", size: 20)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        tipSegmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Lato-Semibold", size: 20)!,
            NSAttributedString.Key.foregroundColor: UIColor.cleanIndigo()
            ], for: .selected)
  
        tipSegmentControl.apportionsSegmentWidthsByContent = true
        // Segment control anchors (tipSegmentParentView)
        tipSegmentControl.topAnchor.constraint(equalTo: self.tipSegmentParentView.topAnchor, constant: 10).isActive = true
        tipSegmentControl.bottomAnchor.constraint(equalTo: self.tipSegmentParentView.bottomAnchor, constant: -10).isActive = true
        tipSegmentControl.leadingAnchor.constraint(equalTo: self.tipSegmentParentView.leadingAnchor, constant: 3).isActive = true
        tipSegmentControl.trailingAnchor.constraint(equalTo: self.tipSegmentParentView.trailingAnchor, constant: -3).isActive = true
        
        // Segment control bottom view
      
        navigatorBar.translatesAutoresizingMaskIntoConstraints = false
        self.tipSegmentParentView.addSubview(navigatorBar)
        navigatorBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
        //navigatorBar.widthAnchor.constraint(equalTo: tipSegmentControl.widthAnchor, multiplier: 1 / CGFloat(tipSegmentControl.numberOfSegments)).isActive = true
        navigatorBar.widthAnchor.constraint(equalToConstant: self.tipSegmentParentView.bounds.width/4).isActive = true
        tipSegmentParentView.bottomAnchor.constraint(equalTo: navigatorBar.bottomAnchor).isActive = true
//        navigatorBar.frame = CGRect(x: 0, y: 0, width: 100, height: 10)
        navigatorBar.backgroundColor = UIColor.cleanIndigo()
       
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tipie"
        
        self.cleanSlate = false
        self.splitButton.isEnabled = false
        loadCustomSegmentControl()
        hideSplitSublabels()
       
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
        
        //FIXME: REMOVE()
       // layoutLabelBorderLines()
    }
    
    func hideSplitSublabels() {
        yourTipValueLabel.isHidden = true
        yourTipLabel.isHidden = true
    }
    
    func iniiateConstraintReferences() {
        // Set all init lables to false for the default constraints
        tipIconReference.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
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
        
        bottomTipLabelConstrain?.isActive = true // Pins the tip label 10 points from the parent bottom
        bottomTitledTipLabelConstrain?.isActive = true
    }
    
    private func instantiateSubLabelConstraints(enableConstraints: Bool, count: Int) {
        
        yourTipLabel.translatesAutoresizingMaskIntoConstraints = false
        yourTipValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if (enableConstraints == true) {
            DispatchQueue.main.async {
                self.yourTipLabel.leadingAnchor.constraint(equalTo: self.tipIconReference.trailingAnchor, constant: 8).isActive = true
                self.yourTipLabel.bottomAnchor.constraint(equalTo: self.tipParentView.bottomAnchor, constant: -10).isActive = true
                self.yourTipLabel.topAnchor.constraint(equalTo: self.tipLabel.bottomAnchor, constant: 0).isActive = true
                self.yourTipValueLabel.topAnchor.constraint(equalTo: self.tipLabel.bottomAnchor, constant: 0).isActive = true
                self.yourTipValueLabel.trailingAnchor.constraint(equalTo: self.tipParentView.trailingAnchor, constant: -10).isActive = true
                self.yourTipValueLabel.leadingAnchor.constraint(equalTo: self.yourTipLabel.trailingAnchor, constant: 0).isActive = true
                self.yourTipValueLabel.bottomAnchor.constraint(equalTo: self.tipParentView.bottomAnchor, constant: -10).isActive = true
            }
        } else if count < 2{
            print("Disabling them")
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
            //buttonBar.frame.origin.x = (segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)) * CGFloat(segmentedControl.selectedSegmentIndex)
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
           // sliderCustomView()
        default:
            print("No other selection made")
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
    
    func layoutLabelBorderLines() {
        
        self.titledTipLabel.layer.borderWidth = 1
        self.tipLabel.layer.borderWidth = 1
        self.yourTipLabel.layer.borderWidth = 1
        self.yourTipValueLabel.layer.borderWidth = 1
        self.tipIconReference.layer.borderWidth = 1
    }
   
    //FIXME: - FIX THIS METHOD
    // TODO: *******************    ROUND ALL INPUT NUMBERS *************************
    func updateNumberOfPeopleSplit(count: Int?) {
        
        let local_total = total
        let local_tip = tip
        
        if let amount = count {
            // Compute the bill
            
            if (amount > 1) {
                // Halve all the elements that are dynamic
                bottomTipLabelConstrain?.constant = -(self.tipParentView.bounds.height/2)
                bottomTitledTipLabelConstrain?.constant = -(self.tipParentView.bounds.height/2)
                self.instantiateSubLabelConstraints(enableConstraints: true, count: amount)
                UIView.animate(withDuration: 0.2) {
                    self.yourTipLabel.isHidden = false
                    self.yourTipValueLabel.isHidden = false
                    self.view.layoutIfNeeded()
                }
                
                layoutInPlace = false
                // Master label
                tipLabel.font = tipLabel.font.withSize(27)
                // Sublabel
                yourTipValueLabel.font = yourTipValueLabel.font.withSize(27)
                yourTipValueLabel.text = "\(local_tip)"
                
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
                self.instantiateSubLabelConstraints(enableConstraints: false, count: 0)
                // Animation
                UIView.animate(withDuration: 0.2) {
                    self.yourTipValueLabel.isHidden = true
                    self.yourTipLabel.isHidden = true
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
        animateLabelsWith(tip: tip, total: total) // pass by reference
    }

    
    // MARK: - ANIMATION
    fileprivate func animateLabelsWith(tip: Float, total: Float) {
        
        let roundedValueTip = (tip * 100).rounded() / 100
        let roundedTotal = (total * 100).rounded() / 100
//        print("Tip: \(roundedValueTip)\n Total: \(roundedTotal)")
        UIView.animate(withDuration: 0.2) {
            
            self.tipLabel.text = String(format: "$%0.2f", roundedValueTip)
            self.totalLabel.text = String(format: "$%0.2f", roundedTotal)
        }
        
    }
    
    
    
    // MARK: - Slider Component
    
    func slideCustomViewWithType(type: SliderType) {
        
        typeSlider = Slider(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3))
        
        typeSlider?.translatesAutoresizingMaskIntoConstraints = false
        if let slider = typeSlider {
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
    
    
    
//     func sliderCustomView() {
//
//        slider = Overlay(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3))
//        slider?.translatesAutoresizingMaskIntoConstraints = false
//        if let slider = slider {
//            view.addSubview(slider)
//            view.addSubview(overlayTouchArea)
//            slider.delegate = self
//            // Touch area
//            overlayTouchArea.backgroundColor = UIColor.clear
//            overlayTouchArea.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
//            overlayTouchArea.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//            overlayTouchArea.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: 0).isActive = true
//            invokeTouchArea()
//            // FIXME: - Fixing the view to end at the bottom of the total view bottom
//           // slider.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height/2) + 60).isActive = true
//            self.tipSegmentParentView.topAnchor.constraint(equalTo: slider.topAnchor, constant: 0).isActive = true
//            slider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//
//            UIView.animate(withDuration: 0.2, animations: {
//                self.view.layoutIfNeeded()
//            })
//            // end
//        }
//    }
    
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
