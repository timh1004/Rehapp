//
//  SideHopsAlgorithmResultViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 24.09.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation
import UIKit

class SideHopsAlgorithmResultViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    var json: JSON!
    var sortedRecordArray: [Record]!
    var resultsArray = ""
    var jumpCountDifArray: [Int]! = []
    var relativePctErrArray: [Double]! = []
    var absolutePctErrArray: [Double]! = []
    
    var testResults: [[String:Double]]! = []
    
    let minThreshold = NSUserDefaults.standardUserDefaults().integerForKey("minThreshold")
    let maxThreshold = NSUserDefaults.standardUserDefaults().integerForKey("maxThreshold")
    let deviation = NSUserDefaults.standardUserDefaults().integerForKey("sideHopsDeviation")
    let interval = NSUserDefaults.standardUserDefaults().integerForKey("sideHopsInterval")
    
    override func viewDidLoad() {
        
        sortedRecordArray = getRecordArray()
        
        for var min = (minThreshold - deviation); min <= (minThreshold + deviation); min += interval {
            
            //            let max = maxThreshold
            for var max = (maxThreshold - deviation); max <= (maxThreshold + deviation); max += interval {
                
                resultsArray += "Min Threshold: \(min), Max Threshold: \(max)\n"
                
                for record in sortedRecordArray {
                    if record.isSideHops {
                        let calculatedJumpCount = SideHopsAlgorithm.calculateJumpCount(record, minThreshold: min, maxThreshold: max)
                        //                        print("jumpCount \(calculatedJumpCount)")
                        let videoJumpCount = record.jumpCount
                        
                        let jumpCountDif = abs(calculatedJumpCount - videoJumpCount)
                        //                        print("jumpCountDif: \(jumpCountDif)")
                        
                        let relativePctErr = ((Double(jumpCountDif)) / Double(videoJumpCount))
                        //                        print("relativePctErr: \(relativePctErr)")
                        let absolutePctErr = (abs(Double(jumpCountDif)) / Double(videoJumpCount))
                        //                        print("absolutePctErr: \(absolutePctErr)")
                        
                        resultsArray += ("ID: \(record.id), Calculated jumpCount: \(calculatedJumpCount), Video jumpCount: \(videoJumpCount), Diff: \(jumpCountDif), Percentage error \(absolutePctErr)\n")
                        
                        relativePctErrArray.append(relativePctErr)
                        absolutePctErrArray.append(absolutePctErr)
                        jumpCountDifArray.append(jumpCountDif)
                    }
                }
                
                let length = Double(relativePctErrArray.count)
                let jumpCountDifArraySum = jumpCountDifArray.reduce(0, combine: +)
                print("jumpCountDifArraySum: \(jumpCountDifArraySum)")
                let avgDif = Double(jumpCountDifArraySum) / Double(jumpCountDifArray.count)
                print("avgDif: \(avgDif)")
                let relativePctErrSum = relativePctErrArray.reduce(0, combine: +)
                print("relativePctErrSum: \(relativePctErrSum)")
                let avgOfRelativePctErrSum = relativePctErrSum / length
                print("avgOfRelativePctErrSum: \(avgOfRelativePctErrSum)")
                let bestAbsolutePctErr = absolutePctErrArray.minElement()!
                print("bestAbsolutePctErr: \(bestAbsolutePctErr)")
                let worstAbsolutePctErr = absolutePctErrArray.maxElement()!
                print("worstAbsolutePctErr: \(worstAbsolutePctErr)")
                let sumOfSquaredAvgDif = relativePctErrArray.map { pow($0 - avgOfRelativePctErrSum, 2.0)}.reduce(0, combine: {$0 + $1})
                let standardDeviation =  sqrt(sumOfSquaredAvgDif / length)
                
                resultsArray += ("Average Diff: \(avgDif), Best absolute percentage Error: \(bestAbsolutePctErr), Worst absolute percentage Error: \(worstAbsolutePctErr)\n")
                
                resultsArray += ("Average of relative percentage error: \(avgOfRelativePctErrSum)\nStandard deviaten: \(standardDeviation)\n\n")
                
                testResults.append(["minThreshold":Double(min), "maxThreshold":Double(max), "avgDif":avgDif, "bestAbsolutePctErr":bestAbsolutePctErr, "worstAbsolutePctErr":worstAbsolutePctErr, "avgOfRelativePctErrSum":avgOfRelativePctErrSum, "standardDeviation":standardDeviation])
            
                
                jumpCountDifArray = []
                relativePctErrArray = []
                absolutePctErrArray = []
                
                
            }
        }
        
        testResults.sortInPlace(testResultSort)
        
        var sortedTestResults = ""
        for dict in testResults {
            let minThreshold = dict["minThreshold"]!
            let maxThreshold = dict["maxThreshold"]!
            let bestAbsolutePctErr = dict["bestAbsolutePctErr"]!
            let worstAbsolutePctErr = dict["worstAbsolutePctErr"]!
            let standardDeviation = dict["standardDeviation"]!
            
            sortedTestResults += "Min Threshold: \(minThreshold), Max Threshold: \(maxThreshold), Best Percentage Error = \(bestAbsolutePctErr), Worst Percentage Error: \(worstAbsolutePctErr), Standard Deviation: \(standardDeviation)\n"
        }
        
        sortedTestResults += resultsArray
        
        textView.text = sortedTestResults
        
        
    }
    
    func getRecordArray() -> [Record] {
        
        
        var recordArray: [Record] = []
        let filteredArray = FileHandler.listFilesAtDocumentDirectory().filter{$0.hasSuffix(".json")}
        for item in filteredArray {
            if let dataFromString = FileHandler.readFromFile(item).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                json = JSON(data: dataFromString)
                let dictionary = json.dictionaryObject
                let record = Record(fromDictionary: dictionary!)
                recordArray.append(record)
            }
        }
        
        
        let sortedArray = recordArray.sort(){$0 < $1}
        print("sorted Record Array")
        return sortedArray
        
    }
    
    func testResultSort(r1:[String:Double], r2:[String:Double]) -> Bool {
        return (r1["standardDeviation"] < r2["standardDeviation"])
        
    }
    
}

