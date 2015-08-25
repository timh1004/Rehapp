//
//  RecordingDetailViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 14.07.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation
import UIKit

class RecordingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chart: Chart!
    
    @IBOutlet var tableView: UITableView!
    
//    var recordArray: [String]!
    var json: JSON!
    
    var fileName: String!
    var sensorDataArray = [SensorData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = fileName
        
        let series = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
        series.color = ChartColors.greenColor()
        chart.addSeries(series)
        
        
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
            }
            
        }
        
        
        
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
        
        cell.textLabel?.text = ("Force1: \(sensor1Force), Force2: \(sensor2Force), Force3: \(sensor3Force)")
        //recordArray[indexPath.row]
        cell.detailTextLabel?.text = creationDate
        
        return cell
        
    }
    
    
}
