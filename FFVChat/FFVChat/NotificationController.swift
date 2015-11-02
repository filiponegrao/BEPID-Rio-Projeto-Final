//
//  NotificationController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 31/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit
import Foundation

private let data : NotificationController = NotificationController()

class NotificationController: NSObject
{
    var friendRequest : NSNotification!
    
    var requestAccepted : NSNotification!
    
    var messageReceived : NSNotification!
    
    var messageSent : NSNotification!
    
    var messageNotSent : NSNotification!
    
    var friendAdded : NSNotification!
    
    var friendRequested : NSNotification!
    
    override init()
    {
        self.friendRequest = NSNotification(name: "friendRequest", object: NSMutableDictionary())
        self.requestAccepted = NSNotification(name: "requestAccepted", object: nil)
        self.messageReceived = NSNotification(name: "messageReceived", object: nil)
        self.messageSent = NSNotification(name: "messageSent", object: nil)
        self.messageNotSent = NSNotification(name: "messageNotSent", object: nil)
        self.friendAdded = NSNotification(name: "friendAdded", object: nil)
        self.friendRequested = NSNotification(name: "friendRequested", object: nil)
    }
    
    class var center : NotificationController
    {
        return data
    }
    

}

public enum appNotification : String
{
    case friendRequest
    
    case requestAccepted
    
    case messageReceived
}


