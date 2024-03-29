//
//  DAOParse.swift
//  FFVChat
//
//  Created by Filipo Negrao on 18/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Parse
import UIKit

private let data : DAOParse = DAOParse()

class DAOParse
{
    //***************************
    //** Funcoes para contatos
    //***************************
    
    let appdelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)

    
    var tentativasDownload = 0
    
    var tentativasDowndloadAudio = 0
    
    var tentativasUpload = 0
    
    init()
    {
        
    }
    
    
    class var sharedInstance : DAOParse
    {
        return data
    }
    
    class func getContactInfoFromParse(username: String, callback: (contactInfo: NSDictionary, error: NSError?) -> Void) -> Void
    {
        let info = NSMutableDictionary()
        
        let query = PFUser.query()!
        query.whereKey("username", equalTo: username)
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            
            if(object != nil)
            {
                let photo = object?.objectForKey("profileImage") as! PFFile
                photo.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                    
                    let createdAt = object!.valueForKey("createdAt") as! NSDate
                    let trustLevel = object!.valueForKey("trustLevel") as! Int
                    let facebookId = object!.valueForKey("facebookID") as? String
                    
                    info["username"] = username
                    info["createdAt"] = createdAt
                    info["trustLevel"] = trustLevel
                    
                    if(data != nil)
                    {
                        info["profileImage"] = data
                    }
                    if(facebookId != nil)
                    {
                        info["facebookId"] = facebookId
                    }
                    
                    callback(contactInfo: info, error: nil)
                })
            }
            else
            {
                callback(contactInfo: NSDictionary(), error: error)
            }
            
        }
    }
    
    class func getContactInfoFromParse(facebookId facebookId: String, callback: (contactInfo: NSDictionary?, error: NSError?) -> Void) -> Void
    {
        let info = NSMutableDictionary()
        
        let query = PFUser.query()!
        query.whereKey("facebookID", equalTo: facebookId)
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            
            if(object != nil)
            {
                let photo = object?.objectForKey("profileImage") as! PFFile
                photo.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                    
                    let username = object!.valueForKey("username") as! String
                    let createdAt = object!.valueForKey("createdAt") as! NSDate
                    let trustLevel = object!.valueForKey("trustLevel") as! Int
                    
                    info["username"] = username
                    info["createdAt"] = createdAt
                    info["trustLevel"] = trustLevel
                    info["facebookId"] = facebookId
                    
                    if(data != nil)
                    {
                        info["profileImage"] = data
                    }
                    
                    callback(contactInfo: info, error: nil)
                })
            }
            else
            {
                callback(contactInfo: nil, error: error)
            }
        }
    }
    
    class func getFacebookProfilePicture(facebookID: String, callback : (UIImage?) -> Void) -> Void {
        
        let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
        
        let URLRequest = NSURL(string: pictureURL)
        let URLRequestNeeded = NSURLRequest(URL: URLRequest!)
        
        NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse? ,data: NSData?, error: NSError?) -> Void in
            if error == nil
            {
                let image = UIImage(data: data!)
                callback(image)
                
            }
            else
            {
                print("erro ao carregar imagem de um contato")
                callback(nil)
            }
        })
    }
    
    
    class func getUsernameFromFacebookID(id: String, callback : (String)? -> Void) -> Void
    {
        let query = PFUser.query()
        query?.whereKey("facebookID", equalTo: id)
        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if(objects?.count > 0)
            {
                let object = objects![0] as! PFObject
                callback(object.valueForKey("username") as? String)
            }
        })
        
        callback(nil)
    }
    
    
    class func getUsersWithString(string: String, callback: (result: [metaContact]) -> Void) -> Void
    {
        var result = [metaContact]()
        
        let query = PFUser.query()
        query?.whereKey("username", containsString: string)
        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    let username = object.valueForKey("username") as! String
                    if(!DAOContacts.sharedInstance.isContact(username) && username != DAOUser.sharedInstance.getUsername())
                    {
                        let id = object.valueForKey("facebookID") as? String
                        let photo = object.objectForKey("profileImage") as! PFFile
                        
                        photo.getDataInBackgroundWithBlock({ (data: NSData?, error2: NSError?) -> Void in
                            
                            if(data != nil)
                            {
                                let mc = metaContact(username: username, facebookId: id, photo: UIImage(data: data!)!)
                                result.append(mc)
                                
                                if(object == objects.last)
                                {
                                    callback(result: result)
                                }
                            }
                            
                        })
                    }
                }
            }
            else
            {
                callback(result: result)
            }
        })
    }
    
    
    class func getPhotoFromUsername(username: String, callback: (image: UIImage?) -> Void) -> Void
    {
        let query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    let data = object.objectForKey("profileImage") as! PFFile
                    data.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                        
                        if(data == nil)
                        {
                            callback(image: nil)
                        }
                        else
                        {
                            let image = UIImage(data: data!)
                            callback(image: image)
                        }
                    })
                }
                callback(image: nil)
            }
            else
            {
                callback(image: nil)
            }
            
        })
    }
    
    //***************************
    //** Funcoes para contatos
    //***************************
    
