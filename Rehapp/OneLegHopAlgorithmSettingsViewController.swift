//
//  AlgorithmDetailViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 21.09.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation
import UIKit

class OneLegHopAlgorithmSettingsViewController: UIViewController {
    
    @IBOutlet var startThresholdLabel: UILabel!
    @IBOutlet var endThresholdLabel: UILabel!
    @IBOutlet var startThresholdSlider: UISlider!
    @IBOutlet var endThresholdSlider: UISlider!
    @IBOutlet var additionLabel: UILabel!
    @IBOutlet var additionSlider: UISlider!
    @IBOutlet var intervalLabel: UILabel!
    @IBOutlet var intervalSlider: UISlider!
    @IBOutlet var deviationLabel: UILabel!
    @IBOutlet var deviationSlider: UISlider!
    
    @IBAction func runAlgorithmButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func startThresholdSliderChanged(sender: AnyObject) {
        setStartThreshold(Int(startThresholdSlider.value))
    }
    
    @IBAction func endThresholdSliderChanged(sender: AnyObject) {
        setEndThreshold(Int(endThresholdSlider.value))
    }
    
    @IBAction func additionSliderChanged(sender: AnyObject) {
        setAddition(Int(additionSlider.value))
    }
    
    @IBAction func intervalSliderChanged(sender: AnyObject) {
        setInterval(Int(intervalSlider.value))
    }
    
    @IBAction func deviationSliderChanged(sender: AnyObject) {
        setDeviation(Int(deviationSlider.value))
    }
    
//    let defaults = NSUserDefaults.standardUserDefaults()
    
    
//    var startThreshold: Int = 200
//    var endThreshold: Int = 200
//    var addition: Int = 40
//    var interval: Int = 5
//    var deviation: Int = 10
    
    var name: String!
    
    override func viewDidLoad() {
        
        self.title = "One Leg Hop"
        
        startThresholdLabel.text = "Start Threshold: \(startThreshold())"
        startThresholdSlider.value = Float(startThreshold())
        
        endThresholdLabel.text = "End Threshold: \(endThreshold())"
        endThresholdSlider.value = Float(endThreshold())
        
        additionLabel.text = "Addition: \(addition())"
        additionSlider.value = Float(addition())
        
        intervalLabel.text = "Interval: \(interval())"
        intervalSlider.value = Float(interval())
        
        deviationLabel.text = "Deviation: \(deviation())"
        deviationSlider.value = Float(deviation())
        
        
    }
    
    func runAlgorithm() {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOneLegHopAlgorithmResultViewController" {
//            let destination = segue.destinationViewController as! AlgorithmResultViewController
//            destination.startThreshold = startThreshold

            
        }
    }
    
    func setStartThreshold(newStartThreshold: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(newStartThreshold, forKey: "startThreshold")
        self.startThresholdLabel.text = "Start Threshold: \(newStartThreshold)"
    }
    
    func startThreshold() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("startThreshold")
    }
    
    
    func setEndThreshold(newEndThreshold: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(newEndThreshold, forKey: "endThreshold")
        self.endThresholdLabel.text = "End Threshold: \(newEndThreshold)"
    }
    
    func endThreshold() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("endThreshold")
    }
    
    
    func setAddition(newAddition: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(newAddition, forKey: "addition")
        self.additionLabel.text = "Addition: \(newAddition)"
    }
    
    func addition() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("addition")
    }
    
    
    func setInterval(newInterval: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(newInterval, forKey: "interval")
        self.intervalLabel.text = "Interval: \(newInterval)"
    }
    
    func interval() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("interval")
    }

    
    func setDeviation(newDeviation: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(newDeviation, forKey: "deviation")
        self.deviationLabel.text = "Deviation: \(newDeviation)"
    }
    
    func deviation() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("deviation")
    }

    
}
