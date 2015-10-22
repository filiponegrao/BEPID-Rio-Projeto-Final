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
    
    //***************************
    //** Funcoes para contatos
    //***************************
    
    class func getRequests(callback: (requests: [FriendRequest]) -> Void) -> Void
    {
        var requests = [FriendRequest]()
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("target", equalTo: DAOUser.sharedInstance.getUserName())
        query.whereKey("status", equalTo: "Pendente")
        query.findObjectsInBackgroundWithBlock { ( objects:[AnyObject]?, error: NSError?) -> Void in
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    requests.append(FriendRequest(sender: object.valueForKey("sender") as! String, target: DAOUser.sharedInstance.getUserName()))
                    
                    if(object == objects.last)
                    {
                        callback(requests: requests)
                    }
                }
            }
            callback(requests: requests)
        }
        callback(requests: requests)
    }
    
    
    class func acceptRequestOnParse(request: FriendRequest, callback: (success: Bool, error: NSError) -> Void) -> Void
    {
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("sender", equalTo: request.sender)
        query.whereKey("target", equalTo: DAOUser.sharedInstance.getUserName())
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            print("Recebidos \(objects?.count) requests")
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    object.setValue("Aceito", forKey: "status")
                    DAOContacts.addContactByUsername(request.sender, callback: { (success, error) -> Void in
                        if(success == true)
                        {
                            print("Convite de amizade de \(request.sender) aceito e adicionado como contato")
                            self.updateObject(object)
                        }
                    })
                }
            }
            
        }

    }
    
    
    class func updateObject(object: PFObject)
    {
        var tried = 0
        object.saveEventually({ (success: Bool, error: NSError?) -> Void in
            if(success != true)
            {
                DAOFriendRequests.sharedInstance.loadRequests()
            }
            else if(tried < 10)
            {
                tried++
                self.updateObject(object)
            }
        })
    }
    
    
    class func finalizeRequests()
    {
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("sender", equalTo: DAOUser.sharedInstance.getUserName())
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            print(objects?.count)
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    let status = object.valueForKey("status") as! String
                    if(status == "Aceito")
                    {
                        let contact = object.valueForKey("target") as! String
                        DAOContacts.addContactByUsername(contact, callback: { (success, error) -> Void in
                            if(success == true)
                            {
                                print("adicionando \(contact) por ter aceitado o pedido de amizade")
                                object.deleteEventually()
                            }
                        })
                    }
                }
            }
            
        }
    }
    
    
    class func sendFriendRequest(username: String)
    {
        let query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        query?.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
            if(object != nil)
            {
                let request = PFObject(className: "FriendRequest")
                request["sender"] = DAOUser.sharedInstance.getUserName()
                request["target"] = username
                request["status"] = "Pendente"
                request.saveEventually({ (success : Bool, error: NSError?) -> Void in
                    if(success == true)
                    {
                        print("Convite de amizade enviado para \(username)")
                    }
                })
                
            }
            
        })
    }
    
    
    class func sendPushFriendRequest(username: String)
    {
        let message = "\(DAOUser.sharedInstance.getUserName()) quer lhe adicionar como um contato"
        
        let data = [ "title": "Convite de amizade no FFVChat",
            "alert": message, "badge": 1, "do": appNotification.friendRequest.rawValue]
        
        print("enviando notificacao")
        let userQuery = PFUser.query()
        userQuery?.whereKey("username", equalTo: username)
        
        // Find devices associated with these users
        let pushQuery = PFInstallation.query()
        pushQuery!.whereKey("user", matchesQuery: userQuery!)
        
        // Send push notification to query
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        push.setData(data as [NSObject : AnyObject])
        push.sendPushInBackground()
    }
    
    
    class func checkUserAlreadyRequested(username: String, callback: (was: Bool) -> Void) -> Void
    {
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("sender", equalTo: DAOUser.sharedInstance.getUserName())
        query.whereKey("target", equalTo: username)
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            
            if(object != nil)
            {
                callback(was: true)
            }
            else
            {
                callback(was: false)
            }
            
        }
    }
    
    
    class func decreaseTrustLevel()
    {
        if(PFUser.currentUser() != nil)
        {
            let tl = (PFUser.currentUser()!["trustLevel"] as! Int) - 1
            PFUser.currentUser()!["trustLevel"] = tl
            PFUser.currentUser()?.saveEventually()
        }
    }
    
    class func getTrustLevel(username: String, callback: (trustLevel : Int?) -> Void) -> Void
    {
        let query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        query?.getFirstObjectInBackgroundWithBlock({ (user: PFObject?, error: NSError?) -> Void in
            
            if(user != nil)
            {
                let tl = user!["trustLevel"] as! Int
                callback(trustLevel: tl)
            }
            else
            {
                callback(trustLevel: nil)
            }
            
        })
    }
    
    class func getUsernameFromFacebookId(facebookId: String, callback: (username: String?) -> Void) -> Void
    {
        let query = PFUser.query()
        query?.whereKey("facebookID", equalTo: facebookId)
        query?.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
            
            if(object != nil)
            {
                callback(username: object?.valueForKey("username") as? String)
            }
            else
            {
                callback(username: nil)
            }
        })
    }

}



