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

enum ContactNotification : String
{
    case contactAdded = "contactAdded"
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
    
    
    class func getAllContacts() -> [Contact]
    {
        var contacts = [Contact]()
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("Contacts")
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath))
        {
            self.initContacts()
            if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath))
            {
                return contacts
            }
            
        }
        
        let content = NSDictionary(contentsOfFile: dataPath)
        
        if(content == nil)
        {
            return contacts
        }
        
        for(var i = 0; i < content?.count; i++)
        {
            contacts.append( Contact(username: content?.allValues[i].valueForKey("username") as! String, facebookID: content?.allValues[i].valueForKey("facebookID") as! String, registerDate: content?.allValues[i].valueForKey("createdAt") as! String, thumb: content?.allValues[i].valueForKey("thumb") as! UIImage))
        }
        
        return contacts
    }
    
    
    class func getContact(username: String) -> Contact?
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
            return nil
        }
        
        let contact = Contact(username: data?.valueForKey("username") as! String, facebookID: data?.valueForKey("facebookID") as! String, registerDate: data?.valueForKey("createdAt") as! String, thumb: data?.objectForKey("thumb") as! UIImage)
        
        print("contato recuperado com sucesso")
        return contact
    }

    
    class func addContactByUsername(username: String)
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
                            
                            let contact = NSDictionary()
                            contact.setValue(image, forKey: "thumb")
                            contact.setValue(username, forKey: "username")
                            contact.setValue(faceUsername, forKey: "facebookID")
                            contact.setValue(registerDate, forKey: "createdAt")
                            
                            content?.setObject(contact, forKey: "\(username)")
                            content?.writeToFile(dataPath, atomically: true)
                            NSNotificationCenter.defaultCenter().postNotificationName(ContactNotification.contactAdded.rawValue, object: nil)
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
    
    
    class func addContactByID(id: String)
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
        query.whereKey("facebookID", equalTo: id)
        
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
                            
                            let contact = NSDictionary()
                            contact.setValue(image, forKey: "thumb")
                            contact.setValue(username, forKey: "username")
                            contact.setValue(faceUsername, forKey: "facebookID")
                            contact.setValue(registerDate, forKey: "createdAt")
                            
                            print("Contato \(username) foi adicionado")
                            content?.setObject(contact, forKey: "\(username)")
                            content?.writeToFile(dataPath, atomically: true)
                            NSNotificationCenter.defaultCenter().postNotificationName(ContactNotification.contactAdded.rawValue, object: nil)
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
    
    
    class func getProfilePicture(facebookID: String, callback : (UIImage?) -> Void) -> Void {

        let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
        
        let URLRequest = NSURL(string: pictureURL)
        let URLRequestNeeded = NSURLRequest(URL: URLRequest!)
        
        NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse? ,data: NSData?, error: NSError?) -> Void in
            if error == nil
            {
                let image = UIImage(data: data!)
                callback(image)
                
            }
            else
            {
                print("erro ao carregar imagem de um contato")
                callback(nil)
            }
        })
    }
    
    
    class func getUsernameFromID(id: String, callback : (String)? -> Void) -> Void
    {
        let query = PFUser.query()
        query?.whereKey("facebookID", equalTo: id)
        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if(objects?.count > 0)
            {
                let object = objects![0] as! PFObject
                callback(object.valueForKey("username") as! String)
            }
        })
        
        callback(nil)
    }
    
    
}





