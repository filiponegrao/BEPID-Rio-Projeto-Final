//
//  DAOMessages.swift
//  FFVChat
//
//  Created by Filipo Negrao on 23/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

private let data = DAOMessages()


class DAOMessages
{
    
    let myMessagesKey = "myMessages"
    let contactMessagesKey = "contactMessages"
    
    init()
    {
        self.createFolder()
    }
    
    class var sharedInstance : DAOMessages
    {
        return data
    }
    
    func createFolder()
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Messages.plist") as String
        let fileManager = NSFileManager.defaultManager()
        
        //check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("Messages", ofType: "plist")
            {
                //                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                do { try fileManager.copyItemAtPath(bundlePath, toPath: path) }
                catch
                {
                    print("nao foi possivel criar a pasta")
                }
            }
            else
            {
                print("Messages.plist not found. Please, make sure it is part of the bundle.")
            }
        }
        else
        {
            print("Messages.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
    }

    func sendMessage(username: String, text: String)
    {
        DAOParse.sendMessage(username, text: text) { (success, theMessage) -> Void in
            
            if(success)
            {
                self.addSelfMessage(theMessage!)
            }
        }
    }
    
    func sendMessage(username: String, image: UIImage)
    {
        DAOParse.sendMessage(username, image: image) { (success, theMessage) -> Void in
            
            if(success)
            {
                self.addSelfMessage(theMessage!)
            }
        }
    }
    
    
    func addSelfMessage(message: Message)
    {
        let localpath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = localpath.stringByAppendingPathComponent("Messages.plist") as String
        
        let content = NSMutableDictionary(contentsOfFile: path)
        
        let conversation = content!.objectForKey(message.target)
        
        var msgm : NSDictionary!
        //É Texto
        if(message.image == nil)
        {
            msgm = ["type" : "text", "sender" : message.sender, "target" : message.target, "date" : message.date, "text" : message.text!]
        }
            // Image
        else
        {
            msgm = ["type" : "image", "sender" : message.sender, "target" : message.target, "date" : message.date, "image" : message.image!.highestQualityJPEGNSData]
        }
        
        if(conversation == nil)
        {
            
            let myMessages = NSMutableArray(object: msgm)
            
            let newConversation = NSMutableDictionary()
            newConversation.setObject(myMessages, forKey: self.myMessagesKey)
            
            content!.setObject(newConversation, forKey: message.target)
            content!.writeToFile(path, atomically: true)
            NSNotificationCenter.defaultCenter().postNotificationName(appNotification.messageSent.rawValue, object: nil)
        }
        else
        {
            let myMessages = conversation!.objectForKey(self.myMessagesKey) as? NSMutableArray
            
            if(myMessages == nil)
            {
                let newSelfMesages = NSMutableArray(object: msgm)
                conversation!.setObject(newSelfMesages, forKey: self.myMessagesKey)
                content!.setObject(conversation!, forKey: message.target)
                content?.writeToFile(path, atomically: false)
                NSNotificationCenter.defaultCenter().postNotificationName(appNotification.messageSent.rawValue, object: nil)
            }
            else
            {
                if(myMessages!.count >= 10)
                {
                    for(var i = 0; i < 9; i++)
                    {
                        myMessages![i] = myMessages![i+1]
                    }
                    myMessages!.replaceObjectAtIndex(9, withObject: msgm)
                    NSNotificationCenter.defaultCenter().postNotificationName(appNotification.messageSent.rawValue, object: nil)
                }
                else
                {
                    myMessages!.addObject(msgm)
                }
                conversation!.setObject(myMessages!, forKey: self.myMessagesKey)
                content!.setObject(conversation!, forKey: message.target)
                content!.writeToFile(path, atomically: false)
                NSNotificationCenter.defaultCenter().postNotificationName(appNotification.messageSent.rawValue, object: nil)
            }
            
        }
    }
    
    
    func addContactMessage(message: Message)
    {
        let localpath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = localpath.stringByAppendingPathComponent("Messages.plist") as String
        
        let content = NSMutableDictionary(contentsOfFile: path)
        
        let conversation = content!.objectForKey(message.sender) as? NSMutableDictionary
        
        var msgm : NSDictionary!
        
        if(self.contactMessageExist(message))
        {
            return
        }
        
        //É Texto
        if(message.image == nil)
        {
            msgm = ["type" : "text", "sender" : message.sender, "target" : message.target, "date" : message.date, "text" : message.text!]
        }
            // Image
        else
        {
            msgm = ["type" : "image", "sender" : message.sender, "target" : message.target, "date" : message.date, "image" : message.image!.highestQualityJPEGNSData]
        }
        
        if(conversation == nil)
        {
            let contactMessages = NSMutableArray(object: msgm)
            
            let newConversation = NSMutableDictionary()
            newConversation.setObject(contactMessages, forKey: self.contactMessagesKey)
            
            content!.setObject(newConversation, forKey: message.sender)
            content!.writeToFile(path, atomically: false)
            NSNotificationCenter.defaultCenter().postNotificationName(appNotification.messageReady.rawValue, object: nil)
            
        }
        else
        {
            let contactMessages = conversation?.objectForKey(self.contactMessagesKey) as? NSMutableArray
            
            if(contactMessages == nil)
            {
                let newContactMessages = NSMutableArray(object: msgm)
                conversation!.setObject(newContactMessages, forKey: self.contactMessagesKey)
                content!.setObject(conversation!, forKey: message.sender)
                content!.writeToFile(path, atomically: false)
                NSNotificationCenter.defaultCenter().postNotificationName(appNotification.messageReady.rawValue, object: nil)
                
            }
            else
            {
                if(contactMessages!.count >= 10)
                {
                    for(var i = 0; i < 9; i++)
                    {
                        contactMessages![i] = contactMessages![i+1]
                    }
                    contactMessages!.replaceObjectAtIndex(9, withObject: msgm)
                }
                else
                {
                    contactMessages!.addObject(msgm)
                }
                conversation!.setObject(contactMessages!, forKey: self.contactMessagesKey)
                content?.setObject(conversation!, forKey: message.sender)
                content?.writeToFile(path, atomically: false)
                NSNotificationCenter.defaultCenter().postNotificationName(appNotification.messageReady.rawValue, object: nil)
                
            }
        }
    }
    
    
    func contactMessageExist(contactMessage: Message) -> Bool
    {
        let messages = self.getMessages(contactMessage.sender)
        
        for message in messages
        {
            if(contactMessage.date == message.date)
            {
                return true
            }
        }
        
        return false
    }
    
    
    func deleteMessage(message: Message)
    {
        let localpath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = localpath.stringByAppendingPathComponent("Messages.plist") as String
        
        let content = NSMutableDictionary(contentsOfFile: path)
        
        let conversation = content?.objectForKey(message.target) as? NSMutableDictionary
        
        if(conversation == nil)
        {
            return
        }
        else
        {
            let myMessages = conversation?.objectForKey(self.myMessagesKey) as? NSMutableArray
            if(myMessages == nil)
            {
                return
            }
            else
            {
                for(var i = 0; i < myMessages?.count ; i++)
                {
                    if(((myMessages?.objectAtIndex(i) as! NSDictionary).valueForKey("date") as! NSDate) == message.date)
                    {
                        myMessages?.removeObjectAtIndex(i)
                    }
                }
            }
        }
    }
    
    func clearConversation(username: String)
    {
        let localpath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = localpath.stringByAppendingPathComponent("Messages.plist") as String
        
        let contents = NSMutableDictionary(contentsOfFile: path)
        
        let conversation = contents?.objectForKey(username) as? NSMutableDictionary
        
        if(conversation == nil)
        {
            return
        }
        
        let my = conversation?.objectForKey(self.myMessagesKey) as? NSMutableArray
        my?.removeAllObjects()
        
        let contact = conversation?.objectForKey(self.contactMessagesKey) as? NSMutableArray
        contact?.removeAllObjects()
        
        contents?.writeToFile(path, atomically: false)
    }
    
    
    func getMessages(withContactUsername: String) -> [Message]
    {
        var messages = [Message]()
        
        let localpath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = localpath.stringByAppendingPathComponent("Messages.plist") as String
        
        let contents = NSMutableDictionary(contentsOfFile: path)
        
        let conversation = contents!.objectForKey(withContactUsername) as? NSMutableDictionary
        
        if(conversation == nil)
        {
            return messages
        }
        
        let myMessages = conversation!.objectForKey(self.myMessagesKey) as? NSMutableArray
        let contactMessages = conversation!.objectForKey(self.contactMessagesKey) as? NSMutableArray
        
        
        if(myMessages != nil)
        {
            for message in myMessages!
            {
                var msgm : Message!
                //É Texto
                if(message.valueForKey("type") as! String == "text")
                {
                    let sender = message.valueForKey("sender") as! String
                    let target = message.valueForKey("target") as! String
                    let date = message.valueForKey("date") as! NSDate
                    let text = message.valueForKey("text") as! String
                    
                    msgm = Message(sender: sender, target: target, date: date, text: text)
                }
                    // Image
                else
                {
                    let sender = message.valueForKey("sender") as! String
                    let target = message.valueForKey("target") as! String
                    let date = message.valueForKey("date") as! NSDate
                    let image = message.valueForKey("image") as! NSData
                    
                    msgm = Message(sender: sender, target: target, date: date, image: UIImage(data: image)!)
                }
                
                messages.append(msgm)
            }
        }
        
        if(contactMessages != nil)
        {
            for message in contactMessages!
            {
                var msgm : Message!
                //É Texto
                if(message.valueForKey("type") as! String == "text")
                {
                    let sender = message.valueForKey("sender") as! String
                    let target = message.valueForKey("target") as! String
                    let date = message.valueForKey("date") as! NSDate
                    let text = message.valueForKey("text") as! String
                    
                    msgm = Message(sender: sender, target: target, date: date, text: text)
                }
                    // Image
                else
                {
                    let sender = message.valueForKey("sender") as! String
                    let target = message.valueForKey("target") as! String
                    let date = message.valueForKey("date") as! NSDate
                    let image = message.valueForKey("image") as! NSData
                    
                    msgm = Message(sender: sender, target: target, date: date, image: UIImage(data: image)!)
                }
                
                
                messages.append(msgm)
            }
        }
        
        messages.sortInPlace({ $0.date < $1.date })
        
        return messages
        
    }
    
    func receiveMessagesFromContact(username: String)
    {
        DAOParse.checkForContactMessages(username) { (messages) -> Void in
            
            if messages.count == 0 { return }
            
            for message in messages as [Message]
            {
                self.addContactMessage(message)
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(appNotification.messageReady.rawValue, object: nil)
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


