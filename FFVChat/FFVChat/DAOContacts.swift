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
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        let fileManager = NSFileManager.defaultManager()
        
        //check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("Contacts", ofType: "plist")
            {
                //                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                do { try fileManager.copyItemAtPath(bundlePath, toPath: path) }
                catch
                {
                    print("nao foi possivel criar a pasta")
                }
            }
            else
            {
                print("Contacts.plist not found. Please, make sure it is part of the bundle.")
            }
        }
        else
        {
            print("Contacts.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
    }
    
    
    class func getAllContacts() -> [Contact]
    {
        var contacts = [Contact]()
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            print("retornando pq nao tem nada em content")
            return contacts
        }
        
        print(content?.count)
        for(var i = 0; i < content?.count; i++)
        {
            let data = content?.allValues[i].valueForKey("thumb") as! NSData
            let image = UIImage(data: data)
            contacts.append( Contact(username: content?.allValues[i].valueForKey("username") as! String, facebookID: content?.allValues[i].valueForKey("facebookID") as! String, registerDate: content?.allValues[i].valueForKey("createdAt") as! String, thumb: image!))
            print(contacts)
        }
        
        return contacts
    }
    
    
    class func getContact(username: String) -> Contact?
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        
        let content = NSDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            print("retornando pq nao tem nada em content")
            return nil
        }
        
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
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initContacts()
        }
        
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
                            
                            let username = object.valueForKey("username") as! String
                            let faceUsername = object.valueForKey("facebookID") as! String
                            let registerDate = object.valueForKey("createdAt") as! String
                            
                            let contact = NSMutableDictionary()
                            contact.setValue(data, forKey: "thumb")
                            contact.setValue(username, forKey: "username")
                            contact.setValue(faceUsername, forKey: "facebookID")
                            contact.setValue(registerDate, forKey: "createdAt")
                            content!.setObject(contact, forKey: "\(username)")
                            content!.writeToFile(path, atomically: false)
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
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        
        var content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initContacts()
            content = NSMutableDictionary(contentsOfFile: path)
        }
        
        let query = PFUser.query()
        query!.whereKey("facebookID", equalTo: id)
        print(id)
        query!.findObjectsInBackgroundWithBlock {
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
                            let registerDateDate = object.valueForKey("createdAt") as! NSDate
                            let registerDate = "\(registerDateDate)"
                            
                            print("username: \(username) id: \(faceUsername) date: \(registerDate) image: \(data)")
                            
                            let contact = ["thumb":data!, "username":username, "facebookID":faceUsername, "createdAt":registerDate]

                            print(content)
                            print(content?.setObject(contact, forKey: "\(username)"))
                            print(content?.writeToFile(path, atomically: false))
                            
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
    
    
    class func testPush(id: String)
    {
        let message = "Alert !!"
        
        let data = [ "title": "Some Title",
            "alert": message]
        
        let userQuery: PFQuery = PFUser.query()!
        userQuery.whereKey("objectId", equalTo: id)
        let query: PFQuery = PFInstallation.query()!
        query.whereKey("currentUser", matchesQuery: userQuery)
        
        let push: PFPush = PFPush()
        push.setQuery(query)
        push.setData(data)
        push.sendPushInBackground()
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
                callback(object.valueForKey("username") as? String)
            }
        })
        
        callback(nil)
    }
    
    
    class func getUsersWithString(string: String, callback: ([metaContact]) -> Void) -> Void
    {
        var result = [metaContact]()
        
        let query = PFUser.query()
        query?.whereKey("username", containsString: string)
        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    let username = object.valueForKey("username") as! String
                    let trustLevel = object.valueForKey("trustLevel") as! Int
                    let id = object.valueForKey("objectId") as! String
                    
                    let mc = metaContact(username: username, trustLevel: trustLevel, photo: nil, id: id)
                    result.append(mc)
                    
                    if(object.valueForKey("username") as! String == objects.last?.valueForKey("username") as! String)
                    {
                        callback(result)
                    }

                }
            }
            else
            {
                callback(result)
            }
        })
    }
    
    
    class func getPhotoFromUsername(username: String, callback: (image: UIImage?) -> Void) -> Void
    {
        let query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    let data = object.objectForKey("profileImage") as! PFFile
                    data.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                        
                        if(data == nil)
                        {
                            callback(image: nil)
                        }
                        else
                        {
                            let image = UIImage(data: data!)
                            callback(image: image)
                        }
                    })
                }
                callback(image: nil)
            }
            else
            {
                callback(image: nil)
            }
            
        })
    }
    
    
    class func isContact(username: String) -> Bool
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            return false
        }
        
        let contacts = self.getAllContacts()
        
        for contact in contacts
        {
            if(username == contact.username)
            {
                return true
            }
        }
        
        return false
    }
    
}





