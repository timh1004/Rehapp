//
//  SensorData.swift
//  Rehapp
//
//  Created by Tim Haug on 29.06.15.
//  Copyright (c) 2015 Tim Haug. All rights reserved.
//


import Foundation

class SensorData {
    let sensorTimeStampInMilliseconds: Int
    let creationDate: NSDate
    let sensor1Force: Int
    let sensor2Force: Int
    let sensor3Force: Int
    
//    private class func sensorIsUpperSensor(sensorID: Int) -> Bool {
//        return sensorID == 1
//    }

    init(sensor1Force: Int, sensor2Force: Int, sensor3Force: Int, creationDate: NSDate = NSDate(), sensorTimeStamp: Int) {
        self.sensorTimeStampInMilliseconds = sensorTimeStamp
        self.creationDate = creationDate
        self.sensor1Force = sensor1Force
        self.sensor2Force = sensor2Force
        self.sensor3Force = sensor3Force
    }
    
    
    //MARK: JSON Methods
    
    func toDictionary() -> Dictionary<String, AnyObject> {
        return ["sensorTimeStamp": self.sensorTimeStampInMilliseconds, "creationDate":creationDate.timeIntervalSince1970, "sensor1Force":self.sensor1Force, "sensor2Force":sensor2Force, "sensor3Force":sensor3Force]
    }
    
    init(fromDictionary: Dictionary<String, AnyObject>) {
        self.sensorTimeStampInMilliseconds = fromDictionary["sensorTimeStamp"] as! Int;
        self.creationDate = NSDate(timeIntervalSince1970: fromDictionary["creationDate"] as! NSTimeInterval)
        self.sensor1Force = fromDictionary["sensor1Force"] as! Int
        self.sensor2Force = fromDictionary["sensor2Force"] as! Int
        self.sensor3Force = fromDictionary["sensor3Force"] as! Int
    }
}
 //TODO: Add Equitable Delegate
func == (lhs: SensorData, rhs: SensorData) -> Bool {
    return (lhs.creationDate == rhs.creationDate && lhs.sensor1Force == rhs.sensor1Force && lhs.sensor2Force == rhs.sensor2Force && lhs.sensor3Force == rhs.sensor3Force)
}
