//
//  UserViewController.swift
//  tips
//
//  Created by Dwipal Desai on 4/9/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var defaultTipSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onSelect(sender: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(defaultTipSegment.selectedSegmentIndex, forKey: MyVariables.defaultTipPercentKey)
        defaults.synchronize()
        
    }

    @IBAction func onTap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Read the segment number to be selected by default corresponding to tip percent that user had saved
        var intValue = NSUserDefaults.standardUserDefaults().integerForKey(MyVariables.defaultTipPercentKey)
    
        println ("index saved is \(intValue)")
        if intValue <= defaultTipSegment.numberOfSegments {
            defaultTipSegment.selectedSegmentIndex = intValue
        } else {
            defaultTipSegment.selectedSegmentIndex = 0
        }
        
    }
    
}
