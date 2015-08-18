//
//  JumpRecordViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 29.06.15.
//  Copyright (c) 2015 Tim Haug. All rights reserved.
//

import UIKit
import QuartzCore

class JumpRecordViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, SensorDataDelegate {
    
    var startDate: NSDate?
    var endDate: NSDate?
    
    var isCollectingData = false
    var communicationManager = ArduinoCommunicationManager.sharedInstance
    
    private var sensorDataArray: [SensorData] = []
    
//    var sensorDataSession = SensorDataSession()

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
    @IBOutlet var sensor1ForceView: UIView!
    @IBOutlet var sensor2ForceView: UIView!
    @IBOutlet var sensor3ForceView: UIView!
    @IBOutlet var startStopRecordingButton: UIButton!
    
    let genderOptions = ["Female", "Male"]
    let footOptions = ["Left foot", "Right foot"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        genderTextField.inputView = pickerView
        footTextField.inputView = pickerView
        
        sensor1ForceView.layer.cornerRadius = 25
        sensor2ForceView.layer.cornerRadius = 25
        sensor3ForceView.layer.cornerRadius = 25
        sensor1ForceView.layer.masksToBounds = true
        sensor2ForceView.layer.masksToBounds = true
        sensor3ForceView.layer.masksToBounds = true
        
        self.waitForBluetoothToStart { () -> () in
            self.communicationManager.startReceivingSensorData()
            self.communicationManager.sensorDataDelegate = self
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.updateJumpNumberUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func waitForBluetoothToStart(after: ()->()) -> Void {
        if (self.communicationManager.isAbleToReceiveSensorData()) {
            NSLog("After called")
            after()
        } else {
            delay(0.5) {
                self.waitForBluetoothToStart(after)
            }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    //MARK: -IBActions
    @IBAction func jumpNumberChanged(sender: UIStepper) {
        self.setJumpNumber(Int(sender.value))
    }


    @IBAction func startStopRecording(sender: UIButton) {
        let title:String = self.isCollectingData ? "Start Recording" : "Stop Recording"
        sender.setTitle(title, forState: .Normal)
        if (self.isCollectingData) {
            //            self.communicationManager.sensorDataDelegate = nil
            //            self.communicationManager.stopReceivingSensorData()
            self.isCollectingData = false
            self.endDate = NSDate()
            self.measurementDidFinish()
            //            onSuccess()
        } else {
            
            //                self.communicationManager.sensorDataDelegate = self
            //                self.communicationManager.startReceivingSensorData()
            self.isCollectingData = true
            self.startDate = NSDate()
            resetData()
            //                onSuccess()
            
        }
        
        
//        self.sensorDataSession.startStopMeasurement{
//            self.isCollectingData = !self.isCollectingData
//            let title:String = self.isCollectingData ? "Stop Recording" : "Start Recording"
//            sender.setTitle(title, forState: .Normal)
//            if (!self.isCollectingData) {
//                self.measurementDidFinish()
//            } else {
//                self.sensorDataSession.resetData()
//            }
//        }
    }
    
    func measurementDidFinish() {
//        let sensorData = sensorDataSession.allSensorData()
        let sensorDataDictionaries = sensorDataArray.map({sensorData in sensorData.toDictionary()})
        let jumpDictionary = ["id":jumpNumber(), "name":self.nameTextField.text as String!, "weightInKg":self.weightTextField.text as String!, "heightInMeter":self.heightTextField.text as String!, "age":self.ageTextField.text as String!, "gender":self.genderTextField.text as String!, "foot":footTextField.text as String!, "additionalInformation":self.additionalInfoTextField.text as String! ,"jumpDistanceInCm":0 as Int!, "jumpDurationInMs":0 as Int!, "sensorData": sensorDataDictionaries]
        let json = JSON(jumpDictionary)
        let jsonString = json.description
        FileHandler.writeToFile("\(self.jumpNumber()).json", content: jsonString)
        
        setJumpNumber(jumpNumber()+1)
    }
    
    func resetData() {
        self.sensorDataArray = []
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

//TODO: Zum nächsten Textfeld gehen
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func didReceiveData(sensorData: SensorData) {
//        print("An richtiger Stelle: \(sensorData.sensor1Force)")
        sensor1Label.text = String(sensorData.sensor1Force)
        sensor2Label.text = String(sensorData.sensor2Force)
        sensor3Label.text = String(sensorData.sensor3Force)
        let alphaForSensor1Force = (CGFloat(sensorData.sensor1Force))/1000
        let alphaForSensor2Force = (CGFloat(sensorData.sensor2Force))/1000
        let alphaForSensor3Force = (CGFloat(sensorData.sensor3Force))/1000
        sensor1ForceView.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: alphaForSensor1Force)
        sensor2ForceView.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: alphaForSensor2Force)
        sensor3ForceView.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: alphaForSensor3Force)
        
        if isCollectingData {
            sensorDataArray.append(sensorData)
        }

    }


}

