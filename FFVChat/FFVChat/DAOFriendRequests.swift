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


class FriendRequest : NSObject
{
    let sender : String
    
    let target : String
    
    let id : String
    
    init(id: String, sender : String, target: String)
    {
        self.id = id
        self.sender = sender
        self.target = target
    }
}



private let data = DAOFriendRequests()


class DAOFriendRequests : NSObject
{
    var tried = 0
    
    var requests : [FriendRequest] = [FriendRequest]()
    
    override init()
    {
        super.init()
        
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
        self.requests = [FriendRequest]()
        DAOPostgres.sharedInstance.checkForUnacceptedFriendRequests { (friendRequests) -> Void in
            
            for fr in friendRequests
            {
                if(friendRequests.count > 0)
                {
                    print("eniando notification")
                    NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.friendRequest)
                }
                
                if(DAOContacts.sharedInstance.isContact(fr.sender) && !BlackList.isOnBlackList(fr.sender))
                {
                    DAOPostgres.sharedInstance.setRequestAccepted(fr.id, callback: { (success) -> Void in
                        
                    })
                }
                else
                {
                    self.requests.append(fr)
                }
            }
        }
    }
    
    
    func acceptRequest(request: FriendRequest)
    {
        DAOParse.getContactInfoFromParse(request.sender, callback: { (contactInfo, error) -> Void in
            
            if(error == nil)
            {
                DAOContacts.sharedInstance.addContact(contactInfo["username"] as! String, facebookId: contactInfo["facebookId"] as? String, createdAt: contactInfo["createdAt"] as! NSDate, trustLevel: contactInfo["trustLevel"] as! Int, profileImage: (contactInfo["profileImage"] as! NSData))
                
                DAOPostgres.sharedInstance.setRequestAccepted(request.id) { (success) -> Void in
                    
                    if(success)
                    {
                        DAOParse.sendPushRequestAccepted(request.sender)
                        let index = self.requests.indexOf(request)
                        if(index != nil)
                        {
                            self.requests.removeAtIndex(index!)
                        }
                    }
                }

            }
            else
            {
                print(error)
            }
        })
    }
    
    /**
     * Check for friend that have accepted friend notifications
     * and add these friends as contact, and them remove the
     * notification from parse.
     */
    func friendsAccepted()
    {
        DAOPostgres.sharedInstance.checkForAcceptedFriendRequests { (friendRequests) -> Void in
            
            for fr in friendRequests
            {
                DAOParse.getContactInfoFromParse(fr.target, callback: { (contactInfo, error) -> Void in
                    
                    if(error == nil)
                    {
                        DAOContacts.sharedInstance.addContact(contactInfo["username"] as! String, facebookId: contactInfo["facebookId"] as? String, createdAt: contactInfo["createdAt"] as! NSDate, trustLevel: contactInfo["trustLevel"] as! Int, profileImage: (contactInfo["profileImage"] as! NSData))
                        DAOPostgres.sharedInstance.deleteFriendRequest(fr.id)
                    }
                })
            }
        }
    }
    
    
    func sendRequest(username: String)
    {
        var key = "\(DAOUser.sharedInstance.getUsername())\(username)\(NSDate())"
        key = EncryptTools.encKey(key)
        
        DAOPostgres.sharedInstance.sendFriendRequest(key, username: username)
        DAOParse.sendPushFriendRequest(username)
        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.friendRequested)
    }
    
    func sendRequest(facebookID facebookID : String)
    {
        DAOParse.getUsernameFromFacebookId(facebookID) { (username) -> Void in
            
            if(username != nil)
            {
                var key = "\(DAOUser.sharedInstance.getUsername())\(username!)\(NSDate())"
                key = EncryptTools.encKey(key)
                
                DAOPostgres.sharedInstance.sendFriendRequest(key, username: username!)
                DAOParse.sendPushFriendRequest(username!)
            }
        }
    }
    
    
    func wasAlreadyRequested(username: String, callback: (was: Bool) -> Void) -> Void
    {
        DAOPostgres.sharedInstance.checkForUsernameFriendRequests(username) { (exist) -> Void in
            
            callback(was: !exist)
        }
    }
    
}