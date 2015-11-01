//
//  Message.swift
//  FFVChat
//
//  Created by Filipo Negrao on 31/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData


class Message: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, sender: String, target: String, text: String?, image: NSData?, sentDate: NSDate, lifeTime: Int) -> Message
    {
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: moc) as! Message
        message.sender = sender
        message.target = target
        message.text = text
        message.image = image
        message.sentDate = sentDate
        message.lifeTime = lifeTime
        
        return message
    }

}
