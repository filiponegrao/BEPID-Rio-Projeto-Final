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
    
    let registerDate : String!
    
    let thumb : UIImage!
    
    init(username: String, registerDate: String, thumb: UIImage)
    {
        self.username = username
        self.registerDate = registerDate
        self.thumb = thumb
    }

}

class metaFaceContact
{
    let facebookID : String!
    
    let faceUsername : String!
    
    init(facebookID: String, faceUsername: String)
    {
        self.facebookID = facebookID
        self.faceUsername = faceUsername
    }
}


class metaContact
{
    let username : String!
    
    let trustLevel : Int!
    
    let photo : UIImage?
    
    let id: String!
    
    init(username: String, trustLevel: Int, photo: UIImage?, id: String)
    {
        self.username = username
        self.trustLevel = trustLevel
        self.photo = photo
        self.id = id
    }
}

