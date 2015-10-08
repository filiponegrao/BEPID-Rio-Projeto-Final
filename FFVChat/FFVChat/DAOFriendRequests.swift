//
//  DAOFriendRequests.swift
//  FFVChat
//
//  Created by Filipo Negrao on 07/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Parse


enum requestNotification : String
{
    case requestsLoaded
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
                        self.requests = requests
                        print("\(self.requests.count) requisicoes de amizade foram carregadas para o usuario atual")
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
    
    
    func sendRequest(username: String)
    {
        let query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objects = objects as? [PFObject]
            {
                if objects.count > 0
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
            }
            
        })
    }
    
    func updateObject(object: PFObject)
    {
        object.saveEventually({ (success: Bool, error: NSError?) -> Void in
            if(success != true)
            {
                self.tried = 0
                self.loadRequests()
            }
            else if(self.tried < 10)
            {
                self.tried++
                self.updateObject(object)
            }
        })
    }
    
    
}