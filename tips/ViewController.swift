//
//  ViewController.swift
//  tips
//
//  Created by Dwipal Desai on 4/9/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

struct MyVariables {
    static var defaultTipPercentKey = "defaultTipPercent"
    static var lastBillKey = "lastBill"
    static var lastTipKey = "lastTipPercent"
    static var enteredBackgroundKey = "enteredBackground"
    static var endTimeKey = "startTimeKey"
}

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    
    
    var tipPercents = [0.18, 0.20, 0.22]
    var isFirstAppear = true
    
    
    func computeTipAndTotal(billStr: String) {
        println("IN COMPUTE")
        var billAmount = (billStr as NSString).doubleValue
        var tipPerc = tipPercents[tipSegment.selectedSegmentIndex]
        var tip = billAmount * tipPerc
        var total = billAmount + tip
        
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        
        if let numstr = formatter.stringFromNumber(total) {
            totalLabel.text = String (numstr)
        }
        
        if let numstr = formatter.stringFromNumber(tip) {
            tipLabel.text = String (numstr)
        }
    }
    
    
    
    func didEnterBackground () {
        var userDefault = NSUserDefaults.standardUserDefaults()
        
        //Save the bill amount before we go in the background.
        userDefault.setObject(billField.text, forKey: MyVariables.lastBillKey)
        userDefault.setInteger(tipSegment.selectedSegmentIndex, forKey: MyVariables.lastTipKey)
        
        //Save the time that we entered background
        let enddate = NSDate()
        println(enddate.description)
        userDefault.setObject(enddate, forKey: MyVariables.endTimeKey)
        NSLog ("Going in Background");
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("View will appear")
        
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var showLastBill = false
        //Check if view is appearing for the first time after app started
        if isFirstAppear {
            
            /* Check if view is appearing after a previous start of the app in which case we would have
               the last time it went to background, saved
            */
            if let savedTime = defaults.objectForKey(MyVariables.endTimeKey) as? NSDate{
                
                //Check if view is appearing within 600 sec of last time app started
                let elapsedTime = NSDate().timeIntervalSinceDate(savedTime)
                let duration = Int(elapsedTime)
                NSLog("Time elapsed since last active is \(duration)s")
                if elapsedTime < 60 {
                    showLastBill = true
                }
            }
            isFirstAppear = false
        }
    
        if showLastBill {
            //Load the last Bill Amount and tip percent
            if let billStr = defaults.objectForKey(MyVariables.lastBillKey) as? String{
                billField.text = billStr
                var tipSelectedSegment = defaults.integerForKey(MyVariables.lastTipKey)
                tipSegment.selectedSegmentIndex = tipSelectedSegment
                NSLog("REMEMBER")
            }
        } else {
            //Check if the default tip percent is previously saved
            if let defaults: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(MyVariables.defaultTipPercentKey) {
            
                // Read the segment number to be selected by default corresponding to tip percent that user had saved
                var segNum = NSUserDefaults.standardUserDefaults().integerForKey(MyVariables.defaultTipPercentKey)
                if segNum <= tipSegment.numberOfSegments {
                    tipSegment.selectedSegmentIndex = segNum
                } else {
                    tipSegment.selectedSegmentIndex = 0
                }
                
            } else {
                
                //No default percent was previously saved so, save it now
                var userDefault = NSUserDefaults.standardUserDefaults()
                
                //Save the 1st tip percent segment as default.
                userDefault.setInteger(0, forKey: MyVariables.defaultTipPercentKey)
            }
            
        }
        tipSegment.sendActionsForControlEvents(.ValueChanged)
        NSLog("Sending segment value changed with \(tipSegment.selectedSegmentIndex)")
    
        //Always let keyboard show
        billField.becomeFirstResponder()
    }

    override func viewDidAppear(animated: Bool) {
        NSLog("View did appear")
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.tipLabel.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
        //UIView.animateWithDuration(1.5,animations: { self.tipLabel.alpha = 1.0})
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("View did load")
        //Initialize tip & total
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        
        //Set up notifications for didEnterBackground
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        //Set flag to indicate this is a clean start of app vs starting from background
        isFirstAppear = true
        
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    @IBAction func onEditChange(sender: AnyObject) {
        //billField.borderStyle = UITextBorderStyle.None
        computeTipAndTotal(billField.text)
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
        //billField.borderStyle = UITextBorderStyle.Bezel
    }
    
}

