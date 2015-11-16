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

class DAOPostgres
{
    let fetchUrl = "http://www.grad.inf.puc-rio.br/~c1221846/fetchUnreadMessages.php"
    
    let sendUrl = "http://www.grad.inf.puc-rio.br/~c1221846/sendTextMessage.php"
    
    let localUrl = "http://192.168.0.21/sendTextMessage.php"
    
    //Bepid URLs
    let sendBepid = "http://172.16.2.230/sendTextMessage.php"
    let receivedBepid = "http://172.16.2.230/setReceivedMessage.php"
    let seenBepid = "172.16.2.230/setSeenMessage.php"
    let messagesBepid = "172.16.2.230/fetchUnreadMessages.php"
    
    init()
    {
        
    }
    
    class var sharedInstance : DAOPostgres
    {
        return data
    }
    
    
//    func getUnreadMessages(conversation: Contact) -> [Message]
//    {
//        
//        Alamofire.request(.GET, self.fetchUrl, parameters: nil)
//            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
//        }
//        
//    }
    
    func sendTextMessage(username: String, lifeTime: Int, text: String)
    {
        let parameters : [String:AnyObject]!  = ["sender": "\(DAOUser.sharedInstance.getUsername())", "target": username, "sentDate": "\(NSDate())", "text": text, "lifeTime": lifeTime]
        
        Alamofire.request(.POST, self.sendBepid, parameters: parameters, encoding: .URL)
            .responseJSON { response in
                print(response)
        }
    }
    
    
    func setMessageReceived(message: Message)
    {
        let parameters : [String:AnyObject]! = ["sender": message.sender, "target":DAOUser.sharedInstance.getUsername(), "sentDate": message.sentDate]
        
        Alamofire.request(.POST, self.localUrl, parameters: parameters, encoding: .URL)
            .responseJSON { response in
                print(response)
        }
    }
    
    func setMessageSent(message: Message, callback: (success: Bool) -> Void)
    {
        let parameters : [String:AnyObject]! = ["sender": message.sender, "target":DAOUser.sharedInstance.getUsername(), "sentDate": message.sentDate]
        
        Alamofire.request(.POST, self.localUrl, parameters: parameters, encoding: .URL)
            .responseJSON { response in
                print(response)
        }
    }
    
    
    
}