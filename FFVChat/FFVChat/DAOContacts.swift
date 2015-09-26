//
//  DAOContacts.swift
//  FFVChat
//
//  Created by Filipo Negrao on 24/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Parse


enum ContactCondRet : String
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
                        let data = object.objectForKey("profileImage") as! PFFile
                        data.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                            
                            let image = UIImage(data: data!)
                            let username = object.valueForKey("username") as! String
                            let faceUsername = object.valueForKey("facebookID") as! String
                            let registerDate = object.valueForKey("createdAt") as! String
                            
//                            let contact = ["username": username, "faceUsername": faceUsername, "registerDate": registerDate, "thumb": image]
                            let contact = NSDictionary()
                            contact.setValue(image, forKey: "thumb")
                            contact.setValue(username, forKey: "username")
                            contact.setValue(faceUsername, forKey: "facebookID")
                            contact.setValue(registerDate, forKey: "createdAt")
                            
                            content?.setObject(contact, forKey: "\(username)")
                            content?.writeToFile(dataPath, atomically: true)
                            NSNotificationCenter.defaultCenter().postNotificationName(ContactCondRet.Ok.rawValue, object: nil)
                        })
                    }
                }
            }
            else
            {
                // Log details of the failure
                NSNotificationCenter.defaultCenter().postNotificationName(ContactCondRet.ContactNotFound.rawValue, object: nil)
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    class func getContact(username: String) -> (contact: Contact?, condret: ContactCondRet)
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("Contacts")
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath))
        {
            self.initContacts()
        }
        
        let content = NSMutableDictionary(contentsOfFile: dataPath)
        
        let data = content?.objectForKey(username) as? NSDictionary
        
        if(data == nil)
        {
            return (contact: nil, condret: ContactCondRet.ContactNotFound)
        }
        
        let contact = Contact(username: data?.valueForKey("username") as! String, facebookID: data?.valueForKey("facebookID") as! String, registerDate: data?.valueForKey("createdAt") as! String, thumb: data?.objectForKey("thumb") as! UIImage)
        
        print("contato recuperado com sucesso")
        return (contact: contact, condret: ContactCondRet.Ok)
    }
    
        
    
    
}





