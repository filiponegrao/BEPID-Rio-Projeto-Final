//
//  DAOParseMessages.swift
//  FFVChat
//
//  Created by Filipo Negrao on 10/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Parse

private let data = DAOParseMessages()

enum messageCondRet
{
    case userNotLogged
    
    case unknowError
    
    case userNotFound
    
    case success
}


class DAOParseMessages
{
    let myMessagesKey = "myMessages"
    let contactMessagesKey = "contactMessages"
    
    init()
    {
        self.createFolder()
    }
    
    class var sharedInstance : DAOParseMessages
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
    
    
    func sendMessage(username: String, text: String, callback: (ret: messageCondRet) -> Void) -> Void
    {
        let user = PFUser.currentUser()
        if(user != nil)
        {
            
            let query = PFUser.query()
            query?.whereKey("username", equalTo: username)
            query?.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                
                if(object != nil)
                {
                    let message = PFObject(className: "Message")
                    message["sender"] = user
                    message["target"] = object as! PFUser
                    message["text"] = text
                    message["received"] = false
                    message.saveInBackgroundWithBlock({ (success: Bool, error2: NSError?) -> Void in
                        
                        if(error == nil)
                        {
                            self.addSelfMessage(Message(sender: user!.username!, target: username, date: NSDate(), text: text))
                            self.pushMessageNotification(username, text: text)
                            callback(ret: messageCondRet.success)
                        }
                        else
                        {
                            callback(ret: messageCondRet.unknowError)
                        }
                    })
                }
                
            })
        }
        else
        {
            callback(ret: messageCondRet.userNotLogged)
        }
    }
    
    
    func sendMessage(username: String, image: UIImage, callback: (ret: messageCondRet) -> Void) -> Void
    {
        let user = PFUser.currentUser()
        if(user != nil)
        {
            let query = PFUser.query()
            query?.whereKey("username", equalTo: username)
            query?.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                
                if(object != nil)
                {
                    let msgm = Message(sender: user!.username!, target: username, date: NSDate(), image: image)
                    self.addSelfMessage(msgm)
                    
                    let data = image.highestQualityJPEGNSData
                    let picture = PFFile(data: data)
                    
                    let message = PFObject(className: "Message")
                    message["sender"] = user
                    message["target"] = object as! PFUser
                    message["image"] = picture
                    message["received"] = false
                    message.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        
                        if(error != nil)
                        {
                            self.pushImageNotification(username)
                            callback(ret: messageCondRet.success)
                        }
                        else
                        {
                            self.deleteMessage(msgm)
                            callback(ret: messageCondRet.unknowError)
                        }
                    })
                }
                
            })
        }
        else
        {
            callback(ret: messageCondRet.userNotLogged)
        }
    }
    
    func pushMessageNotification(username: String, text: String)
    {
        let data = [ "title": "Mensagem de \(DAOUser.sharedInstance.getUserName())",
            "alert": text ,"badge": 1, "do": appNotification.messageReceived.rawValue, "sender" : DAOUser.sharedInstance.getUserName()]
        
        let userQuery = PFUser.query()
        userQuery?.whereKey("username", equalTo: username)
        
        // Find devices associated with these users
        let pushQuery = PFInstallation.query()
        pushQuery!.whereKey("user", matchesQuery: userQuery!)
        
        // Send push notification to query
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        push.setData(data as [NSObject : AnyObject])
        push.sendPushInBackground()
    }
    
    func pushImageNotification(username: String)
    {
        let data = [ "title": "\(DAOUser.sharedInstance.getUserName()) Enviou-lhe uma imagem",
            "alert": "Imagem", "badge": 1, "do": appNotification.messageReceived.rawValue]
        
        let userQuery = PFUser.query()
        userQuery?.whereKey("username", equalTo: username)
        
        // Find devices associated with these users
        let pushQuery = PFInstallation.query()
        pushQuery!.whereKey("user", matchesQuery: userQuery!)
        
        // Send push notification to query
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        push.setData(data as [NSObject : AnyObject])
        push.sendPushInBackground()
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
    
    
    func checkForContactMessages(username: String)
    {
        let userQuery = PFUser.query()!
        userQuery.whereKey("username", equalTo: username)
        
        let query = PFQuery(className: "Message")
        query.whereKey("sender", matchesQuery: userQuery)
        query.whereKey("received", equalTo: false)
        query.whereKey("target", equalTo: PFUser.currentUser()!)
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            print("\(objects?.count) Mensagens nao lidas")
            
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    let date = object.valueForKey("createdAt") as! NSDate
                    let text = object.valueForKey("text") as? String
                    
                    if(text == nil)
                    {
                        let data = object.objectForKey("image") as! PFFile
                        data.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                            
                            if(data != nil)
                            {
                                print(mySelf)
                                let message = Message(sender: username, target: DAOUser.sharedInstance.getUserName(), date: date, image: UIImage(data: data!)!)
                                self.addContactMessage(message)
                            }
                            object["received"] = true
                            object.saveEventually()
                        
                        })
                        
                    }
                    else
                    {
                        
                        let message = Message(sender: username, target: DAOUser.sharedInstance.getUserName(), date: date, text: text)
                        self.addContactMessage(message)
                        object["received"] = true
                        object.saveEventually()

                    }
                }
            }
            else
            {
                print(error)
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
    
}

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate: Comparable { }



