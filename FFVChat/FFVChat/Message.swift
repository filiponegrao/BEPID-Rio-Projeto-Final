//
//  Message.swift
//  FFVChat
//
//  Created by Filipo Negrao on 14/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit



class Message
{
    let date : NSDate!
    
    let sender : String!
    
    let target : String!
    
    let text : String?
    
    let image : UIImage?
    
    
    init(sender: String, target: String, date: NSDate, text: String!)
    {
        self.sender = sender
        self.target = target
        self.date = date
        self.text = text
        self.image = nil
    }
    
    init(sender: String, target: String, date: NSDate, image: UIImage)
    {
        self.sender = sender
        self.target = target
        self.date = date
        self.image = image
        self.text = nil
    }
    
    //COMING SOON  
//    init(sender: String, target: String, date: NSDate, text: String, image: UIImage)
//    {
//        self.sender = sender
//        self.target = target
//        self.date = date
//        self.image = image
//        self.text = text
//    }
    
    
}


class Chat
{
    
}



