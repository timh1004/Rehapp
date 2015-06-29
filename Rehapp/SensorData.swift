//
//  SensorData.swift
//  Rehapp
//
//  Created by Tim Haug on 29.06.15.
//  Copyright (c) 2015 Tim Haug. All rights reserved.
//


import Foundation

class SensorData {
    let creationDate: NSDate
    let sensor1Force: Int
    let sensor2Force: Int
    let sensor3Force: Int
    let sensorTimeStampInMilliseconds: Int
    
//    private class func sensorIsUpperSensor(sensorID: Int) -> Bool {
//        return sensorID == 1
//    }
    
    init(sensorTimeStamp: Int, sensor1Force: Int, sensor2Force: Int, sensor3Force: Int, creationDate: NSDate = NSDate()) {
        self.sensorTimeStampInMilliseconds = sensorTimeStamp
        self.creationDate = creationDate
        self.sensor1Force = sensor1Force
        self.sensor2Force = sensor2Force
        self.sensor3Force = sensor3Force
    }
    
    
//    //MARK: JSON Methods
    
//    func toDictionary() -> Dictionary<String, AnyObject> {
//        return ["sensorTimeStamp":self.sensorTimeStampInMilliseconds, "creationDate":creationDate.timeIntervalSince1970, "rawAccelerometer":self.rawAcceleration.toDictionary(), "linearAcceleration":self.linearAcceleration.toDictionary()]
//    }
//    
//    init(fromDictionary: Dictionary<String, AnyObject>) {
//        self.sensorTimeStampInMilliseconds = fromDictionary["sensorTimeStamp"] as! Int;
//        self.creationDate = NSDate(timeIntervalSince1970: fromDictionary["creationDate"] as! NSTimeInterval)
//        self.rawAcceleration = RawAcceleration(fromDictionary: fromDictionary["rawAccelerometer"] as! Dictionary<String, AnyObject>)
//        self.linearAcceleration = LinearAcceleration(fromDictionary: fromDictionary["linearAcceleration"] as! Dictionary<String, AnyObject>)
//    }
}
// TODO: Add Equitable Delegate
//func ==(lhs: SensorData, rhs: SensorData) -> Bool {
//    return lhs.sensorTimeStampInMilliseconds == rhs.sensorTimeStampInMilliseconds && lhs.rawAcceleration == rhs.rawAcceleration && lhs.linearAcceleration == rhs.linearAcceleration //&& lhs.creationDate.isEqualToDate(rhs.creationDate)
//    //TODO: compare CreationDate
//}
