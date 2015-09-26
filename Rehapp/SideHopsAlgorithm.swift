//
//  SideHopAlgorithm.swift
//  Rehapp
//
//  Created by Tim Haug on 23.09.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation

class SideHopsAlgorithm {
    
    class func calculateJumpCount(record: Record, minThreshold: Int, maxThreshold: Int) -> Int {
        
        let sensorDataArray = record.sensorData
//        let minThreshold = 250
//        let maxThreshold = 600
        
        var endOfJump = 0
        var jumpCount = 0
        
        if !record.isSideHops {
            return 0
        } else {
            
            if record.foot {
                
                for (index, sensorData) in sensorDataArray[endOfJump..<sensorDataArray.count].enumerate() {
                    
                    if (sensorData.sensor1Force <= minThreshold && sensorData.sensor3Force <= minThreshold && index >= endOfJump) {
                        
                        for (index2, sensorData2) in sensorDataArray[index..<sensorDataArray.count].enumerate() {
                            
                            if (sensorData2.sensor1Force >= maxThreshold && sensorData2.sensor3Force >= maxThreshold) {
                                
                                endOfJump = index + index2
                                print("jump detected \(endOfJump)")
                                ++jumpCount
                                break
                            }
                        }
                    }
                }
            } else {
                
                for (index, sensorData) in sensorDataArray[endOfJump..<sensorDataArray.count].enumerate() {
                    
                    if (sensorData.sensor1Force <= minThreshold && sensorData.sensor3Force <= minThreshold && index >= endOfJump) {
                        
                        for (index2, sensorData2) in sensorDataArray[index..<sensorDataArray.count].enumerate() {
                            
                            if (sensorData2.sensor1Force >= maxThreshold && sensorData2.sensor3Force >= maxThreshold) {
                                
                                endOfJump = index + index2
                                print("jump detected \(endOfJump)")
                                ++jumpCount
                                break
                            }
                        }
                    }
                }
            }
            
        }
        
        return jumpCount
        
    }
    
    class func calculateJumpCountTimes(record: Record, minThreshold: Int, maxThreshold: Int) -> [Int] {
        
        let sensorDataArray = record.sensorData
        //        let minThreshold = 250
        //        let maxThreshold = 600
        
        var endOfJump = 0
        var jumpCount = 0
        
        var jumpTimes: [Int] = []
        
        if !record.isSideHops {
            return [0]
        } else {
            
            if record.foot {
                
                for (index, sensorData) in sensorDataArray[endOfJump..<sensorDataArray.count].enumerate() {
                    
                    if (sensorData.sensor1Force <= minThreshold && sensorData.sensor3Force <= minThreshold && index >= endOfJump) {
                        
                        jumpTimes.append(sensorData.sensorTimeStampInMilliseconds)
                        
                        for (index2, sensorData2) in sensorDataArray[index..<sensorDataArray.count].enumerate() {
                            
                            if (sensorData2.sensor1Force >= maxThreshold && sensorData2.sensor3Force >= maxThreshold) {
                                
                                jumpTimes.append(sensorData2.sensorTimeStampInMilliseconds)
                                endOfJump = index + index2
                                print("jump detected \(endOfJump)")
                                ++jumpCount
                                break
                            }
                        }
                    }
                }
            } else {
                
                for (index, sensorData) in sensorDataArray[endOfJump..<sensorDataArray.count].enumerate() {
                    
                    if (sensorData.sensor1Force <= minThreshold && sensorData.sensor3Force <= minThreshold && index >= endOfJump) {
                        
                        jumpTimes.append(sensorData.sensorTimeStampInMilliseconds)
                        
                        for (index2, sensorData2) in sensorDataArray[index..<sensorDataArray.count].enumerate() {
                            
                            if (sensorData2.sensor1Force >= maxThreshold && sensorData2.sensor3Force >= maxThreshold) {
                                
                                jumpTimes.append(sensorData2.sensorTimeStampInMilliseconds)
                                endOfJump = index + index2
                                print("jump detected \(endOfJump)")
                                ++jumpCount
                                break
                            }
                        }
                    }
                }
            }
            
        }
        
        return jumpTimes
        
    }
}
