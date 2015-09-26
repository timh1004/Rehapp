//
//  RecordingsViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 13.07.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation
import UIKit

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
}

class RecordingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!

    
    var sortedRecordArray: [Record]!
    var json: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableViewOnNotification:", name: "newFileWritten", object: nil)
//        recordArray = FileHandler.listFilesAtDocumentDirectory()
        // Nur die JSON Files, sortieren nach aufsteigender Nummer
        
        sortedRecordArray = getRecordArray()
        
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
//        var filteredArrayWihtoutSuffix: [String]!
//        for item in filteredArray {
//            let startIndex = item.endIndex.advancedBy(-4)
//            let substring = item.substringFromIndex(startIndex)
//            filteredArrayWihtoutSuffix.append(substring)
//
//        }
        return sortedArray
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedRecordArray.count
//        return recordArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        var foot = String()
        var exercise = String()
        var cellText = String()
        
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "dd.MM.yy, HH:mm:ss.SSS"
        
        let creationDate = sortedRecordArray[indexPath.row].sensorData[0].creationDate
        
        if sortedRecordArray[indexPath.row].foot {
            foot = "Left"
        } else {
            foot = "Right"
        }
        
        if sortedRecordArray[indexPath.row].isSideHops {
            exercise = "Side Hops"
            cellText = "ID: \(sortedRecordArray[indexPath.row].id) - \(exercise) - \(foot) Foot - Jump count: \(sortedRecordArray[indexPath.row].jumpCount)"
        } else {
            exercise = "One-Leg Hop"
            cellText = "ID: \(sortedRecordArray[indexPath.row].id) - \(exercise) - \(foot) Foot - Distance: \(sortedRecordArray[indexPath.row].jumpDistanceInCm) cm - Calculated jump duration: \(OneLegHopAlgorithm.calculateResult(sortedRecordArray[indexPath.row])) ms"
            print("jumpDuration: \(OneLegHopAlgorithm.calculateResult(sortedRecordArray[indexPath.row]))")
        }
        
        cell.textLabel?.text = cellText
        cell.detailTextLabel?.text = "Name: \(sortedRecordArray[indexPath.row].name), Creation date: \(dateFormater.stringFromDate(creationDate))"
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            sortedRecordArray.removeAtIndex(indexPath.row)
            
            print("delete: \(sortedRecordArray[indexPath.row].id), index: \(indexPath.row)")
            FileHandler.deleteFileWithFileName("\(sortedRecordArray[indexPath.row].id).json")
            
            tableView.endUpdates()
        }
    }
    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//
//    }

    func updateTableViewOnNotification(notification: NSNotification) {
        sortedRecordArray = getRecordArray()
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecordingDetailViewController" {
            let destination = segue.destinationViewController as! RecordingDetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            destination.fileName = "\(sortedRecordArray[indexPath!.row].id).json"
            destination.record = sortedRecordArray[indexPath!.row]
            
//            destination.hidesBottomBarWhenPushed = true
        }
    }
    
    
}

