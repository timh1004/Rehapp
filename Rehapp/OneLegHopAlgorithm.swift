//
//  Algorithm.swift
//  Rehapp
//
//  Created by Tim Haug on 21.09.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation

class OneLegHopAlgorithm {

    class func calculateResult(record: Record) -> Int {
        let sensorDataArray = record.sensorData
        var jumpDuration: Int = 0
        var jumpStartTime: Int = 0
        var jumpEndTime: Int = 0
        var numberOfStartTimeLoopIterations = 0
        var numberOfEndTimeLoopIterations = 0
        let startThreshold = 200
        let endThreshold = 240
        
        if record.isSideHops {
            return 0
        } else {
            if record.foot {
                for sensorData in sensorDataArray {
                    if (sensorData.sensor1Force <= startThreshold && sensorData.sensor3Force <= startThreshold) {
                        jumpStartTime = sensorData.sensorTimeStampInMilliseconds
//                        print("jumpStartTime: \(jumpStartTime)")
                        break
                    }
                    numberOfStartTimeLoopIterations++
                }
//                print("Start Time Loop Iterations: \(numberOfStartTimeLoopIterations)")
                
                for sensorData in sensorDataArray {
                    if (sensorData.sensor3Force >= endThreshold && sensorData.sensorTimeStampInMilliseconds > jumpStartTime) {
                        jumpEndTime = sensorData.sensorTimeStampInMilliseconds
//                        print("jumpEndTime: \(jumpEndTime)")
                        break
                    }
                    numberOfEndTimeLoopIterations++
                    
                }
//                print("End Time Loop Iterations: \(numberOfEndTimeLoopIterations)")
            } else {
                //TODO: Hier mit index (enumerate)
                for sensorData in sensorDataArray {
                    if (sensorData.sensor1Force <= startThreshold && sensorData.sensor2Force <= startThreshold) {
                        jumpStartTime = sensorData.sensorTimeStampInMilliseconds
//                        print("jumpStartTime: \(jumpStartTime)")
                        break
                    }
                    numberOfStartTimeLoopIterations++
                }
//                print("Start Time Loop Iterations: \(numberOfStartTimeLoopIterations)")
                
                for sensorData in sensorDataArray {
                    if (sensorData.sensor2Force >= endThreshold && sensorData.sensorTimeStampInMilliseconds > jumpStartTime) {
                        jumpEndTime = sensorData.sensorTimeStampInMilliseconds
//                        print("jumpEndTime: \(jumpEndTime)")
                        break
                    }
                    numberOfEndTimeLoopIterations++
                    
                }
//                print("End Time Loop Iterations: \(numberOfEndTimeLoopIterations)")
            }
        }
        
        jumpDuration = jumpEndTime - jumpStartTime
        return jumpDuration
    }
    
    class func calculateResult(record: Record, startThreshold: Int, endThreshold: Int) -> Int {
        let sensorDataArray = record.sensorData
        var jumpDuration: Int = 0
        var jumpStartTime: Int = 0
        var jumpEndTime: Int = 0
        var numberOfStartTimeLoopIterations = 0
        var numberOfEndTimeLoopIterations = 0
        let startThreshold = startThreshold
        let endThreshold = endThreshold
        
