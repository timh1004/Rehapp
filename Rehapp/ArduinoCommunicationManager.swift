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
    S
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
        println("BLE Message: \(message)")
    }
    
    //MARK: BLEServiceData Delegate
    
    func didReceiveData(data: UnsafeMutablePointer<UInt8>, length: Int) {
        if (length == 14 && self.sensorDataDelegate != nil) {
            let sensorTimestampInMilliseconds =  transformReceivedUIntsToInt([data[12], data[13]])
            
            let linearAccelerationX = transformReceivedBytesIntoInt([data[0], data[1]])
            let linearAccelerationY = transformReceivedBytesIntoInt([data[2], data[3]])
            let linearAccelerationZ = transformReceivedBytesIntoInt([data[4], data[5]])
            let linearAcceleration = LinearAcceleration(x: linearAccelerationX, y: linearAccelerationY, z: linearAccelerationZ)
            
            let rawAccelerationX = transformReceivedBytesIntoInt([data[6], data[7]])
            let rawAccelerationY = transformReceivedBytesIntoInt([data[8], data[9]])
            let rawAccelerationZ = transformReceivedBytesIntoInt([data[10], data[11]])
            let rawAcceleration = RawAcceleration(x: rawAccelerationX, y: rawAccelerationY, z: rawAccelerationZ)
            
            let sensorData = SensorData(sensorTimeStamp: sensorTimestampInMilliseconds, rawAcceleration: rawAcceleration, linearAcceleration: linearAcceleration)
            
            if let delegate = self.sensorDataDelegate {
                delegate.didReceiveData(sensorData)
            }
        }
    }
    
    func transformReceivedUIntsToInt(inputData: [UInt8]) -> Int {
        let data = NSData(bytes: inputData, length: inputData.count)
        
        var u16 : UInt16 = 0 ;
        data.getBytes(&u16)
        
        return Int(u16)
    }
    
    func transformReceivedBytesIntoInt(inputData: [UInt8]) -> Int {
        return transformReceivedUIntsToInt(inputData) - 32767
    }

}

//#import "MainViewController.h"
//
//@implementation MainViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//    }
//    
//    - (void)viewDidLoad
//        {
//            [super viewDidLoad];
//            
//            // Do any additional setup after loading the view.
//            [BLEDiscovery sharedInstance].peripheralDelegate = self;
//            [BLEDiscovery sharedInstance].discoveryDelegate = self;
//            [[BLEDiscovery sharedInstance] startScanningForSupportedUUIDs];
//        }
//        
//        - (void)didReceiveMemoryWarning
//            {
//                [super didReceiveMemoryWarning];
//                // Dispose of any resources that can be recreated.
//            }
//            
//            - (IBAction) sendTapped:(id)sender {
//                uint8_t buf[16];
//                for (int i = 0; i < 15; i++) {
//                    buf[i] = (uint8_t)65+i;
//                    
//                }
//                buf[15] = '\n';
//                
//                BLEService * service = [BLEDiscovery sharedInstance].connectedService;
//                if(!service){
//                    NSLog(@"no service!");
//                }
//                [service writeToTx:[NSData dataWithBytes:buf length:1]];
//}

//-(void) updateConnectedLabel{
//    if([BLEDiscovery sharedInstance].connectedService){
//        self.connectedLabel.text = @"CONNECTED";
//    } else {
//        self.connectedLabel.text = @"NOT CONNECTED";
//    }
//}

//MARK: BleServiceDataDelegate

//-(void) didReceiveData:(uint8_t *)buffer lenght:(NSInteger)length{
//    
//    NSString * text = @"";
//    for (int i = 0 ; i < length; i++) {
//        int value = buffer[i];
//        text = [text stringByAppendingFormat:@"%d ",value];
//    }
//    
//    //NSLog(@"%@",text);
//    
//    self.receivedLabel.text = text;
//}

//MARK: BleDiscoveryDelegate

//- (void) discoveryDidRefresh {
//    }
//    
//    - (void) peripheralDiscovered:(CBPeripheral*) peripheral {
//        if([BLEDiscovery sharedInstance].connectedService == nil){
//            [[BLEDiscovery sharedInstance] connectPeripheral:peripheral];
//        }
//        }
//        
//        - (void) discoveryStatePoweredOff {
//}

// MARK: BleServiceProtocol

//-(void) bleServiceDidConnect:(BLEService *)service{
//    service.delegate = self;
//    service.dataDelegate = self;
//    [self updateConnectedLabel];
//}
//
//-(void) bleServiceDidDisconnect:(BLEService *)service{
//    [self updateConnectedLabel];
//}
//
//-(void) bleServiceIsReady:(BLEService *)service{
//    
//}
//
//-(void) bleServiceDidReset {
//}
//
//-(void) reportMessage:(NSString*) message{
//}