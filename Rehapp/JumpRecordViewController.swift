//
//  JumpRecordViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 29.06.15.
//  Copyright (c) 2015 Tim Haug. All rights reserved.
//

import UIKit

class JumpRecordViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var isCollectingData = false
    var sensorDataSession = SensorDataSession()

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var footTextField: UITextField!
    @IBOutlet var additionalInfoTextField: UITextField!
    @IBOutlet var jumpNumberLabel: UILabel!
    @IBOutlet var jumpNumberStepper: UIStepper!
    @IBOutlet var sensor1Label: UILabel!
    @IBOutlet var sensor2Label: UILabel!
    @IBOutlet var sensor3Label: UILabel!
    
    let genderOptions = ["Female", "Male"]
    let footOptions = ["Left foot", "Right foot"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        genderTextField.inputView = pickerView
        footTextField.inputView = pickerView
    }
    
    override func viewDidAppear(animated: Bool) {
        self.updateJumpNumberUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func jumpNumberChanged(sender: UIStepper) {
        self.setJumpNumber(Int(sender.value))
    }

    @IBOutlet var performAction: UIButton!
    @IBAction func performAction(sender: AnyObject) {
        self.sensorDataSession.startStopMeasurement{
            print(self.sensorDataSession.allSensorData())
        }
    }
    
    //MARK: -Store and save Jump Number to NSUserDefaults
    private func setJumpNumber(newJumpNumber: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(newJumpNumber, forKey: "captureJumpNumber")
        self.updateJumpNumberUI()
    }
    
    func jumpNumber() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("captureJumpNumber")
    }
    
    func updateJumpNumberUI() {
        let currentJumpNumber = jumpNumber()
        self.jumpNumberLabel.text = "\(currentJumpNumber)"
        self.jumpNumberStepper.value = Double(currentJumpNumber)
    }
    
    //MARK: -PickerViewDelegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if genderTextField.editing {
            return genderOptions.count
        } else {
            return footOptions.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if genderTextField.editing {
            return genderOptions[row]
        } else {
            return footOptions[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if genderTextField.editing {
            genderTextField.text = genderOptions[row]
        } else {
            footTextField.text = footOptions[row]
        }
    }
    

}

