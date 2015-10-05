//
//  DAOFriendRequests.swift
//  FFVChat
//
//  Created by Filipo Negrao on 04/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Parse

private let data = DAOFriendRequests()

class DAOFriendRequests
{
    
    var requests : [FriendRequest] = [FriendRequest]()
    
    init()
    {
        
        
        
    }
    
    
    class var sharedInstance : DAOFriendRequests
    {
        return data
    }
    
    func requestsRemain()
    {
        var requests = [FriendRequest]()
        let query = PFQuery(className: "FriendRequest")
        print(DAOUser.sharedInstance.getUserName())
        query.whereKey("target", equalTo: DAOUser.sharedInstance.getUserName())
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
                    }
                }
            }
            self.requests = requests
        }
        self.requests = requests
    }
    
    
    func getRequests
    
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
    
}