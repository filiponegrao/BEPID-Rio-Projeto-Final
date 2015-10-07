////
////  DAONotifications.swift
////  FFVChat
////
////  Created by Filipo Negrao on 07/10/15.
////  Copyright © 2015 FilipoNegrao. All rights reserved.
////
//
//import Foundation
//import Parse
//
//
//enum notificationNotification : String
//{
//    case notificationsLoaded
//}
//
//
//class Notification
//{
//    let text : String
//    
//    init(text: String)
//    {
//        self.text = text
//    }
//}
//
//
//private let data = DAONotifications()
//
//
//class DAONotifications
//{
//    
//    var notifications : [Notification] = [Notification]()
//    
//    init()
//    {
//        self.loadRequests()
//    }
//    
//    
//    class var sharedInstance : DAONotifications
//    {
//        return data
//    }
//    
//    
//    func getRequests() -> [Notification]
//    {
//        return self.notifications
//    }
//    
//    
//    func loadRequests()
//    {
//        var requests = [FriendRequest]()
//        let query = PFQuery(className: "FriendRequest")
//        query.whereKey("target", equalTo: DAOUser.sharedInstance.getUserName())
//        query.whereKey("status", equalTo: "Pendente")
//        query.findObjectsInBackgroundWithBlock { ( objects:[AnyObject]?, error: NSError?) -> Void in
//            if let objects = objects as? [PFObject]
//            {
//                print("objetos retornados em requests: \(objects.count)")
//                for object in objects
//                {
//                    requests.append(FriendRequest(sender: object.valueForKey("sender") as! String, target: DAOUser.sharedInstance.getUserName()))
//                    
//                    if(object == objects.last)
//                    {
//                        self.notifications = requests
//                        print("notificacoes carregadas")
//                        NSNotificationCenter.defaultCenter().postNotificationName(requestNotification.requestsLoaded.rawValue, object: nil)
//                    }
//                }
//            }
//            self.notifications = requests
//        }
//        self.notifications = requests
//    }
//    
//    
//    func acceptRequest(request: FriendRequest)
//    {
//        let query = PFQuery(className: "FriendRequest")
//        query.whereKey("sender", equalTo: request.sender)
//        query.whereKey("target", equalTo: DAOUser.sharedInstance.getUserName())
//        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
//            
//            if let objects = objects as? [PFObject]
//            {
//                for object in objects
//                {
//                    object.setValue("Aceito", forKey: "status")
//                    DAOContacts.addContactByUsername(request.sender)
//                    object.saveEventually()
//                }
//            }
//            
//        }
//    }
//    
//    func friendsAccepted()
//    {
//        let query = PFQuery(className: "FriendRequest")
//        query.whereKey("sender", equalTo: DAOUser.sharedInstance.getUserName())
//        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
//            
//            if let objects = objects as? [PFObject]
//            {
//                for object in objects
//                {
//                    let status = object.valueForKey("status") as! String
//                    if(status == "Aceito")
//                    {
//                        DAOContacts.addContactByUsername(object.valueForKey("target") as! String)
//                        object.deleteEventually()
//                    }
//                }
//            }
//            
//        }
//    }
//    
//    
//    func sendRequest(username: String)
//    {
//        let query = PFUser.query()
//        query?.whereKey("username", equalTo: username)
//        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
//            
//            if let objects = objects as? [PFObject]
//            {
//                if objects.count > 0
//                {
//                    let request = PFObject(className: "FriendRequest")
//                    request["sender"] = DAOUser.sharedInstance.getUserName()
//                    request["target"] = username
//                    request["status"] = "Pendente"
//                    request.saveEventually()
//                }
//            }
//            
//        })
//    }
//    
//    
//    
//    
//}
//
