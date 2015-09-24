//
//  DAOContacts.swift
//  FFVChat
//
//  Created by Filipo Negrao on 24/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Parse


enum ContactCondRet
{
    case Ok
    
    case ContactNotFound
    
    
}

class DAOContacts
{
    
    class func initContacts()
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("Contacts")
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath))
        {
            do { try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
                
                print("Pasta de contatos criada com sucesso")
            }
            catch
            {
                print("Deu merda ao criar a pasta de contatos")
            }
        }
    }
    
    
//    class func getAllContacts() -> (condRet: ContactCondRet, contacts: [Contacts]?)
//    {
//        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//        let documentsDirectory: AnyObject = paths[0]
//        let dataPath = documentsDirectory.stringByAppendingPathComponent("Contacts")
//        
//        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath))
//        {
//            self.initContacts()
//        }
//        
//        let data = NSFileManager.defaultManager().contentsAtPath(dataPath) as!
//        
//    }

    
    class func addContact(username: String)
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("Contacts")
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath))
        {
            self.initContacts()
        }
        
        let content = NSMutableDictionary(contentsOfFile: dataPath)
        
        let query = PFQuery(className:"User")
        query.whereKey("username", equalTo: username)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil
            {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) users.")
                // Do something with the found objects
                if let objects = objects as? [PFObject]
                {
                    for object in objects
                    {
                        let username = object.valueForKey("username") as! String
                        let faceUsername = object.valueForKey("faceUsername") as! String
                        let registerDate = object.valueForKey("createdAt") as! String
                        let contact = ["username": username, "faceUsername": faceUsername, "registerDate": registerDate]
                        content?.setObject(contact, forKey: "\(username)")
                        content?.writeToFile(dataPath, atomically: true)
                    }
                }
            }
            else
            {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
}