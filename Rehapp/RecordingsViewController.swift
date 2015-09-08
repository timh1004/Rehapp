//
//  RecordingsViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 13.07.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation
import UIKit

// doesn't work
//extension String {
//    func chopPrefix(count: Int = 1) -> String {
//        return self.substringFromIndex(advance(self.startIndex, count))
//    }
//    
//    func chopSuffix(count: Int = 1) -> String {
//        return self.substringToIndex(advance(self.endIndex, -count))
//    }
//}

class RecordingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    
    var recordArray: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableViewOnNotification:", name: "newFileWritten", object: nil)
//        recordArray = FileHandler.listFilesAtDocumentDirectory()
        // Nur die JSON Files, sortieren nach aufsteigender Nummer
    }
    
    func getRecordArray() -> [String] {
        let filteredArray = FileHandler.listFilesAtDocumentDirectory().filter{$0.hasSuffix(".json")}
        let sortedArray = filteredArray.sort(){$0 < $1}
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
        return getRecordArray().count
//        return recordArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        recordArray = getRecordArray()
        cell.textLabel?.text = recordArray[indexPath.row]
        //Weitere Details einfügen (Name des Probanden etc.)
        
        
        return cell
        
    }
    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        <#code#>
//    }

    func updateTableViewOnNotification(notification: NSNotification) {
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecordingDetailViewController" {
            let destination = segue.destinationViewController as! RecordingDetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            destination.fileName = recordArray[indexPath!.row]
            
            destination.hidesBottomBarWhenPushed = true
        }
    }
    
    
}

