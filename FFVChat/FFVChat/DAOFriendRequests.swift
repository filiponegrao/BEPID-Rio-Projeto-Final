//
//  DAOFriendRequests.swift
//  FFVChat
//
//  Created by Filipo Negrao on 07/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation

enum requestNotification : String
{
    case requestsLoaded
    
    case reloadRequest
    
    case friendAdded
}


class FriendRequest
{
    let sender : String
    
    let target : String
    
    init(sender : String, target: String)
    {
        self.sender = sender
        self.target = target
    }
}



private let data = DAOFriendRequests()


class DAOFriendRequests
{
    var tried = 0
    
    var requests : [FriendRequest] = [FriendRequest]()
    
    init()
    {
        self.loadRequests()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadInfos", name: requestNotification.reloadRequest.rawValue, object: nil)
    }
    
    
    class var sharedInstance : DAOFriendRequests
    {
        return data
    }
    
    
    func getRequests() -> [FriendRequest]
    {
        return self.requests
    }
    
    
    func reloadInfos()
    {
        self.loadRequests()
        self.friendsAccepted()
    }
    
    func loadRequests()
    {
        DAOParse.getRequests { (requests) -> Void in
            
            self.requests = requests
            NSNotificationCenter.defaultCenter().postNotificationName(requestNotification.requestsLoaded.rawValue, object: nil)
        }
    }
    
    
    func acceptRequest(request: FriendRequest)
    {
        DAOParse.acceptRequestOnParse(request) { (success, error) -> Void in
            DAOParse.sendPushRequestAccepted(request.sender)
            if(success)
            {
                self.loadRequests()
            }
        }
    }
    
    /**
     * Check for friend that have accepted friend notifications
     * and add these friends as contact, and them remove the
     * notification from parse.
     */
    func friendsAccepted()
    {
        DAOParse.finalizeRequests()
    }
    
    
    func sendRequest(username: String)
    {
        DAOParse.sendFriendRequest(username)
        DAOParse.sendPushFriendRequest(username)
    }
    
    func sendRequest(facebookID facebookID : String)
    {
        DAOParse.getUsernameFromFacebookId(facebookID) { (username) -> Void in
            
            if(username != nil)
            {
                DAOParse.sendFriendRequest(username!)
                DAOParse.sendPushFriendRequest(username!)
            }
        }
    }
    
    
    func wasAlreadyRequested(username: String, callback: (was: Bool) -> Void) -> Void
    {
        DAOParse.checkUserAlreadyRequested(username) { (was) -> Void in
            
            callback(was: was)
        }
    }
        
}