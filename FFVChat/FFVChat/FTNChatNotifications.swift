//
//  FTNChatNotifications.swift
//  FFVChat
//
//  Created by Filipo Negrao on 11/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit


class FTNChatNotifications
{
    class func newMessage() -> String
    {
        return "newMessage"
    }
    
    class func messageErased() -> String
    {
        return "messageErased"
    }
    
    class func messageSent(id: String) -> String
    {
        return "messageSent_\(id)"
    }
    
    class func messageRead(id: String) -> String
    {
        return "messageRead_\(id)"
    }
    
    class func messageReady(id: String) -> String
    {
        return "messageReady_\(id)"
    }
    
    class func messageSendError(id: String) -> String
    {
        return "messageSendError_\(id)"
    }
    
    class func imageLoaded() -> String
    {
        return "imageLoaded"
    }
    
    class func audioLoaded() -> String
    {
        return "audioLoaded"
    }
    
    class func gifLoaded() -> String
    {
        return "gifLoaded"
    }
    
}