//    class func getRequests(callback: (requests: [FriendRequest]) -> Void) -> Void
//    {
//        var requests = [FriendRequest]()
//        let query = PFQuery(className: "FriendRequest")
//        query.whereKey("target", equalTo: DAOUser.sharedInstance.getUsername())
//        query.whereKey("status", equalTo: "Pendente")
//        query.findObjectsInBackgroundWithBlock { ( objects:[AnyObject]?, error: NSError?) -> Void in
//            if let objects = objects as? [PFObject]
//            {
//                for object in objects
//                {
//                    requests.append(FriendRequest(sender: object.valueForKey("sender") as! String, target: DAOUser.sharedInstance.getUsername()))
//                    
//                    if(object == objects.last)
//                    {
//                        callback(requests: requests)
//                    }
//                }
//            }
//            callback(requests: requests)
//        }
//        callback(requests: requests)
//    }
    
    
    class func acceptRequestOnParse(request: FriendRequest, callback: (success: Bool, error: NSError?) -> Void) -> Void
    {
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("sender", equalTo: request.sender)
        query.whereKey("target", equalTo: DAOUser.sharedInstance.getUsername())
        query.whereKey("status", equalTo: "Pendente")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            print("Recebidos \(objects?.count) requests")
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    let sender = object.valueForKey("sender") as! String
                    
                    let query2 = PFUser.query()
                    query2?.whereKey("username", equalTo: request.sender)
                    query2?.getFirstObjectInBackgroundWithBlock({ (user: PFObject?, error: NSError?) -> Void in
                        
                        if(user != nil)
                        {
                            let facebookId = user!.valueForKey("facebookID") as? String
                            let createdAt = user!.valueForKey("createdAt") as! NSDate
                            let trustLevel = user!.valueForKey("trustLevel") as! Int
                            let photo = user!.objectForKey("profileImage") as! PFFile
                            
                            photo.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                                
                                DAOContacts.sharedInstance.addContact(sender, facebookId: facebookId, createdAt: createdAt, trustLevel: trustLevel, profileImage: data)
                                object.setValue("Aceito", forKey: "status")
                                object.saveEventually()
                                callback(success: true, error: nil)
                            })
                        }
                        
                    })
                }
            }
            else
            {
                callback(success: false, error: error_RequestInexistent)
            }
        }
        
    }
    
    
    class func updateObject(object: PFObject)
    {
        var tried = 0
        object.saveEventually({ (success: Bool, error: NSError?) -> Void in
            if(success != true)
            {
                DAOFriendRequests.sharedInstance.loadRequests()
            }
            else if(tried < 10)
            {
                tried++
                self.updateObject(object)
            }
        })
    }
    
    
    class func finalizeRequests()
    {
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("sender", equalTo: DAOUser.sharedInstance.getUsername())
        query.whereKey("status", equalTo: "Aceito")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if(objects != nil)
            {
                for object in objects!
                {
                    let target = object.valueForKey("target") as! String
                    print("Amigo \(target) aceitou a solicitacao de amizade")
                    let query2 = PFUser.query()
                    query2?.whereKey("username", equalTo: target)
                    query2?.getFirstObjectInBackgroundWithBlock({ (user: PFObject?, error: NSError?) -> Void in
                        
                        if user != nil
                        {
                            let facebookId = user?.valueForKey("facebookID") as? String
                            let createdAt = user?.valueForKey("createdAt") as! NSDate
                            let trustLevel = user?.valueForKey("trustLevel") as! Int
                            let photo = user?.objectForKey("profileImage") as! PFFile
                            photo.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                                
                                DAOContacts.sharedInstance.addContact(target, facebookId: facebookId, createdAt: createdAt, trustLevel: trustLevel, profileImage: data)
                                object.deleteEventually()
                            })
                        }
                    })
                }
            }
        }
    }
    
    
