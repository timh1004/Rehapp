//
//  RecordInfoViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 14.09.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation
import UIKit

class RecordInfoViewController: UIViewController {
    
    @IBOutlet var exerciseLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var footLabel: UILabel!
    @IBOutlet var jumpDistanceTextField: UITextField!
    @IBOutlet var jumpDistanceLabel: UILabel!
    @IBOutlet var jumpCountTextField: UITextField!
    @IBOutlet var jumpCountLabel: UILabel!
    @IBOutlet var jumpDurationTextField: UITextField!
    @IBOutlet var additionalInformationTextView: UITextView!
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        saveRecord()
    }

    
    var record: Record!
    
    override func viewDidLoad() {
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonTapped:"), animated: true)
    
        if record.isSideHops {
            exerciseLabel.text = "Side Hops"
            jumpDistanceTextField.hidden = true
            jumpDistanceLabel.hidden = true
        } else {
            exerciseLabel.text = "One-Leg Hop"
            jumpCountTextField.hidden = true
            jumpCountLabel.hidden = true
            
        }
        
        print(record.description)
        
        nameLabel.text = record.name
        ageLabel.text = "\(record.age) years"
        weightLabel.text = "\(record.weightInKg) kg"
        heightLabel.text = "\(record.heightInCm) cm"
        
        if record.gender {
            genderLabel.text = "female"
        } else {
            genderLabel.text = "male"
        }
        
        if record.foot {
            footLabel.text = "left foot"
        } else {
            footLabel.text = "right foot"
        }
        
        jumpDistanceTextField.text = String(record.jumpDistanceInCm)
        jumpCountTextField.text = String(record.jumpCount)
        jumpDurationTextField.text = String(record.jumpDurationInMs)
        
        additionalInformationTextView.text = record.additionalInformation
        
        // Algorithmus
        
        if record.isSideHops {
            
            let minThreshold = NSUserDefaults.standardUserDefaults().integerForKey("minThreshold")
            let maxThreshold = NSUserDefaults.standardUserDefaults().integerForKey("maxThreshold")
            print("Min: \(minThreshold), Max: \(maxThreshold)")
            
            print("\(SideHopsAlgorithm.calculateJumpCount(record, minThreshold: minThreshold, maxThreshold: maxThreshold))")
        } else {
            
            let startThreshold = NSUserDefaults.standardUserDefaults().integerForKey("startThreshold")
            let endThreshold = NSUserDefaults.standardUserDefaults().integerForKey("maxThreshold")
            print(OneLegHopAlgorithm.calculateResultDict(record, startThreshold: startThreshold, endThreshold: endThreshold))
            
        }

        
    }
    
    func saveRecord() {
        let sensorDataDictionaries = record.sensorData.map({sensorData in sensorData.toDictionary()})
        
        let newJumpDistance: Int = Int(jumpDistanceTextField.text!)!
        let newJumpDuration: Int = Int(jumpDurationTextField.text!)!
        let newJumpCount: Int = Int(jumpCountTextField.text!)!
        let recordDictionary = ["id":record.id, "isSideHops":record.isSideHops, "name":record.name, "weightInKg":(String(record.weightInKg)), "heightInCm":(String(record.heightInCm)), "age":(String(record.age)), "gender":record.gender, "foot":record.foot, "additionalInformation":record.additionalInformation ,"jumpDistanceInCm":newJumpDistance, "jumpDurationInMs":newJumpDuration, "jumpCount":newJumpCount, "sensorData": sensorDataDictionaries]
        let json = JSON(recordDictionary)
        let jsonString = json.description
        FileHandler.writeToFile("\(record.id).json", content: jsonString)
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}