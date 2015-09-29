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
    
    let facebookID : String!
        
    let registerDate : String!
    
    let thumb : UIImage!
    
    init(username: String, facebookID: String, registerDate: String, thumb: UIImage)
    {
        self.username = username
        self.facebookID = facebookID
        self.registerDate = registerDate
        self.thumb = thumb
    }

}

class metaContact
{
    let facebookID : String!
    
    let faceUsername : String!
    
    init(facebookID: String, faceUsername: String)
    {
        self.facebookID = facebookID
        self.faceUsername = faceUsername
    }
}