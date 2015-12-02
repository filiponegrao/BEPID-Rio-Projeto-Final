//
//  DAOMessages.swift
//  FFVChat
//
//  Created by Filipo Negrao on 23/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit
import CoreData

private let data = DAOMessages()


class DAOMessages : NSObject
{
    var currentMessage : Message?
    
    var lastMessage : Message!
    
    var inExecution: Bool = false
    
    var delayForPush : NSTimer!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override init()
    {
        super.init()
        self.currentMessage = nil
    }
    
    class var sharedInstance : DAOMessages
    {
        return data
    }
    
    
    func sendMessage(username: String, text: String) -> Message
    {
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: NSDate(), lifeTime: 900, type: .Text, contentKey: nil, text: text, image: nil, filter: nil, audio: nil, gif: nil, status: "sent")
        
        self.save()
        
        DAOPostgres.sharedInstance.sendTextMessage(EncryptTools.encUsername(username), lifeTime: 900, text: EncryptTools.enc(text, contact: username))
        
        self.delayForPush?.invalidate()
        self.delayForPush = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "sendTextPushNotification:", userInfo: ["username":username, "text":text], repeats: false)
        
        return message
    }
    
    func sendMessage(username: String, image: UIImage, lifeTime: Int, filter: ImageFilter) -> Message
    {
        let data = NSString(string: "\(NSDate())").substringWithRange(NSMakeRange(0, 19))
        let keyWithSpaces = "\(DAOUser.sharedInstance.getUsername())\(username)\(data)"
        var key = EncryptTools.removeWhiteSpaces(keyWithSpaces)
        key = EncryptTools.encKey(key)
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: NSDate(), lifeTime: lifeTime, type: .Image, contentKey: key, text: nil, image: image.mediumQualityJPEGNSData, filter: filter, audio: nil, gif: nil, status: "sent")
        
        DAOPostgres.sharedInstance.sendImageMessage(EncryptTools.encUsername(username), lifeTime: lifeTime, imageKey: key, image: image, filter: filter)
        
        DAOParse.sendImageOnKey(key, image: EncryptTools.encImage(image.mediumQualityJPEGNSData, target: username))
        
        DAOParse.pushImageNotification(username)
        
        DAOSentMidia.sharedInstance.addSentMidia(message)
        
        return message
    }
    
    
    func sendTextPushNotification(timer: NSTimer)
    {
        let info  = timer.userInfo!
        let username = info["username"] as! String
        let text = info["text"] as! String
        
        DAOParse.pushMessageNotification(username, text: text)
    }
    
    
    func addReceivedMessage(sender: String, text: String, sentDate: NSDate, lifeTime: Int) -> Bool
    {
        let decSender = EncryptTools.getUsernameFromEncrpted(sender)
        let decText = EncryptTools.dec(text)
        
        if(decSender == nil)
        {
            return false
        }
        
        //Tratamento de excessao
        let query = NSFetchRequest(entityName: "Message")
        let predicate = NSPredicate(format: "sender == %@ AND target == %@ AND sentDate == %@", decSender!, DAOUser.sharedInstance.getUsername(), sentDate)
        query.predicate = predicate
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            if(results.count > 0)
            {
                return false
            }
        }
        catch {}
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: decSender!, target: DAOUser.sharedInstance.getUsername(), sentDate: sentDate, lifeTime: lifeTime, type: .Text, contentKey: nil, text: decText, image: nil, filter: nil, audio: nil, gif: nil, status: "received")
        
        self.lastMessage = message
        
        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.messageReceived)
        
        self.save()
        return true
    }
    
    func addReceivedMessage(sender: String, contentKey: String, sentDate: NSDate, lifeTime: Int, filter: ImageFilter) -> Bool
    {
        let decSender = EncryptTools.getUsernameFromEncrpted(sender)
        
        if(decSender == nil)
        {
            return false
        }
        //Tratamento de excessao
        let query = NSFetchRequest(entityName: "Message")
        let predicate = NSPredicate(format: "sender == %@ AND target == %@ AND sentDate == %@", decSender!, DAOUser.sharedInstance.getUsername(), sentDate)
        query.predicate = predicate
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            if(results.count > 0)
            {
                return false
            }
        }
        catch {}
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: decSender!, target: DAOUser.sharedInstance.getUsername(), sentDate: sentDate, lifeTime: lifeTime, type: .Image, contentKey: contentKey, text: nil, image: nil, filter: filter, audio: nil, gif: nil, status: "received")
        
        DAOParse.sharedInstance.downloadImageForMessage(message)
        self.lastMessage = message
        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.messageReceived)
        
        self.save()
        return true
    }
    
    
    func setMessageSeen(message: Message)
    {
        DAOPostgres.sharedInstance.setMessageSeen(message)
        
        message.status = "seen"
        self.save()
    }
    
    
    func setMessageDeleted(message: Message)
    {
        
    }
    
    
    func contactMessageExist(message: Message) -> Bool
    {
        let pred1 = NSPredicate(format: "sender == %@", message.sender)
        let pred2 = NSPredicate(format: "target == %@", message.target)
        let pred3 = NSPredicate(format: "sentDate == %@", message.sentDate)
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pred1, pred2, pred3])
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        fetchRequest.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Message]
            if(results.count > 0)
            {
                return true
            }
            else
            {
                return false
            }
        }
        catch
        {
            return false
        }
    }
    
    
    func deleteMessage(message: Message)
    {
        let predicate = NSPredicate(format: "sentDate == %@ AND target == %@ AND sender == %@",message.sentDate,message.target,message.sender)
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Message]
            if let entityToDelete = fetchedEntities.first
            {
                DAOPostgres.sharedInstance.setDeletedMessage(message)
                self.managedObjectContext.deleteObject(entityToDelete)
            }
        }
        catch
        {
            // Do something in response to error condition
        }
        
        self.save()
    }
    
    func clearConversation(username: String)
    {
        let messages = self.conversationWithContact(username)
        
        for message in messages
        {
            self.deleteMessage(message)
        }
    }
    
    
    func conversationWithContact(contact: String) -> [Message]
    {
        var messages = [Message]()
        
        let pred1 = NSPredicate(format: "sender == %@ OR target == %@", contact, contact)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pred1])
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sentDate", ascending: true)]
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Message]
            messages = results
        }
        catch
        {
            return messages
        }
        return messages
    }
    
    
    func deleteMessageAfterTime(message: Message)
    {
        if(message.status != "seen")
        {
            self.setMessageSeen(message)
            message.status = "seen"
            self.save()
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(message.lifeTime)) * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                
                self.timesUpMessage(message)
            }
        }
    }
    
    
    
    func timesUpMessage(message: Message)
    {
        if(!self.inExecution)
        {
            self.inExecution = true
            var contact : String
            print("sender: \(message.sender)")
            print("critp: \(EncryptTools.encUsername(DAOUser.sharedInstance.getUsername()))")
            if (message.sender == EncryptTools.encUsername(DAOUser.sharedInstance.getUsername()))
            {
                contact = message.target
            }
            else
            {
                contact = message.sender
            }
            
            let messages = self.conversationWithContact(contact)
            let index = messages.indexOf(message)
            self.deleteMessage(message)
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "messageEvaporated", object: nil, userInfo: ["index":index!]))
            self.inExecution = false
        }
        else
        {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(0.5)) * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.timesUpMessage(message)
            }
        }
    }
    
    
    func numberOfUnreadMessages(contact: Contact) -> Int
    {
        var unread = 0
        
        let messages = self.conversationWithContact(contact.username)
        
        for message in messages
        {
            if message.status == "received"
            {
                unread++
            }
        }
        
        return unread
    }
    
    
    //    func receiveMessagesFromContact()
    //    {
    //        DAOParse.checkForContactsMessage()
    //    }
    
    
    func setImageForMessage(message: Message, image: NSData)
    {
        message.image = image
        self.save()
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "imageLoaded", object: nil, userInfo: ["messageKey" : message.contentKey!]))
    }
    
    func save()
    {
        do { try self.managedObjectContext.save() }
        catch let error
        {
            print(error)
        }
    }
    
}

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate: Comparable { }


