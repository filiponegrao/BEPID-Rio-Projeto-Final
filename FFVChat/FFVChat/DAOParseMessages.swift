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
            query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if let objects = objects as? [PFObject]
                {
                    if let object = objects.first
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
                    callback(ret: messageCondRet.userNotFound)
                }
                callback(ret: messageCondRet.userNotFound)
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
            query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if let objects = objects as? [PFObject]
                {
                    if let object = objects.first
                    {
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
                                self.addSelfMessage(Message(sender: user!.username!, target: username, date: NSDate(), image: image))
                                self.pushImageNotification(username)
                                callback(ret: messageCondRet.success)
                            }
                            else
                            {
                                callback(ret: messageCondRet.unknowError)
                            }
                        })
                    }
                    callback(ret: messageCondRet.userNotFound)
                }
                callback(ret: messageCondRet.userNotFound)
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
            "alert": text, "badge": 1, "do": appNotification.messageReceived.rawValue, "sender" : DAOUser.sharedInstance.getUserName()]
        
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
            
        }
        else
        {
            let myMessages = conversation!.objectForKey(self.myMessagesKey) as? NSMutableArray
            
            if(myMessages == nil)
            {
                let newSelfMesages = NSMutableArray(object: msgm)
                conversation!.setObject(newSelfMesages, forKey: self.myMessagesKey)
                content!.setObject(conversation!, forKey: message.target)
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
                }
                else
                {
                    myMessages!.addObject(msgm)
                }
                conversation!.setObject(myMessages!, forKey: self.myMessagesKey)
                content!.setObject(conversation!, forKey: message.target)
                content!.writeToFile(path, atomically: false)
            }
            
        }
    }
    
    
    func addContactMessage(message: Message)
    {
        let localpath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = localpath.stringByAppendingPathComponent("Messages") as String
        
        let content = NSMutableDictionary(contentsOfFile: path)
        
        let conversation = content!.objectForKey(message.sender) as? NSMutableDictionary
        
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
                    for(var i = 0; i < 10; i++)
                    {
                        contactMessages![i] = contactMessages![i+1]
                    }
                    contactMessages![10] = msgm
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
    
    
    func checkForContactMessages(username: String)
    {
        let userQuery = PFUser.query()
        userQuery?.whereKey("username", equalTo: username)
        
        let query = PFQuery(className: "Message")
        query.whereKey("sender", matchesQuery: userQuery!)
        query.whereKey("received", equalTo: false)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    print("passa aqui")
                    let target = object.valueForKey("target") as! PFUser
                    let date = object.valueForKey("createdAt") as! NSDate
                    let text = object.valueForKey("text") as? String
                    print(target.username!)
                    print(date)
                    print(text)
                    if(text == nil)
                    {
                        let data = object.objectForKey("image") as! PFFile
                        data.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                            
                            if(data != nil)
                            {
                                let message = Message(sender: username, target: target.username!, date: date, image: UIImage(data: data!)!)
                                self.addContactMessage(message)
                            }
                            object["received"] = true
                            object.saveEventually()
                        
                        })
                        
                    }
                    else
                    {
                        
                        let message = Message(sender: username, target: target.username!, date: date, text: text)
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
    
    
    
    func getMessages(withContactUsername: String) -> [Message]
    {
        var messages = [Message]()
        
        let localpath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = localpath.stringByAppendingPathComponent("Messages.plist") as String
        
        let contents = NSMutableDictionary(contentsOfFile: path)
        
        let conversation = contents!.objectForKey(withContactUsername) as? NSMutableDictionary
        
        if(conversation == nil)
        {
            print("nao achou foi nada")
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
        
        print("ta retornando essas mensagens: \(messages)")
        return messages
        
    }
    
}




