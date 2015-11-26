//
//  Message.swift
//  FFVChat
//
//  Created by Filipo Negrao on 18/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData


class Message: NSManagedObject {

    class func createInManagedObjectContext(moc: NSManagedObjectContext, sender: String, target: String, text: String?, imageKey: String?, image: NSData?, sentDate: NSDate, lifeTime: Int, status: String) -> Message
    {
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: moc) as! Message
        message.sender = sender
        message.target = target
        message.text = text
        message.imageKey = imageKey
        message.image = image
        message.sentDate = sentDate
        message.lifeTime = lifeTime
        message.status = status
        
        return message
    }
}
