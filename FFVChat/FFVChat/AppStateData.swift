//
//  AppStateData.swift
//  FFVChat
//
//  Created by Filipo Negrao on 26/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation

private let data : AppStateData = AppStateData()

class AppStateData : NSObject
{
    
    override init()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("AppState.plist")
        let fileManager = NSFileManager.defaultManager()
        
        //check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("AppState", ofType: "plist")
            {
                do { try fileManager.copyItemAtPath(bundlePath, toPath: path)}
                catch { print("Erro ao criar AppState")}
                print("AppState criado com sucesso!...")
            }
            else
            {
                print("AppState.plist not found. Please, make sure it is part of the bundle.")
            }
            
        }
        else
        {
            print("AppState.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
    }
    
    
    class var sharedInstance : AppStateData
    {
        return data
    }
    
    
    func termsOfUseAccepted() -> Bool
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("AppState.plist")
        
        let content = NSDictionary(contentsOfFile: path)

        let terms = content?.objectForKey("TermsOfUse") as! NSDictionary
        
        return terms.valueForKey("accepted") as! Bool
    }
    
    
    func contactsImported() -> Bool
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("AppState.plist")
        
        let content = NSDictionary(contentsOfFile: path)
        
        let imported = content?.objectForKey("ContactsImported") as! NSDictionary
        
        return imported.valueForKey("imported") as! Bool
    }
    
    
    func acceptTermsOfUse()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("AppState.plist")
        
        let content = NSMutableDictionary(contentsOfFile: path)
        
        let terms = content?.objectForKey("TermsOfUse") as! NSDictionary
        
        terms.setValue(true, forKey: "accepted")
        content?.writeToFile(path, atomically: false)
    }
    
    func importContacts()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("AppState.plist")
        
        let content = NSMutableDictionary(contentsOfFile: path)
        
        let contacts = content?.objectForKey("ContactsImported") as! NSDictionary
        
        contacts.setValue(true, forKey: "imported")
        content?.writeToFile(path, atomically: false)
    }
    
}



