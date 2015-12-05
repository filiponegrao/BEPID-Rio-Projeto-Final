//
//  DAOPostgres.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift


private let data: DAOPostgres = DAOPostgres()
var baseUrl = "http://54.94.247.156/phps"


class DAOPostgres : NSObject
{
    var refresherChat : NSTimer!
    
    var refresherContact : NSTimer!
    
    //Bepid URLs
    let sendMessageURL = "\(baseUrl)/sendTextMessage.php"
    let sendImageMessageURL = "\(baseUrl)/sendImageMessage.php"
    let receivedURL = "\(baseUrl)/setReceivedMessage.php"
    let seenURL = "\(baseUrl)/setSeenMessage.php"
    let deletedURL = "\(baseUrl)/setDeletedMessage.php"
    let fetchURL = "\(baseUrl)/fetchUnreadMessages.php"
    let sendImageURL = "\(baseUrl)/insertImage2.php"
    let fetchImageURL = "\(baseUrl)/fetchImage.php"
    let sendURL = "\(baseUrl)/sendMessage.php"
    
    
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
        print("refreshing messages...")
        let parameters : [String:AnyObject]!  = ["target": EncryptTools.encUsername(DAOUser.sharedInstance.getUsername())]
        
        Alamofire.request(.POST, self.fetchURL, parameters: parameters)
            .responseJSON { response in
                
                if let results = response.result.value {
                    
                    for result in results as! NSArray
                    {
                        let typeString = result["type"] as! String
                        let type = ContentType(rawValue: typeString)!
                        let sender = result["sender"] as! String
                        let key = result["contentkey"] as? String
                        let lifeTime = (result["lifetime"] as! NSString).integerValue
                        let date = result["sentdate"] as! String
                        let sentDate = self.string2nsdate(date)

                        switch type
                        {
                            
                        case .Text:
                            
                            let text = result["text"] as! String
                            if(DAOMessages.sharedInstance.addReceivedMessage(sender, text: text, sentDate: sentDate, lifeTime: lifeTime))
                            {
                                self.setMessageReceived(DAOMessages.sharedInstance.lastMessage)
                            }
                            
                        case .Image:
                            
                            let filterString = result["filter"] as! String
                            let filter = ImageFilter(rawValue: filterString)!
                            if(DAOMessages.sharedInstance.addReceivedMessage(sender, contentKey: key!, sentDate: sentDate, lifeTime: lifeTime, filter: filter))
                            {
                                self.setMessageReceived(DAOMessages.sharedInstance.lastMessage)
                            }
                            
                        case .Audio:
                            
                            print("recebeu audio")
                            
                        case .Gif:
                            
                            let data = DAOGifs.sharedInstance.getGifFromName(key!)
                            if(data != nil)
                            {
                                if(DAOMessages.sharedInstance.addReceivedMessage(sender, gifKey: key!, gifData: data!, sentDate: sentDate, lifeTime: lifeTime))
                                {
                                    self.setMessageReceived(DAOMessages.sharedInstance.lastMessage)
                                }
                            }
                            
                        default:
                            
                            print("Erro ao encontrar tipo do arquivo recebido!")
                            
                        }
                    }
                }
        }
    }
    
    func sendTextMessage(username: String, lifeTime: Int, text: String)
    {
        let parameters : [String:AnyObject]!  = ["sender": EncryptTools.encUsername(DAOUser.sharedInstance.getUsername()), "target": username, "sentDate": "\(NSDate())", "text": text, "lifeTime": lifeTime, "type": ContentType.Text.rawValue]
        
        Alamofire.request(.POST, self.sendURL, parameters: parameters)
            .responseJSON { response in
                print(response)
        }
    }
    
    func sendImageMessage(username: String, lifeTime: Int, imageKey: String ,image: UIImage, filter: ImageFilter)
    {
        let me = DAOUser.sharedInstance.getUsername()
        
        let parameters : [String:AnyObject]!  = ["sender": EncryptTools.encUsername(me), "target": username, "sentDate": "\(NSDate())", "contentKey": imageKey, "lifeTime": lifeTime, "type": ContentType.Image.rawValue, "filter": filter.rawValue]
        
        Alamofire.request(.POST, self.sendURL, parameters: parameters)
            .responseJSON { response in
                print(response)
        }
    }
    
    func sendGifMessage(username: String, lifeTime: Int, gifKey: String)
    {
        let me = DAOUser.sharedInstance.getUsername()
        
        let parameters : [String:AnyObject]!  = ["sender": EncryptTools.encUsername(me), "target": username, "sentDate": "\(NSDate())", "contentKey": gifKey, "lifeTime": lifeTime, "type": ContentType.Gif.rawValue]
        
        Alamofire.request(.POST, self.sendURL, parameters: parameters)
            .responseJSON { response in
                print(response)
        }
    }
    
    
    //    func sendImage(username: String, image: UIImage, imageKey: String)
    //    {
    //
    //        let base64String = (image.mediumQualityJPEGNSData).base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
    //        print(base64String)
    //
    //        Alamofire.request(.POST, self.sendImageURL, parameters: ["imageKey": imageKey, "image": base64String])
    //            .responseJSON {response in
    //                print(response)
    //        }
    //
    //        Alamofire.upload(.POST, url, data: image.lowestQualityJPEGNSData)
    //            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
    //                print(totalBytesWritten)
    //
    //                dispatch_async(dispatch_get_main_queue()) {
    //                    print("Total bytes written on main queue: \(totalBytesWritten)")
    //                }
    //            }
    //
    //            .responseJSON { response  in
    //
    //                print(response)
    //        }
    //    }
    
    
    //    func loadImage(message: Message)
    //    {
    //        Alamofire.request(.POST, self.fetchImageURL, parameters: ["imageKey": message.imageKey!])
    //            .responseString { response in
    //
    //                let string = response.result.value! as String
    //
    //                let index = string.startIndex.advancedBy(1)
    //
    //                let newString = string.substringFromIndex(index)
    //                print(newString)
    //
    //                let data = NSData(base64EncodedString: newString, options: NSDataBase64DecodingOptions.init(rawValue: 0))
    //
    //                DAOMessages.sharedInstance.setImageForMessage(message, image: data!)
    //        }
    //
    //
    //    }
    
    
    func setMessageReceived(message: Message)
    {
        let parameters : [String:AnyObject]! = ["sender": EncryptTools.encUsername(message.sender), "target": EncryptTools.encUsername(message.target), "sentDate": message.sentDate]
        
        Alamofire.request(.POST, self.receivedURL, parameters: parameters)
            .responseJSON { response in
                print(response.result.value)
        }
    }
    
    func setMessageSeen(message: Message)
    {
        let parameters : [String:AnyObject]! = ["sender": EncryptTools.encUsername(message.sender), "target": EncryptTools.encUsername(message.target), "sentDate": message.sentDate]
        
        Alamofire.request(.POST, self.seenURL, parameters: parameters)
            .responseJSON { response in
                print(response.result.value)
        }
    }
    
    func setDeletedMessage(message: Message)
    {
        let parameters : [String:AnyObject]! = ["sender": EncryptTools.encUsername(message.sender), "target": EncryptTools.encUsername(message.target), "sentDate": message.sentDate]
        
        Alamofire.request(.POST, self.deletedURL, parameters: parameters)
            .responseJSON { response in
                print(response.result.value)
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
        self.refresherChat?.invalidate()
    }
    
    func startRefreshing()
    {
        self.stopObserve()
        self.refresherChat?.invalidate()
        self.refresherChat = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "getUnreadMessages", userInfo: nil, repeats: true)
    }
    
    func startObserve()
    {
        self.refresherContact?.invalidate()
        self.refresherContact = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "getUnreadMessages", userInfo: nil, repeats: true)
    }
    
    func stopObserve()
    {
        self.refresherContact?.invalidate()
    }
}


