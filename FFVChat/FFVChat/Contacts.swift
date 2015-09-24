//
//  Contacts.swift
//  FFVChat
//
//  Created by Filipo Negrao on 23/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class Contact
{
    let username : String!
    
    let faceUsername : String!
        
    let registerDate : String!
    
    let thumb : UIImage!
    
    init(username: String, faceUsername: String, registerDate: String)
    {
        self.username = username
        self.faceUsername = faceUsername
        self.registerDate = registerDate
    }

}