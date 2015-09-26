//
//  InterfaceController.swift
//  Rehapp WatchApp Extension
//
//  Created by Tim Haug on 14.09.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var startStopButton: WKInterfaceButton!
    
    @IBAction func startStopButtonTapped() {
        
        
        
        let applicationData = ["command":"startStop"]
        
        if let session = session where session.reachable {
            session.sendMessage(applicationData,
                replyHandler: { replyData in
                    switch replyData["status"] as! String {
                    case "started" :
                        print("started")
                        self.startStopButton.setTitle("Stop")
                        WKInterfaceDevice.currentDevice().playHaptic(.Start)
                    case "stopped" :
                        print("stopped")
                        self.startStopButton.setTitle("Start")
                        WKInterfaceDevice.currentDevice().playHaptic(.Stop)
                    case "notConnected" :
                        let cancel = WKAlertAction(title: "Cancel", style: WKAlertActionStyle.Cancel, handler: { () -> Void in
                            
                        })

                        
                        self.presentAlertControllerWithTitle("Alert", message: "Phone not connected to Smart-Bandage", preferredStyle: WKAlertControllerStyle.Alert, actions: [cancel])
                        WKInterfaceDevice.currentDevice().playHaptic(.Failure)
                    
                    default:
                        break
                    }
                    
                    // handle reply from iPhone app here
                    print(replyData)
                }, errorHandler: { error in
                    // catch any errors here
                    let cancel = WKAlertAction(title: "Cancel", style: WKAlertActionStyle.Cancel, handler: { () -> Void in
                        
                    })

                    self.presentAlertControllerWithTitle("Alert", message: "App not running on iPhone", preferredStyle: WKAlertControllerStyle.SideBySideButtonsAlert, actions: [cancel])
                    WKInterfaceDevice.currentDevice().playHaptic(.Failure)
                    print(error)
                    print("errorHandler erreicht")
            })
        } else {
            // when the iPhone is not connected via Bluetooth
            
            self.presentAlertControllerWithTitle("Alert", message: "Watch not connected to iPhone", preferredStyle: WKAlertControllerStyle.Alert, actions: [])
            WKInterfaceDevice.currentDevice().playHaptic(.Failure)
            print("Phone nicht verbunden")
        }
        
    }
    
    private let session : WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
