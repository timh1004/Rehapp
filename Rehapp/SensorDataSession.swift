//
//  SensorDataSession.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

class SensorDataSession: SensorDataDelegate {
    var startDate: NSDate?
    var endDate: NSDate?
    
    let communicationManager = ArduinoCommunicationManager.sharedInstance
    var isCollectingData = false
    
    private var sensorData: [SensorData] = []
    
    init() {}
    
    func allSensorData() -> [SensorData] {
        return self.sensorData
    }
    
    func startStopMeasurement(onSuccess:()->()) {
        if (self.isCollectingData) {
            self.communicationManager.sensorDataDelegate = nil
            self.communicationManager.stopReceivingSensorData()
            self.isCollectingData = false
            self.endDate = NSDate()
            onSuccess()
        } else {
            self.waitForBluetoothToStart {
                self.communicationManager.sensorDataDelegate = self
                self.communicationManager.startReceivingSensorData()
                self.isCollectingData = true
                self.startDate = NSDate()
                onSuccess()
            }
        }
    }
    
    func waitForBluetoothToStart(after: ()->()) -> Void {
        if (communicationManager.isAbleToReceiveSensorData()) {
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
    
    func resetData() {
        self.sensorData = []
    }
    
//Mark: SensorDataDelegate
    func didReceiveData(sensorData: SensorData) {
        if (!self.isCollectingData) {
            return
        }
        self.sensorData.append(sensorData)
    }
}
