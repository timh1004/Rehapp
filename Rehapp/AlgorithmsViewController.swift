//
//  AlgorithmsViewController.swift
//  Rehapp
//
//  Created by Tim Haug on 21.09.15.
//  Copyright © 2015 Tim Haug. All rights reserved.
//

import Foundation
import UIKit

class AlgorithmsViewController: UITableViewController {
    
    let exerciseCategories = ["One-Leg Hop", "Side Hops"]
    let oneLegHopAlgorithms = ["One-Leg Hop Algorithm"]
    let sideHopsAlgorithms = ["Side-Hops Algorithm"]
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return exerciseCategories.count
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return oneLegHopAlgorithms.count
//        case 1:
//            return sideHopsAlgorithms.count
//        default:
//            return 0
//        }
//    }
//    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return exerciseCategories[section]
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
//        
//        switch indexPath.section {
//        case 0:
//            cell.textLabel?.text = oneLegHopAlgorithms[indexPath.row]
//        case 1:
//            cell.textLabel?.text = sideHopsAlgorithms[indexPath.row]
//        default:
//            break
//        }
//        
//        
//        return cell
//    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showOneLegHopAlgorithmSettingsViewController" {
//            let destination = segue.destinationViewController as! OneLegHopAlgorithmSettingsViewController
//            let indexPath = tableView.indexPathForSelectedRow
//            switch indexPath!.section {
//            case 0:
//                destination.name = oneLegHopAlgorithms[indexPath!.row]
//            case 1:
//                destination.name = sideHopsAlgorithms[indexPath!.row]
//            default:
//                break
//            }
////            destination.hidesBottomBarWhenPushed = true
//        }
//    }
}