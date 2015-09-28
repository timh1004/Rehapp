//
//  RecordingDetailViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 14.07.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation
import UIKit

class RecordingDetailViewController: UIViewController, ChartDelegate {
    
    @IBOutlet weak var chart: Chart!
    
    @IBOutlet weak var sensor1Label: UILabel!
    @IBOutlet weak var sensor2Label: UILabel!
    @IBOutlet weak var sensor3Label: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet var timeIntervalLabel: UILabel!
    
    @IBAction func barButtonItemClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("showInformationSegue", sender: self)
    }
    
    var json: JSON!
    var record: Record!
    
    var fileName: String!
    var sensorDataArray = [SensorData]()
    
    var sideHopsJumpTimes: [Int] = []
    var index = 0
    
    var oneLegHopStartTime = 0
    var oneLegHopEndTime = 0
    
    var isLeftFoot = Bool()
    
    var sensor1Array = [Float]()
    var sensor2Array = [Float]()
    var sensor3Array = [Float]()
    var jumpArray = [Float]()
    var creationDateArray = [String]()
    
    var startInterval: NSTimeInterval!
    
    var sensor1Series: ChartSeries?
    var sensor2Series: ChartSeries?
    var sensor3Series: ChartSeries?
    var jumpSeries: ChartSeries?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To disable the swipe to go back gesture
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        
        chart.delegate = self
        
        chart.minY = 0
        chart.maxY = 1023
        chart.labelColor = UIColor.clearColor()
        chart.gridColor = UIColor.clearColor()
        chart.bottomInset = 10
        chart.topInset = 0
        chart.lineWidth = 1
        
        sensor1Label.textColor = ChartColors.greenColor()
        sensor2Label.textColor = ChartColors.blueColor()
        sensor3Label.textColor = ChartColors.redColor()
        
        self.title = "\(record.id).json"
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(image: UIImage(named: "info-icon"), style: .Plain, target: self, action: "barButtonItemClicked:"), animated: true)
        
        if let dataFromString = FileHandler.readFromFile(fileName).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            json = JSON(data: dataFromString)
        }
        
        if record.isSideHops {
            
            let minThreshold = NSUserDefaults.standardUserDefaults().integerForKey("minThreshold")
            let maxThreshold = NSUserDefaults.standardUserDefaults().integerForKey("maxThreshold")
            print("Min: \(minThreshold), Max: \(maxThreshold)")
            
            sideHopsJumpTimes = SideHopsAlgorithm.calculateJumpCountTimes(record, minThreshold: minThreshold, maxThreshold: maxThreshold)
            
            print("\(SideHopsAlgorithm.calculateJumpCountTimes(record, minThreshold: minThreshold, maxThreshold: maxThreshold))")
        } else {
            
            let startThreshold = NSUserDefaults.standardUserDefaults().integerForKey("startThreshold")
            let endThreshold = NSUserDefaults.standardUserDefaults().integerForKey("maxThreshold")
            let dict = (OneLegHopAlgorithm.calculateResultDict(record, startThreshold: startThreshold, endThreshold: endThreshold))
            oneLegHopStartTime = dict["jumpStartTime"]!
            oneLegHopEndTime = dict["jumpEndTime"]!
        }
        
        isLeftFoot = record.foot//json["foot"].boolValue
//        print("isLeftFoot \(isLeftFoot)")
        
//        let sensorDataArray: [SensorData]!
        sensorDataArray = record.sensorData
        //let recordArray = record.sensorData {//json["sensorData"].array {
        
        let firstEntry = sensorDataArray[0]
        startInterval = Double(firstEntry.sensorTimeStampInMilliseconds)//(firstEntry["sensorTimeStamp"].double!)
        print("start Interval: \(startInterval)")
        
        for sensorData in sensorDataArray {
            
            sensor1Array.append(Float(sensorData.sensor1Force))
            sensor2Array.append(Float(sensorData.sensor2Force))
            sensor3Array.append(Float(sensorData.sensor3Force))
            
            
            if record.isSideHops {
                
                if sensorData.sensorTimeStampInMilliseconds < sideHopsJumpTimes[index] {
                    jumpArray.append(Float(0))
                } else if sensorData.sensorTimeStampInMilliseconds >= sideHopsJumpTimes[index] && sensorData.sensorTimeStampInMilliseconds <= sideHopsJumpTimes[index+1] {
                    jumpArray.append(Float(1024))
                } else if index <= (sideHopsJumpTimes.count - 3){
                    jumpArray.append(Float(1024))
                    index += 2
                } else {
                    jumpArray.append(Float(0))
                }
            
                
            } else {
                if sensorData.sensorTimeStampInMilliseconds < oneLegHopStartTime || sensorData.sensorTimeStampInMilliseconds > oneLegHopEndTime {
                    jumpArray.append(Float(0))
                } else {
                    jumpArray.append(Float(1024))
                }
            }
            
            
        }
        
        sensor1Series = ChartSeries(sensor1Array)
        sensor2Series = ChartSeries(sensor2Array)
        sensor3Series = ChartSeries(sensor3Array)
        jumpSeries = ChartSeries(jumpArray)
        
        sensor1Series!.color = ChartColors.greenColor()
        sensor2Series!.color = ChartColors.blueColor()
        sensor3Series!.color = ChartColors.redColor()
        jumpSeries?.color = ChartColors.darkRedColor()
        jumpSeries?.area = true
        jumpSeries?.line = false
        
        var series = [ChartSeries]()
        if isLeftFoot {
            series = [sensor1Series!, sensor3Series!, jumpSeries!]
        } else {
            series = [sensor1Series!, sensor2Series!, jumpSeries!]
        }
        
        chart.addSeries(series)
        
    }

    func didTouchChart(chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
//        print("touch")
        for (_, dataIndex) in indexes.enumerate() {
            if let _ = chart.valueForSeries(0, atIndex: dataIndex) {
//                print("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
                
                let sensorData: SensorData = sensorDataArray[dataIndex!]
                sensor1Label.text = String(sensorData.sensor1Force)
                sensor2Label.text = String(sensorData.sensor2Force)
                sensor3Label.text = String(sensorData.sensor3Force)
                
                print("Sensor TimeStamp: \(sensorData.sensorTimeStampInMilliseconds)")
                //dd.MM.yy, hh:mm:ss:SSS
                
                let dateFormater = NSDateFormatter()
                dateFormater.dateFormat = "dd.MM.yy, HH:mm:ss.SSS"
                let intervalFormater = NSDateFormatter()
                intervalFormater.dateFormat = "mm:ss.SSS"
                
                creationDateLabel.text = dateFormater.stringFromDate(sensorData.creationDate)
                timeIntervalLabel.text = "\(sensorData.sensorTimeStampInMilliseconds - Int(startInterval)) ms"
//                    intervalFormater.stringFromDate(NSDate(timeIntervalSince1970: startInterval + (Double(sensorData.sensorTimeStampInMilliseconds)/1000)))
//                timeIntervalLabel.text = intervalFormater.stringFromDate(NSDate(timeIntervalSince1970: (sensorData.creationDate.timeIntervalSince1970 - startInterval))) // String(sensorData.creationDate.timeIntervalSince1970 - startInterval)
                
                
            }
        }
    }
    
    func didFinishTouchingChart(chart: Chart) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(sensorDataArray.count)
        return sensorDataArray.count
        //recordArray!.count
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        // Redraw chart on rotation
        chart.setNeedsDisplay()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showInformationSegue" {
            let destination = segue.destinationViewController as! RecordInfoViewController
            destination.record = record
        }

    }
    
    
}
