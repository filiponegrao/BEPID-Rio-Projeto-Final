//
//  DAOParse.swift
//  FFVChat
//
//  Created by Filipo Negrao on 18/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Parse


class DAOParse
{
    
    //***************************
    //** Funcoes para contatos
    //***************************
    
    class func getContactFromParse(username: String, callback: (contact: Contact?, error: NSError?) -> Void) -> Void
    {
        let query = PFUser.query()!
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
                            let registerDate = object.valueForKey("createdAt") as! NSDate
                            let date = "\(registerDate)"
                            
                            let contact = Contact(username: username, registerDate: date, thumb: UIImage(data: data!)!)
                            callback(contact: contact, error: nil)
                        })
                    }
                }
                else
                {
                    callback(contact: nil, error: error_noUser)
                }
                
            }
            else
            {
                print("Error: \(error!) \(error!.userInfo)")
                callback(contact: nil, error: NSError(domain: (error?.description)!, code: 999, userInfo: nil))
            }
        }
    }
    
    
    class func getContactFromParseWithID(facebookId: String, callback: (contact: Contact?, error: NSError?) -> Void) -> Void
    {
        let query = PFUser.query()
        query!.whereKey("facebookID", equalTo: facebookId)
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
                            
                            if(data != nil)
                            {
                                let username = object.valueForKey("username") as! String
                                let registerDateDate = object.valueForKey("createdAt") as! NSDate
                                let registerDate = "\(registerDateDate)"
                                
                                let contact = Contact(username: username, registerDate: registerDate, thumb: UIImage(data: data!)!)
                                callback(contact: contact, error: nil)
                            }
                            else
                            {
                                callback(contact: nil, error: error_incompleteUser)
                            }
                        })
                    }
                }
                else
                {
                    callback(contact: nil, error: error_noUser)
                }
            }
            else
            {
                // Log details of the failure
                NSNotificationCenter.defaultCenter().postNotificationName(ContactCondRet.ContactNotFound.rawValue, object: nil)
                print("Error: \(error!) \(error!.userInfo)")
                callback(contact: nil, error: error)
            }
        }
    }
    
    
    class func getFacebookProfilePicture(facebookID: String, callback : (UIImage?) -> Void) -> Void {
        
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
    
    
    class func getUsernameFromFacebookID(id: String, callback : (String)? -> Void) -> Void
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
                    if(!DAOContacts.isContact(username) && username != DAOUser.sharedInstance.getUserName())
                    {
                        let trustLevel = object.valueForKey("trustLevel") as! Int
                        let id = object.valueForKey("objectId") as! String
                        
                        let mc = metaContact(username: username, trustLevel: trustLevel, photo: nil, id: id)
                        result.append(mc)
                        
                    }
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
}