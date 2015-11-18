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


class DAOMessages
{
    var currentMessage : Message?
    
    var lastMessage : Message!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    init()
    {
        self.currentMessage = nil
    }
    
    class var sharedInstance : DAOMessages
    {
        return data
    }
    
    
    func sendMessage(username: String, text: String) -> Message
    {
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: DAOUser.sharedInstance.getUsername(), target: username, text: text, imageKey: nil, image: nil, sentDate: NSDate(), lifeTime: 14400, status: "sent")
        self.save()
        
        print("enviando")
        DAOPostgres.sharedInstance.sendTextMessage(username, lifeTime: 34000, text: text)
        
        return message
    }
    
    func sendMessage(username: String, image: UIImage, lifeTime: Int) -> Message
    {
        let data = NSString(string: "\(NSDate())").substringWithRange(NSMakeRange(0, 19))
        let key = "\(DAOUser.sharedInstance.getUsername())\(username)\(data)"
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: DAOUser.sharedInstance.getUsername(), target: username, text: nil, imageKey: key, image: image.lowQualityJPEGNSData, sentDate: NSDate(), lifeTime: lifeTime, status: "sent")
        self.save()
        
//        DAOParse.sendMessage(username, image: image, lifeTime: lifeTime)

        DAOPostgres.sharedInstance.sendImageMessage(username, lifeTime: lifeTime, imageKey: key, image: image)
        DAOSentMidia.sharedInstance.addSentMidia(message)
        
        return message
    }
    
    
    func addReceivedMessage(sender: String, text: String, sentDate: NSDate, lifeTime: Int)
    {
        //Tratamento de excessao
        let query = NSFetchRequest(entityName: "Message")
        let predicate = NSPredicate(format: "sender == %@ AND target == %@ AND sentDate == %@", sender, DAOUser.sharedInstance.getUsername(), sentDate)
        query.predicate = predicate
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            if(results.count > 0)
            {
                return
            }
        }
        catch {}
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: sender, target: DAOUser.sharedInstance.getUsername(), text: text, imageKey: nil ,image: nil, sentDate: sentDate, lifeTime: lifeTime, status: "receveid")
        
        self.lastMessage = message

        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.messageReceived)
        
        self.save()
    }
    
    func addReceivedMessage(sender: String, imageKey: String, sentDate: NSDate, lifeTime: Int)
    {
        //Tratamento de excessao
        let query = NSFetchRequest(entityName: "Message")
        let predicate = NSPredicate(format: "sender == %@ AND target == %@ AND sentDate == %@", sender, DAOUser.sharedInstance.getUsername(), sentDate)
        query.predicate = predicate
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            if(results.count > 0)
            {
                return
            }
        }
        catch {}
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: sender, target: DAOUser.sharedInstance.getUsername(), text: nil, imageKey: imageKey ,image: nil, sentDate: sentDate, lifeTime: lifeTime, status: "received")
        DAOParse.uploadImageForMessage(message)
        self.lastMessage = message
        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.messageReceived)
        
        self.save()
    }
    
    
    func setMessageSeen(message: Message)
    {
        message.status = "seen"
        self.save()
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
            if let entityToDelete = fetchedEntities.first {
                self.managedObjectContext.deleteObject(entityToDelete)
            }
        } catch {
            // Do something in response to error condition
        }
        
        self.save()
    }
    
    func clearConversation(username: String)
    {
        let predicate = NSPredicate(format: "sender == %@ OR target == %@", username,username)
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Message]
            
            for entity in fetchedEntities {
                self.managedObjectContext.deleteObject(entity)
            }
        } catch {
            // Do something in response to error condition
        }
        
        self.save()
    }
    
    
    func conversationWithContact(contact: String) -> [Message]
    {
        var messages = [Message]()
        
        let pred1 = NSPredicate(format: "sender == %@ OR target == %@", contact, contact)
//        let pred2 = NSPredicate(format: "target == %@", contact)
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
            message.status = "seen"
            self.save()
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(message.lifeTime)) * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                var contact : String
                if (message.sender == DAOUser.sharedInstance.getUsername())
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
            }
        }
    }
    
//    func receiveMessagesFromContact()
//    {
//        DAOParse.checkForContactsMessage()
//    }
    
    
    func setImageForMessage(message: Message, image: NSData)
    {
        message.image = image
        self.save()
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