        if record.isSideHops {
            return 0
        } else {
            if record.foot {
                for sensorData in sensorDataArray {
                    if (sensorData.sensor1Force <= startThreshold && sensorData.sensor3Force <= startThreshold) {
                        jumpStartTime = sensorData.sensorTimeStampInMilliseconds
                        //                        print("jumpStartTime: \(jumpStartTime)")
                        break
                    }
                    numberOfStartTimeLoopIterations++
                }
                //                print("Start Time Loop Iterations: \(numberOfStartTimeLoopIterations)")
                
                for sensorData in sensorDataArray {
                    if (sensorData.sensor3Force >= endThreshold && sensorData.sensorTimeStampInMilliseconds > jumpStartTime) {
                        jumpEndTime = sensorData.sensorTimeStampInMilliseconds
                        //                        print("jumpEndTime: \(jumpEndTime)")
                        break
                    }
                    numberOfEndTimeLoopIterations++
                    
                }
                //                print("End Time Loop Iterations: \(numberOfEndTimeLoopIterations)")
            } else {
                for sensorData in sensorDataArray {
                    if (sensorData.sensor1Force <= startThreshold && sensorData.sensor2Force <= startThreshold) {
                        jumpStartTime = sensorData.sensorTimeStampInMilliseconds
                        //                        print("jumpStartTime: \(jumpStartTime)")
                        break
                    }
                    numberOfStartTimeLoopIterations++
                }
                //                print("Start Time Loop Iterations: \(numberOfStartTimeLoopIterations)")
                
                for sensorData in sensorDataArray {
                    if (sensorData.sensor2Force >= endThreshold && sensorData.sensorTimeStampInMilliseconds > jumpStartTime) {
                        jumpEndTime = sensorData.sensorTimeStampInMilliseconds
                        //                        print("jumpEndTime: \(jumpEndTime)")
                        break
                    }
                    numberOfEndTimeLoopIterations++
                    
                }
                //                print("End Time Loop Iterations: \(numberOfEndTimeLoopIterations)")
            }
        }
        
        jumpDuration = jumpEndTime - jumpStartTime
        return jumpDuration
    }
    
    class func calculateResultDict(record: Record, startThreshold: Int, endThreshold: Int) -> [String:Int] {
        let sensorDataArray = record.sensorData
        var jumpDuration: Int = 0
        var jumpStartTime: Int = 0
        var jumpEndTime: Int = 0
        var numberOfStartTimeLoopIterations = 0
        var numberOfEndTimeLoopIterations = 0
        let startThreshold = startThreshold
        let endThreshold = endThreshold
        
        if record.isSideHops {
            return ["wrongAlgorithm":0]
        } else {
            print("running")
            if record.foot {
                for sensorData in sensorDataArray {
                    if (sensorData.sensor1Force <= startThreshold && sensorData.sensor3Force <= startThreshold) {
                        jumpStartTime = sensorData.sensorTimeStampInMilliseconds
                        //                        print("jumpStartTime: \(jumpStartTime)")
                        break
                    }
                    numberOfStartTimeLoopIterations++
                }
                //                print("Start Time Loop Iterations: \(numberOfStartTimeLoopIterations)")
                
                for sensorData in sensorDataArray {
                    if (sensorData.sensor3Force >= endThreshold && sensorData.sensorTimeStampInMilliseconds > jumpStartTime) {
                        jumpEndTime = sensorData.sensorTimeStampInMilliseconds
                        //                        print("jumpEndTime: \(jumpEndTime)")
                        break
                    }
                    numberOfEndTimeLoopIterations++
                    
                }
                //                print("End Time Loop Iterations: \(numberOfEndTimeLoopIterations)")
            } else {
                for sensorData in sensorDataArray {
                    if (sensorData.sensor1Force <= startThreshold && sensorData.sensor2Force <= startThreshold) {
                        jumpStartTime = sensorData.sensorTimeStampInMilliseconds
                        //                        print("jumpStartTime: \(jumpStartTime)")
                        break
                    }
                    numberOfStartTimeLoopIterations++
                }
                //                print("Start Time Loop Iterations: \(numberOfStartTimeLoopIterations)")
                
                for sensorData in sensorDataArray {
                    if (sensorData.sensor2Force >= endThreshold && sensorData.sensorTimeStampInMilliseconds > jumpStartTime) {
                        jumpEndTime = sensorData.sensorTimeStampInMilliseconds
                        //                        print("jumpEndTime: \(jumpEndTime)")
                        break
                    }
                    numberOfEndTimeLoopIterations++
                    
                }
                //                print("End Time Loop Iterations: \(numberOfEndTimeLoopIterations)")
            }
        }
        
        jumpDuration = jumpEndTime - jumpStartTime
        return ["jumpDuration":jumpDuration, "jumpStartTime":jumpStartTime, "jumpEndTime":jumpEndTime]
    }

    
}
