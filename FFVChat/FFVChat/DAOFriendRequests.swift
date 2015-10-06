//
//  DAOFriendRequests.swift
//  FFVChat
//
//  Created by Filipo Negrao on 04/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Parse

enum requestNotification : String
{
    case requestsLoaded
}

private let data = DAOFriendRequests()

class DAOFriendRequests
{
    
    var requests : [FriendRequest] = [FriendRequest]()
    
    init()
    {
        self.loadRequests()
    }
    
    
    class var sharedInstance : DAOFriendRequests
    {
        return data
    }
    
    
    func getRequests() -> [FriendRequest]
    {
        return self.requests
    }
    
    
    func loadRequests()
    {
        var requests = [FriendRequest]()
        let query = PFQuery(className: "FriendRequest")
        print(DAOUser.sharedInstance.getUserName())
        query.whereKey("target", equalTo: DAOUser.sharedInstance.getUserName())
        query.whereKey("status", equalTo: "Pendente")
        query.findObjectsInBackgroundWithBlock { ( objects:[AnyObject]?, error: NSError?) -> Void in
            print(objects?.count)
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    requests.append(FriendRequest(sender: object.valueForKey("sender") as! String, target: DAOUser.sharedInstance.getUserName()))
                    
                    if(object == objects.last)
                    {
                        self.requests = requests
                        print("notificacoes carregadas")
                        NSNotificationCenter.defaultCenter().postNotificationName(requestNotification.requestsLoaded.rawValue, object: nil)
                    }
                }
            }
            self.requests = requests
        }
        self.requests = requests
    }

    
    func acceptRequest(request: FriendRequest)
    {
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("sender", equalTo: request.sender)
        query.whereKey("target", equalTo: DAOUser.sharedInstance.getUserName())
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    object.setValue("Aceito", forKey: "status")
                    DAOContacts.addContactByUsername(request.sender)
                    object.saveEventually()
                }
            }
            
        }
    }
    
    func friendsAccepted()
    {
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("sender", equalTo: DAOUser.sharedInstance.getUserName())
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    let status = object.valueForKey("status") as! String
                    if(status == "Aceito")
                    {
                        DAOContacts.addContactByUsername(object.valueForKey("target") as! String)
                        object.deleteEventually()
                    }
                }
            }
            
        }
    }
    
    
    func sendRequest(username: String)
    {
        let query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objects = objects as? [PFObject]
            {
                print(objects.count)
                if objects.count > 0
                {
                    let request = PFObject(className: "FriendRequest")
                    request["sender"] = DAOUser.sharedInstance.getUserName()
                    request["target"] = username
                    request["status"] = "Pendente"
                    request.saveEventually()
                }
            }
            
        })
    }
    
    
    
    
}