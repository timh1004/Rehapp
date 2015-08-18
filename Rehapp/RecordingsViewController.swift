//
//  RecordingsViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 13.07.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation
import UIKit

class RecordingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    
    var recordArray: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordArray = FileHandler.listFilesAtDocumentDirectory()
        // Nur die JSON Files, sortieren nach aufsteigender Nummer
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
    
        cell.textLabel?.text = recordArray[indexPath.row]
        //Weitere Details einfügen (Name des Probanden etc.)
        
        return cell
        
    }
    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        <#code#>
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecordingDetailViewController" {
            let destination = segue.destinationViewController as! RecordingDetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            destination.fileName = recordArray[indexPath!.row]
        }
    }
    
    
}

