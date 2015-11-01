//
//  Contact.swift
//  FFVChat
//
//  Created by Filipo Negrao on 31/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData


class Contact: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    class func createInManagedObjectContext(moc: NSManagedObjectContext, username: String, facebookId: String?, createdAt: NSDate, trustLevel: Int, profileImage: NSData? ) -> Contact
    {
        let contact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: moc) as! Contact
        contact.username = username
        contact.facebookId = facebookId
        contact.createdAt = createdAt
        contact.trustLevel = trustLevel
        contact.profileImage = profileImage
        
        return contact
    }
}
