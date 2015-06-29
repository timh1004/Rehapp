//
//  JsonFileHandler.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 19.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

class FileHandler {
    private class func getDocumentDirectoryPath() -> String {
        //get the documents directory:
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let documentsDirectory: String? = paths.first as? String
        return documentsDirectory!
    }
    
    private class func getFilePathForFileName(fileName: String) -> String {
        return FileHandler.getDocumentDirectoryPath().stringByAppendingPathComponent(fileName)
    }
    
    class func writeToFile(fileName: String, content: String) {
        var error: NSError?
        let written = content.writeToFile(FileHandler.getFilePathForFileName(fileName), atomically: false, encoding: NSUTF8StringEncoding, error: &error)
        
        if let actualError = error {
            println("Error writing JSON to file: \(actualError)")
        }
        
        if (written) {
            let writtenContent = FileHandler.readFromFile(fileName)
        }
    }
    
    class func readFromFile(fileName: String) -> String {
        return readFileFromPath(FileHandler.getFilePathForFileName(fileName))
    }
    
    class func readFileFromPath(path: String) -> String {
        let fileContent = NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        if let content = fileContent {
            return content as! String
        } else {
            return ""
        }
    }
}
