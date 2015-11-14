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
    let fetchUrl = "http://www.grad.inf.puc-rio.br/~1221846/fetchUnreadMessages.php"
    
    init()
    {
        
    }
    
    class var sharedInstance : DAOPostgres
    {
        return data
    }
    
    
//    class func getUnreadMessages(conversation: Contact) -> [Message]
//    {
//        
//        Alamofire.request(.GET, fetchUrl)
//            .responseJSON { response in
//                debugPrint(response)
//                
//                var tempImages = [UIImage]()
//                
//                let results = response.result.value as! NSArray
//                
//                for image in results
//                {
//                    tempImages.append(UIImage(data: image as! NSData)!)
//                }
//                
//                self.images = tempImages
//                self.tableView.reloadData()
//        }
//
//    }
    
    
    class func setMessageRead(message: Message)
    {
        
    }
    
}