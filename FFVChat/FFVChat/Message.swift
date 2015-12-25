//
//  Message.swift
//  FFVChat
//
//  Created by Filipo Negrao on 01/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData


enum ContentType : String
{
    case Image = "Image"
    
    case Audio = "Audio"
    
    case Gif = "Gif"
    
    case Text = "Text"
}

class Message: NSManagedObject
{
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext,id: String, sender: String, target: String, sentDate: NSDate, lifeTime: Int, type: ContentType, contentKey: String?, text: String?, status: String) -> Message
    {
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: moc) as! Message
        
        message.sender = sender
        message.target = target
        message.sentDate = sentDate
        message.lifeTime = lifeTime
        message.type = type.rawValue
        message.text = text
        message.contentKey = contentKey
        message.status = status
        message.id = id
        
        return message
    }

}






