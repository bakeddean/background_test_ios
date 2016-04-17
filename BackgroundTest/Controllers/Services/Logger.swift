//
//  Logger.swift
//  BackgroundTest
//
//  Created by Dean Woodward on 17/04/16.
//  Copyright © 2016 Dean Woodward. All rights reserved.
//

import Foundation

func *(string: String, scalar: Int) -> String {
    let array = Array(count: scalar, repeatedValue: string)
    return array.joinWithSeparator("")
}

class Logger {
    private var filePath: String!
    private var dateFormatter: NSDateFormatter!
    var timeFormatter: NSDateFormatter!
    
    static var sharedInstance: Logger = {
        let logger = Logger()
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        logger.filePath = (documentDirectory as NSString).stringByAppendingPathComponent("log-file.txt")
        if !NSFileManager.defaultManager().fileExistsAtPath(logger.filePath) {
            NSFileManager.defaultManager().createFileAtPath(logger.filePath, contents: nil, attributes: nil)
        }
        
        var formatter = NSDateFormatter()
        var format = NSDateFormatter.dateFormatFromTemplate("dd/MM/yy", options: 0, locale: NSLocale.currentLocale())
        formatter.dateFormat = format
        logger.dateFormatter = formatter
        
        formatter = NSDateFormatter()
        format = NSDateFormatter.dateFormatFromTemplate("h:mm:ss.SS a", options: 0, locale: NSLocale.currentLocale())
        formatter.dateFormat = format
        logger.timeFormatter = formatter
        
        return logger
    }()
    
    func log(content: String, withTime: Bool = true) {
        var taggedContent: String
        if withTime {
            taggedContent = timeFormatter.stringFromDate(NSDate())
            taggedContent += " - "
            taggedContent += content
        } else {
            taggedContent = content
        }
        taggedContent += "\n"
        
        if let fileHandle = NSFileHandle(forUpdatingAtPath: filePath) {
            fileHandle.seekToEndOfFile()
            fileHandle.writeData(taggedContent.dataUsingEncoding(NSUTF8StringEncoding)!)
            fileHandle.closeFile()
        }
    }
    
    func demarcate(withDate withDate: Bool = true) {
        if withDate {
            log(timeFormatter.stringFromDate(NSDate()), withTime: false)
        }
        log("-" * 40, withTime: false)
    }
    
    func logText() -> String {
        if let content = try? String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding) {
            return content
        }
        return ""
    }
    
    func reset() {
        if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(filePath)
                NSFileManager.defaultManager().createFileAtPath(filePath, contents: nil, attributes: nil)
            } catch {
                print("Unable to delete log file")
            }
        }
    }
}