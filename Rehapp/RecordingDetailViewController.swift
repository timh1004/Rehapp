//
//  RecordingDetailViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 14.07.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation
import UIKit

class RecordingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChartDelegate {
    
    @IBOutlet weak var chart: Chart!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var sensor1Label: UILabel!
    @IBOutlet weak var sensor2Label: UILabel!
    @IBOutlet weak var sensor3Label: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet var timeIntervalLabel: UILabel!
//    var recordArray: [String]!
    var json: JSON!
    
    var fileName: String!
    var sensorDataArray = [SensorData]()
    
    var isLeftFoot = Bool()
    
    var sensor1Array = [Float]()
    var sensor2Array = [Float]()
    var sensor3Array = [Float]()
    var creationDateArray = [String]()
    
    var startInterval: NSTimeInterval!
    
    var sensor1Series: ChartSeries?
    var sensor2Series: ChartSeries?
    var sensor3Series: ChartSeries?
    
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
        
        self.title = fileName
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "barButtonItemClicked:"), animated: true)
        
        if let dataFromString = FileHandler.readFromFile(fileName).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            json = JSON(data: dataFromString)
        }
        
        
        print(json["id"].stringValue)
        
        isLeftFoot = json["foot"].boolValue
//        print("isLeftFoot \(isLeftFoot)")
        
        if let recordArray = json["sensorData"].array {
            
            let firstEntry = recordArray[0]
            startInterval = (firstEntry["sensorTimeStamp"].double!)
            print("start Interval: \(startInterval)")
            
            for sensorDataDict in recordArray {
                
//                var creationDate: NSDate? = sensorDataDict["creationDate"].NSd
//                let sensorTimeStamp: Int? = sensorDataDict["sensorTimeStamp"].int
                let sensor1Force: Int? = sensorDataDict["sensor1Force"].int
                let sensor2Force: Int? = sensorDataDict["sensor2Force"].int
                let sensor3Force: Int? = sensorDataDict["sensor3Force"].int
                let sensorTimeStamp: Int? = sensorDataDict["sensorTimeStamp"].int
                let creationDate: NSDate? = NSDate(timeIntervalSince1970: NSTimeInterval(sensorDataDict["creationDate"].double!))
                
                let sensorData = SensorData(sensor1Force: sensor1Force!, sensor2Force: sensor2Force!, sensor3Force: sensor3Force!, creationDate: creationDate!, sensorTimeStamp: sensorTimeStamp!)
                sensorDataArray.append(sensorData)
                sensor1Array.append(Float(sensor1Force!))
                sensor2Array.append(Float(sensor2Force!))
                sensor3Array.append(Float(sensor3Force!))
                
                
            }
            
            sensor1Series = ChartSeries(sensor1Array)
            sensor2Series = ChartSeries(sensor2Array)
            sensor3Series = ChartSeries(sensor3Array)
            sensor1Series!.color = ChartColors.greenColor()
            sensor2Series!.color = ChartColors.blueColor()
            sensor3Series!.color = ChartColors.redColor()
            var series = [ChartSeries]()
            if isLeftFoot {
                series = [sensor1Series!, sensor3Series!]
            } else {
                series = [sensor1Series!, sensor2Series!]
            }
            
            chart.addSeries(series)
            
        }
        
        
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
                dateFormater.dateFormat = "dd.MM.yy, hh:mm:ss,SSS"
                let intervalFormater = NSDateFormatter()
                intervalFormater.dateFormat = "mm:ss,SSS"
                
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let sensorData: SensorData = sensorDataArray[indexPath.row]
//        let sensorStampInMilliseconds = String(sensorData.sensorTimeStampInMilliseconds)
        let sensor1Force = String(sensorData.sensor1Force)
        let sensor2Force = String(sensorData.sensor2Force)
        let sensor3Force = String(sensorData.sensor3Force)
        let creationDate = String(sensorData.creationDate)
        
//        let sensor1ForceAttributedString = NSMutableAttributedString(string: sensor1Force)
        
        let string = "Sensor1: \(sensor1Force), Sensor2: \(sensor2Force), Sensor3: \(sensor3Force)"
        let attributedString = NSMutableAttributedString(string: string as String)
//        var range = (string as NSString).rangeOfString("\(departure.destination)")
        
        let sensor1Attributes = [NSForegroundColorAttributeName: ChartColors.greenColor()]
        let sensor2Attributes = [NSForegroundColorAttributeName: ChartColors.blueColor()]
        let sensor3Attributes = [NSForegroundColorAttributeName: ChartColors.redColor()]
        
        attributedString.addAttributes(sensor1Attributes, range: (string as NSString).rangeOfString("\(sensor1Force)"))
        attributedString.addAttributes(sensor2Attributes, range: (string as NSString).rangeOfString("\(sensor2Force)"))
        attributedString.addAttributes(sensor3Attributes, range: (string as NSString).rangeOfString("\(sensor3Force)"))
        
        cell.textLabel?.attributedText = attributedString
//        cell.textLabel?.text = ("Force1: \(sensor1Force), Force2: \(sensor2Force), Force3: \(sensor3Force)")
        //recordArray[indexPath.row]
        cell.detailTextLabel?.text = creationDate
        
        return cell
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        // Redraw chart on rotation
        chart.setNeedsDisplay()
        
    }
    
    
}
