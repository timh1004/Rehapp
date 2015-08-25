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
//    var recordArray: [String]!
    var json: JSON!
    
    var fileName: String!
    var sensorDataArray = [SensorData]()
    
    var sensor1Array = [Float]()
    var sensor2Array = [Float]()
    var sensor3Array = [Float]()
    
    var sensor1Series: ChartSeries?
    var sensor2Series: ChartSeries?
    var sensor3Series: ChartSeries?
    var creationDateSeries: ChartSeries?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.delegate = self
        
        chart.minY = 0
        chart.maxY = 1023
        chart.labelColor = UIColor.clearColor()
        chart.gridColor = UIColor.clearColor()
        chart.bottomInset = 0
        chart.topInset = 0
        chart.lineWidth = 1
        
        
        self.title = fileName
        
        if let dataFromString = FileHandler.readFromFile(fileName).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            json = JSON(data: dataFromString)
        }
        
        print(json["id"].stringValue)
//        print(json["sensorData"].array)
        
        if let recordArray = json["sensorData"].array {

            
            for sensorDataDict in recordArray {
//                var creationDate: NSDate? = sensorDataDict["creationDate"].NSd
//                let sensorTimeStamp: Int? = sensorDataDict["sensorTimeStamp"].int
                let sensor1Force: Int? = sensorDataDict["sensor1Force"].int
                let sensor2Force: Int? = sensorDataDict["sensor2Force"].int
                let sensor3Force: Int? = sensorDataDict["sensor3Force"].int
                let creationDate: NSDate? = NSDate(timeIntervalSince1970: NSTimeInterval(sensorDataDict["creationDate"].double!))
                
                print("Als Double: " + String((sensorDataDict["creationDate"].double!)))
                print("Als TimeInterval: " + String(NSTimeInterval(sensorDataDict["creationDate"].double!)))
                print("Als NSDate: " + String(NSDate(timeIntervalSince1970: NSTimeInterval(sensorDataDict["creationDate"].double!))))
                
                let sensorData = SensorData(sensor1Force: sensor1Force!, sensor2Force: sensor2Force!, sensor3Force: sensor3Force!, creationDate: creationDate!)
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
            let series = [sensor1Series!, sensor2Series!, sensor3Series!]
            chart.addSeries(series)
            
        }
        
        
        
    }
    
    func didTouchChart(chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
//        print("touch")
        for (seriesIndex, dataIndex) in indexes.enumerate() {
            if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                print("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
            }
        }
    }
    
    func didFinishTouchingChart(chart: Chart) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(sensorDataArray.count)
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
