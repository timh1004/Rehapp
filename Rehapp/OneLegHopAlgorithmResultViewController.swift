//
//  AlgorithmResultViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 21.09.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation
import UIKit

class OneLegHopAlgorithmResultViewController: UIViewController {
    
    @IBOutlet var resultTextView: UITextView!
    
    var json: JSON!
    var sortedRecordArray: [Record]!
    var resultsArray = ""
    var calculatedDurationArray: [Int]!
    var videoDurationArray: [Int]!
    var durationDeltaArray: [Int]! = []
    var relativePercentageErrorArray: [Double]! = []
    var absolutePercentageErrorArray: [Double]! = []
    
    var testResults: [[String:Double]]! = []
    
    let startThreshold = NSUserDefaults.standardUserDefaults().integerForKey("startThreshold")

    let endThreshold = NSUserDefaults.standardUserDefaults().integerForKey("endThreshold")
    let addition = NSUserDefaults.standardUserDefaults().integerForKey("addition")
    let interval = NSUserDefaults.standardUserDefaults().integerForKey("interval")
    let deviation = NSUserDefaults.standardUserDefaults().integerForKey("deviation")
    
    override func viewDidLoad() {
        
        sortedRecordArray = getRecordArray()
        
        
        for var start = (startThreshold - deviation); start <= (startThreshold + deviation); start += interval {
            
            for var end = (endThreshold - deviation); end <= (endThreshold + deviation); end += interval {
                
                for var add = addition - deviation; add <= addition + deviation; add += interval {
                    
                    resultsArray += "Start Threshold: \(start), End Threshold: \(end), Addition: \(add)\n"
                    
                    
                    for record in sortedRecordArray {
                        if record.isSideHops == false {
                            let calculatedDuration = OneLegHopAlgorithm.calculateResult(record, startThreshold: start, endThreshold: end)
                            let videoDuration = record.jumpDurationInMs
                            //                            calculatedDurationArray.append(calculatedDuration)
                            //                            videoDurationArray.append(videoDuration)
                            let durationDelta = abs(videoDuration - calculatedDuration + add)
                            
                            let relativePercentageError = ((Double(durationDelta)) / Double(videoDuration))
                            print(relativePercentageError)
                            let absolutePercentageError = (abs(Double(durationDelta)) / Double(videoDuration))
                            
                            relativePercentageErrorArray.append(relativePercentageError)
                            absolutePercentageErrorArray.append(absolutePercentageError)
                            durationDeltaArray.append(durationDelta)
                                                resultsArray += ("ID: \(record.id), Calculated duration: \(calculatedDuration), Video Duration: \(videoDuration), Duration Delta: \(durationDelta), Percentage error \(absolutePercentageError)\n")
                        }
                    }
                    let length = Double(relativePercentageErrorArray.count)
                    let durationDeltaArraySum = durationDeltaArray.reduce(0, combine: +)
                    let avgDelta = durationDeltaArraySum / durationDeltaArray.count
                    let relativePercentageErrorSum = relativePercentageErrorArray.reduce(0, combine: +)
                    let avgOfRelativePercentageErrorSum = relativePercentageErrorSum / length
                    
                    let bestAbsolutePercentageError = absolutePercentageErrorArray.minElement()!
                    let worstAbsolutePercentageError = absolutePercentageErrorArray.maxElement()!
                    
                    
                    
                    let sumOfSquaredAvgDiff = relativePercentageErrorArray.map { pow($0 - avgOfRelativePercentageErrorSum, 2.0)}.reduce(0, combine: {$0 + $1})
                    let standardDeviation =  sqrt(sumOfSquaredAvgDiff / length)
                    
                    
                    resultsArray += ("Summe Deltas: \(durationDeltaArraySum), Average Delta: \(avgDelta), Best Absolute Percentage Error: \(bestAbsolutePercentageError), Worst Absolute Percentage Error: \(worstAbsolutePercentageError)\n")
                    resultsArray += ("Durchschnitt der relativen prozentualen Fehler: \(avgOfRelativePercentageErrorSum)\nStandard Deviation: \(standardDeviation)\n\n")
                    
                    testResults.append(["startThreshold":Double(start), "endThreshold":Double(end), "add":Double(add), "sumDeltas":Double(durationDeltaArraySum), "avgDelta":Double(avgDelta), "bestAbsolutePercentageError":bestAbsolutePercentageError, "worstAbsolutePercentageError":worstAbsolutePercentageError, "avgOfRelativePercentageErrorSum":avgOfRelativePercentageErrorSum, "standardDeviation":standardDeviation])
                    
                    durationDeltaArray = []
                    relativePercentageErrorArray = []
                    absolutePercentageErrorArray = []
                }
            }
        }
        
        testResults.sortInPlace(testResultSort)
        
        var sortedTestResults = ""
        for dict in testResults {
            let startThreshold = dict["startThreshold"]!
            let endThreshold = dict["endThreshold"]!
            let add = dict["add"]!
            let bestAbsolutePercentageError = dict["bestAbsolutePercentageError"]!
            let worstAbsolutePercentageError = dict["worstAbsolutePercentageError"]!
            let standardDeviation = dict["standardDeviation"]!
            
           sortedTestResults += "Start Threshold: \(startThreshold), End Threshold: \(endThreshold), Addition: \(add), Best Percentage Error = \(bestAbsolutePercentageError), Worst Percentage Error: \(worstAbsolutePercentageError), Standard Deviation: \(standardDeviation)\n"
        }
        
        print(testResults)
        
        sortedTestResults += resultsArray
        
        resultTextView.text = sortedTestResults
        
        
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