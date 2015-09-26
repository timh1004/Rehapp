//
//  JumpRecordViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 29.06.15.
//  Copyright (c) 2015 Tim Haug. All rights reserved.
//

import UIKit
import QuartzCore
import WatchConnectivity

class JumpRecordViewController: UIViewController, UITextFieldDelegate, SensorDataDelegate {
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    var startDate: NSDate?
    var endDate: NSDate?
    
    var isCollectingData = false
    var communicationManager = ArduinoCommunicationManager.sharedInstance
    
    private var sensorDataArray: [SensorData] = []
    
//    var sensorDataSession = SensorDataSession()

    @IBOutlet var exerciseSegmentedControl: UISegmentedControl!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var footSegmentedControl: UISegmentedControl!
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
    
    let nextField = [1:2, 2:3, 3:4, 4:5]
    var jumpDistanceInCm = 0
    var jumpCount = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureWCSession()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configureWCSession()
    }
    
    private func configureWCSession() {
        session?.delegate = self;
        session?.activateSession()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sensor1ForceView.layer.cornerRadius = 25
        sensor2ForceView.layer.cornerRadius = 25
        sensor3ForceView.layer.cornerRadius = 25
        sensor1ForceView.layer.masksToBounds = true
        sensor2ForceView.layer.masksToBounds = true
        sensor3ForceView.layer.masksToBounds = true
        
        startStopRecordingButton.enabled = false
        
        self.waitForBluetoothToStart { () -> () in
            self.communicationManager.startReceivingSensorData()
            self.communicationManager.sensorDataDelegate = self
        }
        
        for i in 1...5 {
            if let textField = self.view.viewWithTag(i) as? UITextField {
                textField.delegate = self
            }
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
            startStopRecordingButton.enabled = true
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


    @IBAction func startStopButtonPressed(sender: UIButton) {
//        let title:String = self.isCollectingData ? "Start Recording" : "Stop Recording"
//        sender.setTitle(title, forState: .Normal)
        self.startStopRecording()
    }
    
    func startStopRecording() {
        if (self.isCollectingData) {
            
            startStopRecordingButton.setTitle("Start Recording", forState: .Normal)
            //            self.communicationManager.sensorDataDelegate = nil
            //            self.communicationManager.stopReceivingSensorData()
            self.isCollectingData = false
            self.endDate = NSDate()
            
            //display distance alert view only when One-Leg Hop is selected
            if exerciseSegmentedControl.selectedSegmentIndex == 0 {
                self.jumpCount = 0
                self.displayDistanceAlertView()
            } else {
                self.jumpDistanceInCm = 0
                self.displayCountAlertView()
            }
            
            //            onSuccess()
        } else {
            startStopRecordingButton.setTitle("Stop Recording", forState: .Normal)
            
            //                self.communicationManager.sensorDataDelegate = self
            //                self.communicationManager.startReceivingSensorData()
            self.isCollectingData = true
            self.startDate = NSDate()
            resetData()
            //                onSuccess()
            
        }
    }
    
    func displayDistanceAlertView() {
        let alertController = UIAlertController(title: "Distance", message: "Please enter the jumped distance", preferredStyle: UIAlertControllerStyle.Alert)
        
        let enterDistanceAction = UIAlertAction(title: "Done", style: .Default) { (_) in
            let distanceTextField = alertController.textFields![0] as UITextField
            self.jumpDistanceInCm = Int(distanceTextField.text!)!
            self.measurementDidFinish()
        }
        enterDistanceAction.enabled = false
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Distance in cm"
            textField.keyboardType = UIKeyboardType.NumberPad
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                enterDistanceAction.enabled = textField.text != ""
            }
        }
        
        alertController.addAction(enterDistanceAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displayCountAlertView() {
        let alertController = UIAlertController(title: "Count", message: "Please enter the number of jumps", preferredStyle: UIAlertControllerStyle.Alert)
        
        let enterCountAction = UIAlertAction(title: "Done", style: .Default) { (_) in
            let countTextField = alertController.textFields![0] as UITextField
            self.jumpCount = Int(countTextField.text!)!
            self.measurementDidFinish()
        }
        enterCountAction.enabled = false
        
        //        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Count"
            textField.keyboardType = UIKeyboardType.NumberPad
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                enterCountAction.enabled = textField.text != ""
            }
        }
        
        alertController.addAction(enterCountAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func measurementDidFinish() {
//        let sensorData = sensorDataSession.allSensorData()
        let sensorDataDictionaries = sensorDataArray.map({sensorData in sensorData.toDictionary()})
        let jumpDictionary = ["id":jumpNumber(), "isSideHops":self.exerciseSegmentedControl.selectedSegmentIndex as Int!, "name":self.nameTextField.text as String!, "weightInKg":self.weightTextField.text as String!, "heightInCm":self.heightTextField.text as String!, "age":self.ageTextField.text as String!, "gender":self.genderSegmentedControl.selectedSegmentIndex as Int!, "foot":footSegmentedControl.selectedSegmentIndex as Int!, "additionalInformation":self.additionalInfoTextField.text as String! ,"jumpDistanceInCm":jumpDistanceInCm as Int!, "jumpDurationInMs":0 as Int!, "jumpCount":jumpCount as Int!, "sensorData": sensorDataDictionaries]
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Consult our dictionary to find the next field
        if let nextTag = nextField[textField.tag] {
            if let nextResponder = textField.superview?.viewWithTag(nextTag) {
                // Have the next field become the first responder
                nextResponder.becomeFirstResponder()
            }
        }
        // Return false here to avoid Next/Return key doing anything
        return false
    }
    
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

// MARK: WCSessionDelegate
extension JumpRecordViewController: WCSessionDelegate {
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        var replyValues = Dictionary<String, AnyObject>()
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue()) {
            
            switch message["command"] as! String {
            case "startStop" :
                if self.startStopRecordingButton.enabled {
                    
                    self.startStopRecording()
                    if self.isCollectingData {
                        replyValues["status"] = "started"
                    } else {
                        replyValues["status"] = "stopped"
                    }
                } else {
                   replyValues["status"] = "notConnected"
                }
            default:
                break
            }
            replyHandler(replyValues)
        }
    }
}

