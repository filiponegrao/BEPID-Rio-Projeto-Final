//
//  DAONotifications.swift
//  FFVChat
//
//  Created by Filipo Negrao on 07/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Parse


enum appNotification : String
{
    case friendRequest
    
    case requestAccepted
    
    case messageReceived
    
    case messageReady
    
    case messageSent
    
    case trustLevelChanged
}


class Notification
{
    let text : String
    
    init(text: String)
    {
        self.text = text
    }
}


private let data = DAONotifications()


class DAONotifications
{
    
    
    
    
}

