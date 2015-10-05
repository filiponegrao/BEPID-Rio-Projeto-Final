//
//  DAOFriendRequests.swift
//  FFVChat
//
//  Created by Filipo Negrao on 04/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Parse


class DAOFriendRequests
{
    
    class func requestsRemain(callback:(requests : [FriendRequest])-> Void) -> Void
    {
        var requests = [FriendRequest]()
        print(DAOUser.sharedInstance.getBdKey())
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("target", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { ( objects:[AnyObject]?, error: NSError?) -> Void in
            
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    requests.append(FriendRequest(sender: object.valueForKey("username") as! String, target: DAOUser.sharedInstance.getUserName()))
                    
                    if(object == objects.last)
                    {
                        callback(requests: requests)
                    }
                }
            }
            callback(requests: requests)
        }
    }
    
}