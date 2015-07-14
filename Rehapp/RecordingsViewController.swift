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
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let getImagePath = paths.stringByAppendingPathComponent("4.json")
        
        let checkValidation = NSFileManager.defaultManager()
        
        if (checkValidation.fileExistsAtPath(getImagePath))
        {
            print("FILE AVAILABLE");
        }
        else
        {
            print("FILE NOT AVAILABLE");
        }
        
        print(FileHandler.listFilesAtDocumentDirectory())
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
    
        cell.textLabel?.text = recordArray[indexPath.row]
        
        return cell
        
    }
    
    
}