//    class func sendFriendRequest(username: String)
//    {
//        let query = PFUser.query()
//        query?.whereKey("username", equalTo: username)
//        query?.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
//            if(object != nil)
//            {
//                let query2 = PFQuery(className: "FriendRequest")
//                query2.whereKey("target", equalTo: DAOUser.sharedInstance.getUsername())
//                query2.whereKey("sender", equalTo: username)
//                query2.whereKey("status", equalTo: "Pendente")
//                query2.findObjectsInBackgroundWithBlock({ (objects2: [AnyObject]?, error2: NSError?) -> Void in
//                    
//                    if(objects2?.count > 0)
//                    {
//                        let request = FriendRequest(sender: username, target: DAOUser.sharedInstance.getUsername())
//                        self.acceptRequestOnParse(request, callback: { (success, error) -> Void in
//                            
//                            if(success)
//                            {
//                                
//                            }
//                        })
//                    }
//                    else
//                    {
//                        let request = PFObject(className: "FriendRequest")
//                        request["sender"] = DAOUser.sharedInstance.getUsername()
//                        request["target"] = username
//                        request["status"] = "Pendente"
//                        request.saveEventually({ (success : Bool, error: NSError?) -> Void in
//                            if(success == true)
//                            {
//                                print("Convite de amizade enviado para \(username)")
//                                NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.friendRequested)
//                            }
//                        })
//                    }
//                })
//            }
//        })
//    }
    
    
    class func sendPushRequestAccepted(username: String)
    {
        let gender = DAOUser.sharedInstance.getGender()
        var message : String!
        if(gender == "male")
        {
            message = "😎 \(DAOUser.sharedInstance.getUsername()) lhe aceitou como amigo"
        }
        else if(gender == "female")
        {
            message = "🙋 \(DAOUser.sharedInstance.getUsername()) lhe aceitou como amiga"
        }
        else
        {
            message = "🤗 \(DAOUser.sharedInstance.getUsername()) lhe aceitou como amigo(a)"
        }

        let data = [ "title": message,
            "alert": message, "badge": 1, "do": appNotification.requestAccepted.rawValue, "content-avaliable" : 1]
        
        print("enviando notificacao")
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
    
    
    class func sendPushFriendRequest(username: String)
    {
        let gender = DAOUser.sharedInstance.getGender()
        var message : String!
        if(gender == "male")
        {
            message = "😎 \(DAOUser.sharedInstance.getUsername()) quer lhe adicionar como um contato"
        }
        else if(gender == "female")
        {
            message = "🙋 \(DAOUser.sharedInstance.getUsername()) quer lhe adicionar como um contato"
        }
        else
        {
            message = "🤗 \(DAOUser.sharedInstance.getUsername()) quer lhe adicionar como um contato"
        }
        
        let data = [ "title": message, "alert": message, "badge": 1, "do": appNotification.friendRequest.rawValue, "content-avaliable" : 1]
        
        print("enviando notificacao")
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
    
    
    class func checkUserAlreadyRequested(username: String, callback: (was: Bool) -> Void) -> Void
    {
        let query = PFQuery(className: "FriendRequest")
        query.whereKey("sender", equalTo: DAOUser.sharedInstance.getUsername())
        query.whereKey("target", equalTo: username)
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            
            if(object != nil)
            {
                callback(was: false)
            }
            else
            {
                callback(was: true)
            }
        }
    }
    
    
    class func decreaseTrustLevel()
    {
        if(PFUser.currentUser() != nil)
        {
            let tl = (PFUser.currentUser()!["trustLevel"] as! Int) - 1
            PFUser.currentUser()!["trustLevel"] = tl
            PFUser.currentUser()?.saveEventually()
        }
    }
    
    class func getTrustLevel(username: String, callback: (trustLevel : Int?) -> Void) -> Void
    {
        let query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        query?.getFirstObjectInBackgroundWithBlock({ (user: PFObject?, error: NSError?) -> Void in
            
            if(user != nil)
            {
                let tl = user!["trustLevel"] as! Int
                callback(trustLevel: tl)
            }
            else
            {
                callback(trustLevel: nil)
            }
            
        })
    }
    
    class func getUsernameFromFacebookId(facebookId: String, callback: (username: String?) -> Void) -> Void
    {
        let query = PFUser.query()
        query?.whereKey("facebookID", equalTo: facebookId)
        query?.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
            
            if(object != nil)
            {
                callback(username: object?.valueForKey("username") as? String)
            }
            else
            {
                callback(username: nil)
            }
        })
    }
    
    //***************************
    //** Funcoes para MENSAGEM
    //***************************
    class func sendMessage(username: String, text: String, lifeTime: Int)
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
                    message["lifeTime"] = lifeTime
                    message.saveInBackgroundWithBlock({ (success: Bool, error2: NSError?) -> Void in
                        if(success)
                        {
                            self.pushMessageNotification(username, text: text)
                        }
                        else
                        {
                        }
                        
                    })
                }
                else
                {
                }
                
            })
        }
        else
        {
            
        }
    }
    
    class func sendMessage(username: String, image: UIImage, lifeTime: Int)
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
                    message["image"] = PFFile(data: image.lowQualityJPEGNSData)
                    message["received"] = false
                    message["lifeTime"] = lifeTime
                    message.saveInBackgroundWithBlock({ (success: Bool, error2: NSError?) -> Void in
                        
                        if(success)
                        {
                            self.pushImageNotification(username)
                        }
                    })
                }
            })
        }
        else
        {
            
        }
    }
    
    
    class func pushMessageNotification(username: String, text: String)
    {
        let data = [ "title": "Mensagem de \(DAOUser.sharedInstance.getUsername())",
            "alert": "🔒 Mensagem de \(DAOUser.sharedInstance.getUsername())","badge": 1, "do": appNotification.messageReceived.rawValue, "sender" : DAOUser.sharedInstance.getUsername(), "content-avaliable" : 1, "sound": "bip.mp3"]
        
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
    
    
    class func pushImageNotification(username: String)
    {
        let message = "📷 Imagem de \(DAOUser.sharedInstance.getUsername())"
        let data = [ "title": message, "alert": message, "badge": 1, "do": appNotification.messageReceived.rawValue, "content-avaliable" : 1, "sound": "bip.mp3", "sender" : DAOUser.sharedInstance.getUsername()]
        
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
    
    class func pushAudioNotification(username: String)
    {
        let message = "🔉 Áudio de \(DAOUser.sharedInstance.getUsername())"
        let data = [ "title": message, "alert": message, "badge": 1, "do": appNotification.messageReceived.rawValue, "content-avaliable" : 1, "sound": "bip.mp3", "sender" : DAOUser.sharedInstance.getUsername()]
        
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
    
    class func pushPrintscreenNotification(username: String)
    {
        let message = "⚠️ \(DAOUser.sharedInstance.getUsername()) printou um conteúdo seu!"
        let data = [ "title": message, "alert": message, "badge": 1, "do": appNotification.printscreen.rawValue, "content-avaliable" : 1, "sound": "bip.mp3"]
        
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
    
    
    class func refreshContact(username: String, callback: (trustLevel: Int?, image: NSData?) -> Void) -> Void
    {
        let query = PFUser.query()!
        query.whereKey("username", equalTo: username)
        query.whereKey("updatedAt", greaterThan: DAOContacts.sharedInstance.getLastUpdateContact(username)!)
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            
            if(object != nil)
            {
                let trustLevel = object!["trustLevel"] as! Int
                let data = object!["profileImage"] as! PFFile
                data.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                    if(data != nil)
                    {
                        callback(trustLevel: trustLevel, image: data!)
                    }
                    else
                    {
                        callback(trustLevel: trustLevel, image: nil)
                    }
                })
            }
            else
            {
                callback(trustLevel: nil, image: nil)
            }
        }
    }
    
    
    class func getMyId() -> String
    {
        return PFUser.currentUser()!.objectId!
    }
    
    
    func sendImageOnKey(key: String, image: NSData, filter: ImageFilter)
    {
        //Executa thread até em background
        self.appdelegate.sendImageOnKey(key, image: image, filter: filter)
    }
    
    
    func downloadImageForMessage(imageKey: String, id: String)
    {
        if(self.tentativasDownload < 100)
        {
            let query = PFQuery(className: "Images")
            query.whereKey("imageKey", equalTo: imageKey)
            query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
                
                if(object != nil)
                {
                    let filterString = object!["filter"] as! String
                    
                    let file = object!["image"] as! PFFile
                    file.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                        
                        let filter = ImageFilter(rawValue: filterString)!
                        self.tentativasDownload = 0
                        let decData = EncryptTools.decImage(data!)
                        DAOContents.sharedInstance.addImage(imageKey, data: decData, filter: filter, preview: decData)
                    })
                }
                else
                {
                    self.tentativasDownload++
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(1) + self.tentativasDownload) * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        self.downloadImageForMessage(imageKey, id: id)
                    }
                }
            }
        }
        else
        {
            self.tentativasDownload = 0
        }
    }
    
    
    
    func downloadAudioForMessage(audioKey: String, id: String)
    {
        if(self.tentativasDowndloadAudio < 100)
        {
            let query = PFQuery(className: "Audios")
            query.whereKey("audioKey", equalTo: audioKey)
            query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
                
                if(object != nil)
                {
                    let filterString = object!["filter"] as! String
                    let filter = AudioFilter(rawValue: filterString)!
                    let file = object!["audio"] as! PFFile
                    file.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                        
                        self.tentativasDownload = 0
                        let decData = EncryptTools.decImage(data!)
                        DAOContents.sharedInstance.addAudio(audioKey, data: decData, filter: filter)
                    })
                }
                else
                {
                    self.tentativasDownload++
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(1) + self.tentativasDowndloadAudio) * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        self.downloadAudioForMessage(audioKey, id: id)
                    }
                }
            }
        }
        else
        {
            self.tentativasDownload = 0
        }
    }
    
    func sendAudioOnKey(key: String, audio: NSData, filter: AudioFilter)
    {
        //Executa thread até em background
        self.appdelegate.sendAudioOnKey(key, audio: audio, filter: filter)
    }
    
    func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if(background != nil){ background!(); }
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue()) {
                if(completion != nil){ completion!(); }
            }
        }
    }
    
    
    func downloadGif(name: String)
    {
        if(PFUser.currentUser() != nil)
        {
            let query = PFQuery(className: "Gifs")
            query.whereKey("name", equalTo: name)
            query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
                
                if(object != nil)
                {
                    let hashtags = object!["hashtags"] as! [String]
                    let launchedDate = object!.valueForKey("createdAt") as! NSDate
                    let gifdata = object!["gif"] as! PFFile
                    
                    gifdata.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                        
                        if(data != nil)
                        {
                            DAOContents.sharedInstance.addGif(name, data: data!, hashtags: hashtags, launchedDate: launchedDate)
                            
                            NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.gifDownloaded)
                        }
                        
                        }, progressBlock: { (progress: Int32) -> Void in
                            
//                            print("\(progress) Bytes baixados do gif \(name)")
                    })
                }
                else
                {
                    
                }
            }
        }
    }
}



