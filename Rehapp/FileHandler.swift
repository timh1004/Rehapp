//
//  JsonFileHandler.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 19.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation
import UIKit

class FileHandler {
    
    private class func getDocumentDirectoryURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    private class func getDocumentDirectoryPath() -> String {
        //get the documents directory:
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let documentsDirectory = paths[0]
        print("Documents directory: \(documentsDirectory)")
        return documentsDirectory
    }
    
    private class func getFilePathForFileName(fileName: String) -> String {
        let fileURL = FileHandler.getDocumentDirectoryURL().URLByAppendingPathComponent(fileName)
        return fileURL.path!
//        return FileHandler.getDocumentDirectoryPath().stringByAppendingPathComponent(fileName)
    }
    
    class func writeToFile(fileName: String, content: String) {
        var error: NSError?
        let written: Bool
        do {
            try content.writeToFile(FileHandler.getFilePathForFileName(fileName), atomically: false, encoding: NSUTF8StringEncoding)
            written = true
        } catch let error1 as NSError {
            error = error1
            written = false
        }
        
        if let actualError = error {
            print("Error writing JSON to file: \(actualError)")
        }
        
        if (written) {
            let writtenContent = FileHandler.readFromFile(fileName)
            print(writtenContent)
            NSNotificationCenter.defaultCenter().postNotificationName("newFileWritten", object: nil)
        }
    }
    
    class func readFromFile(fileName: String) -> String {
        return readFileFromPath(FileHandler.getFilePathForFileName(fileName))
    }
    
    class func readFileFromPath(path: String) -> String {
        let fileContent: NSString?
        do {
            fileContent = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        } catch _ {
            fileContent = nil
        }
        if let content = fileContent {
            return content as String
        } else {
            return ""
        }
    }
    
    class func listFilesAtDocumentDirectory() -> [String] {
        var error: NSError?
        var contentList: [String]?
        let directoryContents =  getDocumentDirectoryPath()
        do {
            contentList = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(directoryContents) as [String]
            
        } catch let error1 as NSError {
            error = error1
        }
        if let actualError = error {
            print("Error reading content file list: \(actualError)")
        }
        if let content = contentList {
            return content
        } else {
            return ["nicht gefunden"]
        }
        
    }
    
    class func deleteFileWithFileName(fileName: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(FileHandler.getFilePathForFileName(fileName))
        } catch {
            print("Konnte nicht löschen")
        }
    }
}
