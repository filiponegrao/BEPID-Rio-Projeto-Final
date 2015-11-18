//
//  DAOPostgres.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Alamofire


private let data: DAOPostgres = DAOPostgres()
var baseUrl = "http://54.94.247.156"


class DAOPostgres : NSObject
{
    var timer : NSTimer!
    
    //Bepid URLs
    let sendMessageURL = "\(baseUrl)/sendTextMessage.php"
    let sendImageMessageURL = "\(baseUrl)/sendImageMessage.php"
    let receivedURL = "\(baseUrl)/setReceivedMessage.php"
    let seenURL = "\(baseUrl)/setSeenMessage.php"
    let fetchURL = "\(baseUrl)/fetchUnreadMessages.php"
    let sendImageURL = "\(baseUrl)/insertImage.php"
    
    override init()
    {
        super.init()
    }
    
    class var sharedInstance : DAOPostgres
    {
        return data
    }
    
    
    func getUnreadMessages()
    {
        let parameters : [String:AnyObject]!  = ["target":DAOUser.sharedInstance.getUsername()]
        
        Alamofire.request(.POST, self.fetchURL, parameters: parameters)
            .responseJSON { response in
//                debugPrint(response)

                print("refresh...")
                if let results = response.result.value {
                    
                    
                    for result in results as! NSArray
                    {
                        let imageKey = result["imageKey"] as? String
                        let sender = result["sender"] as! String
                        let lifeTime = (result["lifetime"] as! NSString).integerValue
                        let date = result["sentdate"] as! String
                        let sentDate = self.string2nsdate(date)
                        //Texto
                        if(imageKey == nil)
                        {
                            let text = result["text"] as! String
                            DAOMessages.sharedInstance.addReceivedMessage(sender, text: text, sentDate: sentDate, lifeTime: lifeTime)
                            self.setMessageReceived(DAOMessages.sharedInstance.lastMessage)
                        }
                        //Image
                        else
                        {
                            DAOMessages.sharedInstance.addReceivedMessage(sender, imageKey: imageKey!, sentDate: sentDate, lifeTime: lifeTime)
                            self.setMessageReceived(DAOMessages.sharedInstance.lastMessage)
                        }
                    }
                    
                }
        }

    }
    
    func sendTextMessage(username: String, lifeTime: Int, text: String)
    {
        let parameters : [String:AnyObject]!  = ["sender": "\(DAOUser.sharedInstance.getUsername())", "target": username, "sentDate": "\(NSDate())", "text": text, "lifeTime": lifeTime]
        
        
        Alamofire.request(.POST, self.sendMessageURL, parameters: parameters)
            .responseJSON { response in
                print(response)
        }
    }
    
    func sendImageMessage(username: String, lifeTime: Int, imageKey: String ,image: UIImage)
    {
        DAOParse.sendImageOnKey(imageKey, image: image)

        let me = DAOUser.sharedInstance.getUsername()

        let parameters : [String:AnyObject]!  = ["sender": me, "target": username, "sentDate": "\(NSDate())", "imagekey": imageKey, "lifeTime": lifeTime]
        
        Alamofire.request(.POST, self.sendImageMessageURL, parameters: parameters)
            .responseJSON { response in
                print(response)
        }
        
    }
    
    
    
    func setMessageReceived(message: Message)
    {
        let parameters : [String:AnyObject]! = ["sender": message.sender, "target":DAOUser.sharedInstance.getUsername(), "sentDate": message.sentDate]
        
        Alamofire.request(.POST, self.receivedURL, parameters: parameters)
            .responseJSON { response in
                print(response)
        }
    }
    
    func setMessageSeen(message: Message, callback: (success: Bool) -> Void)
    {
        let parameters : [String:AnyObject]! = ["sender": message.sender, "target":DAOUser.sharedInstance.getUsername(), "sentDate": message.sentDate]
        
        Alamofire.request(.POST, self.seenURL, parameters: parameters)
            .responseJSON { response in
                print(response)
        }
    }
    
    
    func string2nsdate(str: String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        return dateFormatter.dateFromString(str) as NSDate!
    }
    
    func stopRefreshing()
    {
        self.timer.invalidate()
    }
    
    func startRefreshing()
    {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "getUnreadMessages", userInfo: nil, repeats: true)
    }
    
}

