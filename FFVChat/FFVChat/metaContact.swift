//
//  metaContact.swift
//  FFVChat
//
//  Created by Filipo Negrao on 30/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class metaContact
{
    var username : String!
    
    var facebookId : String?
    
    var photo : UIImage!
    
    init(username : String, facebookId : String?, photo: UIImage)
    {
        self.username = username
        self.facebookId = facebookId
        self.photo = photo
    }
}
