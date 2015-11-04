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
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: DAOUser.sharedInstance.getUserName(), target: username, text: text, image: nil, sentDate: NSDate(), lifeTime: 86400)
        self.save()
        
        DAOParse.sendMessage(username, text: text, lifeTime: 86400)
        //Notificacao deve ser enviada so quando a mensagem estiver no banco
//        DAOParse.pushMessageNotification(username, text: "Mensagem de \(DAOUser.sharedInstance.getUserName())")
        
        return message
    }
    
    func sendMessage(username: String, image: UIImage, lifeTime: Int) -> Message
    {
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: DAOUser.sharedInstance.getUserName(), target: username, text: nil, image: image.lowQualityJPEGNSData, sentDate: NSDate(), lifeTime: lifeTime)
        self.save()
        
        DAOParse.sendMessage(username, image: image, lifeTime: 60)
        //Notificacao so deve chegar quando a imagem for salva no banco
        //DAOParse.pushImageNotification(username)
        DAOSentMidia.sharedInstance.addSentMidia(message)
        
        return message
    }
    
    
    func addReceivedMessage(sender: String, text: String, sentDate: NSDate, lifeTime: Int)
    {
        //Tratamento de excessao
        let query = NSFetchRequest(entityName: "Message")
        let predicate = NSPredicate(format: "sender == %@ AND target == %@ AND sentDate == %@", sender, DAOUser.sharedInstance.getUserName(), sentDate)
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
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: sender, target: DAOUser.sharedInstance.getUserName(), text: text, image: nil, sentDate: sentDate, lifeTime: lifeTime)
        
        self.lastMessage = message
        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.messageReceived)
        
        self.save()
    }
    
    func addReceivedMessage(sender: String, image: NSData, sentDate: NSDate, lifeTime: Int)
    {
        //Tratamento de excessao
        let query = NSFetchRequest(entityName: "Message")
        let predicate = NSPredicate(format: "sender == %@ AND target == %@ AND sentDate == %@", sender, DAOUser.sharedInstance.getUserName(), sentDate)
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
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: sender, target: DAOUser.sharedInstance.getUserName(), text: nil, image: image, sentDate: sentDate, lifeTime: lifeTime)
        
        self.lastMessage = message
        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.messageReceived)
        
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
        
        do {
            try self.managedObjectContext.save()
        } catch {
            // Do something in response to error condition
        }
    }
    
    func clearConversation(username: String)
    {
        
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
    
    func receiveMessagesFromContact()
    {
        DAOParse.checkForContactsMessage()
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


