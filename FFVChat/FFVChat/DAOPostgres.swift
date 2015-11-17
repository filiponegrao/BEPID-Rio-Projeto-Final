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
    let sendURL = "\(baseUrl)/sendTextMessage.php"
    let receivedURL = "\(baseUrl)/setReceivedMessage.php"
    let seenURL = "\(baseUrl)/setSeenMessage.php"
    let fetchURL = "\(baseUrl)/fetchUnreadMessages.php"
    
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

                if let results = response.result.value {
                    
                    for result in results as! NSArray
                    {
                        let sender = result["sender"] as! String
                        let text = result["text"] as! String
                        let lifeTime = (result["lifetime"] as! NSString).integerValue
                        let date = result["sentdate"] as! String
                        
                        let sentDate = self.string2nsdate(date)
                        
                        DAOMessages.sharedInstance.addReceivedMessage(sender, text: text, sentDate: sentDate, lifeTime: lifeTime)
                        self.setMessageReceived(DAOMessages.sharedInstance.lastMessage)
                    }
                    
                }
        }
        
    }
    
    func sendTextMessage(username: String, lifeTime: Int, text: String)
    {
        let parameters : [String:AnyObject]!  = ["sender": "\(DAOUser.sharedInstance.getUsername())", "target": username, "sentDate": "\(NSDate())", "text": text, "lifeTime": lifeTime]
        
        Alamofire.request(.POST, self.sendURL, parameters: parameters)
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
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "getUnreadMessages", userInfo: nil, repeats: true)
    }
    
}


