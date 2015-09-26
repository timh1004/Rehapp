//
//  SideHopsAlgorithmSettingsViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 24.09.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation
import UIKit

class SideHopsAlgorithmSettingsViewController: UIViewController {
    
    
    @IBOutlet var minThresholdLabel: UILabel!
    @IBOutlet var maxThresholdLabel: UILabel!
    @IBOutlet var deviationLabel: UILabel!
    @IBOutlet var minThresholdSlider: UISlider!
    @IBOutlet var maxThresholdSlider: UISlider!
    @IBOutlet var deviationSlider: UISlider!
    @IBOutlet var intervalLabel: UILabel!
    @IBOutlet var intervalSlider: UISlider!
    
    @IBAction func minThresholdSliderChanged(sender: AnyObject) {
//        minThresholdLabel.text = "Minimum Threshold: \(Int(minThresholdSlider.value))"
        setMinThreshold(Int(minThresholdSlider.value))

        
        
    }
    

    @IBAction func maxThresholdSliderChanged(sender: AnyObject) {
//        maxThresholdLabel.text = "Maximum Threshold: \(Int(maxThresholdSlider.value))"
        setMaxThreshold(Int(maxThresholdSlider.value))
    }
    
    @IBAction func deviationSliderChanged(sender: AnyObject) {
//        deviationLabel.text = "Deviation: \(Int(deviationSlider.value))"
        setSideHopsDeviation(Int(deviationSlider.value))
    }
    
    @IBAction func intervalSliderChanged(sender: AnyObject) {
//        intervalLabel.text = "Interval: \(Int(intervalSlider.value))"
        setSideHopsInterval(Int(intervalSlider.value))
    }
    
    override func viewDidLoad() {
        
        minThresholdLabel.text = "Minimum Threshold: \(minThreshold())"
        minThresholdSlider.value = Float(minThreshold())

        maxThresholdLabel.text = "Maximum Threshold: \(maxThreshold())"
        maxThresholdSlider.value = Float(maxThreshold())
        
        deviationLabel.text = "Deviation: \(sideHopsDeviation())"
        deviationSlider.value = Float(sideHopsDeviation())
        
        intervalLabel.text = "Interval: \(sideHopsInterval())"
        intervalSlider.value = Float(sideHopsInterval())
        
    }
    
    func setMinThreshold(newMinThreshold: Int) {
        self.minThresholdLabel.text = "Minimum Threshold: \(newMinThreshold)"
        NSUserDefaults.standardUserDefaults().setInteger(newMinThreshold, forKey: "minThreshold")
//        self.updateMinThresholdUI()
    }
    
    func minThreshold() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("minThreshold")
    }
    
    
    func setMaxThreshold(newMaxThreshold: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(newMaxThreshold, forKey: "maxThreshold")
        self.maxThresholdLabel.text = "Maximum Threshold: \(newMaxThreshold)"
    }
    
    func maxThreshold() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("maxThreshold")
    }
    
    
    func setSideHopsDeviation(newSideHopsDeviation: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(newSideHopsDeviation, forKey: "sideHopsDeviation")
        self.deviationLabel.text = "Deviation: \(newSideHopsDeviation)"
    }
    
    func sideHopsDeviation() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("sideHopsDeviation")
    }
    
    
    func setSideHopsInterval(newSideHopsInterval: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(newSideHopsInterval, forKey: "sideHopsInterval")
        self.intervalLabel.text = "Interval: \(newSideHopsInterval)"
    }
    
    func sideHopsInterval() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("sideHopsInterval")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSideHopsAlgorithmResultViewController" {
            
            
            
        }
    }
    
    
    
}
