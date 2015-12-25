//
//  BlackList.swift
//  FFVChat
//
//  Created by Filipo Negrao on 30/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation



class BlackList
{
    class func initBlackList()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("BlackList.plist")
        let fileManager = NSFileManager.defaultManager()
        
        //check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("BlackList", ofType: "plist")
            {
                do { try fileManager.copyItemAtPath(bundlePath, toPath: path)}
                catch { print("Erro ao criar BlackList")}
                print("BlackList criado com sucesso!...")
            }
            else
            {
                print("BlackList.plist not found. Please, make sure it is part of the bundle.")
            }
            
        }
        else
        {
            print("BlackList already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
    }
    
    
    class func isOnBlackList(username: String) -> Bool
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("BlackList.plist")
        
        let contents = NSMutableDictionary(contentsOfFile: path)
        
        if(contents == nil) { return false }
        
        let name = contents?.valueForKey("\(username)") as? String
        
        if(name == nil) { return false }
        
        else { return true }
    }
    
    
    class func addOnBlackList(username: String)
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("BlackList.plist")
        
        let contents = NSMutableDictionary(contentsOfFile: path)
        
        if(contents == nil) { return }
        
        contents!.setValue(username, forKey: username)
        
        contents!.writeToFile(path, atomically: false)
    }
    
    
    class func removeFromBlackList(username: String)
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("BlackList.plist")
        
        let contents = NSMutableDictionary(contentsOfFile: path)
        
        if(contents == nil) { return }

        contents!.removeObjectForKey(username)
        
        contents!.writeToFile(path, atomically: false)
    }
    
    
    
}