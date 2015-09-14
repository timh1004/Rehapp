//
//  Record.swift
//  Rehapp
//
//  Created by Tim Haug on 08.09.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation

class Record: Equatable, Hashable, Comparable, CustomStringConvertible {
    let id: Int
    let gender: Bool
    let foot: Bool
    let additionalInformation: String
    let age: Int
    let jumpDurationInMs: Int
    let isSideHops: Bool
    let jumpCount: Int
    let sensorData: [SensorData]
    let jumpDistanceInCm: Int
    let heightInCm: Int
    let name: String
    let weightInKg: Int
    
    var description: String {
        return "id: \(id), isSideHops: \(isSideHops) name: \(name), age: \(age), gender: \(gender), foot: \(foot), weight: \(weightInKg), height: \(heightInCm), jumpDistance: \(jumpDistanceInCm), jumpDuration: \(jumpDurationInMs))"
    }
    
    init(id: Int, gender: Bool, foot: Bool, additionalInformation: String, let age: Int, jumpDurationInMs: Int, isSideHops: Bool, jumpCount: Int, sensorData: [SensorData], jumpDistanceInCm: Int, heightInCm: Int, name: String, weightInKg: Int) {
        
        self.id = id
        self.gender = gender
        self.foot = foot
        self.additionalInformation = additionalInformation
        self.age = age
        self.jumpDurationInMs = jumpDurationInMs
        self.isSideHops = isSideHops
        self.jumpCount = jumpCount
        self.sensorData = sensorData
        self.jumpDistanceInCm = jumpDistanceInCm
        self.heightInCm = heightInCm
        self.name = name
        self.weightInKg = weightInKg
    }
    
    var hashValue: Int {
        return self.id
    }
    
    //MARK: JSON method
    init(fromDictionary: Dictionary<String, AnyObject>) {
        self.id = fromDictionary["id"] as! Int
        self.gender = fromDictionary["gender"] as! Bool
        self.foot = fromDictionary["foot"] as! Bool
        self.additionalInformation = fromDictionary["additionalInformation"] as? String ?? ""
        self.age = Int(fromDictionary["age"] as? String ?? "0") ?? 0
        self.jumpDurationInMs = fromDictionary["jumpDurationInMs"] as? Int ?? 0
        self.isSideHops = fromDictionary["isSideHops"] as! Bool
        self.jumpCount = fromDictionary["jumpCount"] as? Int ?? 0
        self.sensorData = (fromDictionary["sensorData"] as! Array).map{dict in SensorData(fromDictionary: dict)}
        self.jumpDistanceInCm = fromDictionary["jumpDistanceInCm"] as? Int ?? 0
        self.heightInCm = Int(fromDictionary["heightInCm"] as? String ?? "0") ?? 0
        self.name = fromDictionary["name"] as? String ?? ""
        self.weightInKg = Int(fromDictionary["weightInKg"] as? String ?? "0") ?? 0
        
        print("Height From Dictionary")
        print(fromDictionary["heightInCm"] as? String)
        
    }
}

func < (lhs: Record, rhs: Record) -> Bool {
    return lhs.id < rhs.id
}


func ==(lhs: Record, rhs: Record) -> Bool {
    return lhs.id == rhs.id
}

