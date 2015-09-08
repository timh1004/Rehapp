//
//  ArduinoCommunicationManager.swift
//  Rehapp
//
//  Created by Tim Haug on 29.06.15.
//  Copyright (c) 2015 Tim Haug. All rights reserved.
//

import Foundation

private let _SharedInstance = ArduinoCommunicationManager()

class ArduinoCommunicationManager: NSObject, BLEDiscoveryDelegate, BLEServiceDelegate, BLEServiceDataDelegate {
    

    let numberOfRequiredSensors: Int = 1
    var shouldAutomaticallyReconnect = false
    
    class var sharedInstance: ArduinoCommunicationManager {
        return _SharedInstance
    }

    var sensorDataDelegate: SensorDataDelegate? = nil
    
    override init() {
        super.init()
        let sharedInstance = BLEDiscovery.sharedInstance()
        sharedInstance.discoveryDelegate = self
        sharedInstance.peripheralDelegate = self
        
        sharedInstance.startScanningForSupportedUUIDs()
    }

    func isAbleToReceiveSensorData() -> Bool {
        let foundPeripherals = BLEDiscovery.sharedInstance().foundPeripherals.count
        NSLog("Found %d Peripherals", foundPeripherals)
        return foundPeripherals == numberOfRequiredSensors
    }
    
    func connectToPeripherals() {
        let sharedInstance = BLEDiscovery.sharedInstance()
        for object in sharedInstance.foundPeripherals {
            if let peripheral = object as? CBPeripheral {
                sharedInstance.connectPeripheral(peripheral)
            }
        }
    }
    
    func disconnectFromPeripherals() {
        NSLog("Disconnect from Peripherals ...")
        BLEDiscovery.sharedInstance().disconnectConnectedPeripherals()
    }
    
    func startReceivingSensorData() {
        self.shouldAutomaticallyReconnect = true
        
        self.connectToPeripherals()
    }
    
    func stopReceivingSensorData() {
        self.shouldAutomaticallyReconnect = false
        
        self.disconnectFromPeripherals()
    }
    
    //Mark: BLEDiscovery
    
    func discoveryDidRefresh() {
        NSLog("Discovered did refresh")
        if (self.isAbleToReceiveSensorData()) {
            self.connectToPeripherals()
        }
    }
    
    func peripheralDiscovered(peripheral: CBPeripheral!) {
        NSLog("Discovered Peripherial: %@", peripheral)
        if (self.isAbleToReceiveSensorData()) {
            self.connectToPeripherals()
        }
    }
    
    func discoveryStatePoweredOff() {
        NSLog("Discovery State Powerered Off ...")
    }
    
    
    //MARK: BLEServiceProtocol
    
    func bleServiceDidConnect(service: BLEService!) {
        service.delegate = self
        service.dataDelegate = self
        
        NSLog("bleServiceDidConnect:%@", service);
    }
    
    func bleServiceDidDisconnect(service: BLEService!) {
        NSLog("bleServiceDidDisconnect:%@", service);
    }
    
    func bleServiceIsReady(service: BLEService!) {
        NSLog("bleServiceIsReady:%@", service);
    }
    
    func bleServiceDidReset() {
        NSLog("bleServiceDidReset");
    }
    
    func reportMessage(message: String!) {
        print("BLE Message: \(message)")
    }
    
    //MARK: BLEServiceData Delegate
    
    func didReceiveData(data: UnsafeMutablePointer<UInt8>, length: Int) {
//        print("Length :\(length)")
        
        
        if (length == 8) {
            
            for var i = 0; i < length; i+=8 {
                
//                print("Data0: \(data[0])")
//                print("Data1: \(data[1])")
//                print("Data2: \(data[2])")
//                print("Data3: \(data[3])")
//                print("Data4: \(data[4])")
//                print("Data5: \(data[5])")
                
                
                let sensor1Force = transformReceivedUIntsToInt([data[0], data[1]])
                let sensor2Force = transformReceivedUIntsToInt([data[2], data[3]])
                let sensor3Force = transformReceivedUIntsToInt([data[4], data[5]])
                
                let sensorTimestampInMilliseconds =  transformReceivedUIntsToInt([data[6], data[7]])
                
                
//                print(sensorTimestampInMilliseconds)
//                print(transformReceivedBytesIntoInt)
                
                
//                print("sensor1Force: \(sensor1Force)")
//                print("sensor2Force: \(sensor2Force)")
//                print("sensor3Force: \(sensor3Force)")
//                print("time: \(sensorTimestampInMilliseconds)")
                
                
                let sensorData = SensorData(sensor1Force: sensor1Force, sensor2Force: sensor2Force, sensor3Force: sensor3Force, sensorTimeStamp: sensorTimestampInMilliseconds)
                
                if let delegate = self.sensorDataDelegate {
                    delegate.didReceiveData(sensorData)
                }
            }
        }
    }
    
    
    func transformReceivedUIntsToInt(inputData: [UInt8]) -> Int {
        
        let data = NSData(bytes: inputData, length: inputData.count)
        
//        var u16 = UnsafePointer<UInt16>(data).memory
//        println("u16: \(u16)")
        var u16: UInt16 = 0
        data.getBytes(&u16)
        
        return Int(u16)
    }
    
    func transformReceivedBytesIntoInt(inputData: [UInt8]) -> Int {
        return transformReceivedUIntsToInt(inputData) - 32767
    }

}