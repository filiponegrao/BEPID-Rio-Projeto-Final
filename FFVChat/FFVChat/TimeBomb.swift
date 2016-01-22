//
//  TimeBomb.swift
//  FFVChat
//
//  Created by Filipo Negrao on 19/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

private let data = TimeBomb()

class TimeBomb
{
    class var sharedInstance : TimeBomb
    {
        return data
    }
    
    init()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("TimeBomb.plist")
        let fileManager = NSFileManager.defaultManager()
        
        //check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("TimeBomb", ofType: "plist")
            {
                do { try fileManager.copyItemAtPath(bundlePath, toPath: path)}
                catch { print("Erro ao criar TimeBomb")}
                print("TimeBomb criado com sucesso!...")
            }
            else
            {
                print("TimeBomb.plist not found. Please, make sure it is part of the bundle.")
            }
            
        }
        else
        {
            print("TimeBomb already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
    }
    
    func addTimer(id: String, seenDate: NSDate, lifeTime: Int)
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("TimeBomb.plist")
        
        let contents = NSMutableDictionary(contentsOfFile: path)
        
        if(contents == nil) { return }
        
        let dict = NSDictionary(dictionary: ["id": id, "seenDate": seenDate, "lifeTime": lifeTime])
        
        contents!.setObject(dict, forKey: id)
        
        contents!.writeToFile(path, atomically: false)
    }
    
    func removeTimer(id: String)
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("TimeBomb.plist")
        
        let contents = NSMutableDictionary(contentsOfFile: path)
        
        if(contents == nil) { return }
        
        contents!.removeObjectForKey(id)
        
        contents!.writeToFile(path, atomically: false)
    }
    
    func doneTimers() -> [String]
    {
        var ids = [String]()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("TimeBomb.plist")
        
        let contents = NSMutableDictionary(contentsOfFile: path)
        
        if(contents == nil) { return ids }
        
//        let itens = contents as! NSArray
        
        for content in contents!
        {
            let seenDate = (content.value as! NSDictionary).valueForKey("seenDate") as! NSDate
            let lifeTime = (content.value as! NSDictionary).valueForKey("lifeTime") as! Int
            let id = (content.value as! NSDictionary).valueForKey("id") as! String
            
            let calendar = NSCalendar.currentCalendar()
            let doneTime = calendar.dateByAddingUnit(.Second, value: lifeTime, toDate: seenDate, options: [])
            
            if(NSDate().isGreaterThanDate(doneTime!))
            {
                ids.append(id)
            }
//            print(content)
        }
        return ids
    }
    
    func checkForOldTimers() -> [String]
    {
        var ids = [String]()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("TimeBomb.plist")
        
        let contents = NSMutableDictionary(contentsOfFile: path)
        
        if(contents == nil) { return ids }
        
        //        let itens = contents as! NSArray
        
        for content in contents!
        {
            let seenDate = (content.value as! NSDictionary).valueForKey("seenDate") as! NSDate
            let lifeTime = (content.value as! NSDictionary).valueForKey("lifeTime") as! Int
            let id = (content.value as! NSDictionary).valueForKey("id") as! String
            
            let calendar = NSCalendar.currentCalendar()
            let doneTime = calendar.dateByAddingUnit(.Second, value: lifeTime, toDate: seenDate, options: [])
            
            if(doneTime!.isGreaterThanDate(NSDate()))
            {
                ids.append(id)
            }
        }
        return ids
    }
    
    func getSeenDateById(id: String) -> NSDate?
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("TimeBomb.plist")
        
        let contents = NSMutableDictionary(contentsOfFile: path)
        
        if(contents == nil) { return nil }
        
        
        let content = contents?.objectForKey(id)
        
        if(content == nil) { return nil }
        
        return content!.valueForKey("seenDate") as? NSDate
    }
    
}




