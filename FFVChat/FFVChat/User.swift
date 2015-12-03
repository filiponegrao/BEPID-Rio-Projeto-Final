//
//  User.swift
//  FFVChat
//
//  Created by Filipo Negrao on 15/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject
{
    class func createInManagedObjectContext(moc: NSManagedObjectContext, username: String, email: String, profileImage: NSData, trustLevel: Int, facebookID: String?, gender: String?, password: String) -> User
    {
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! User
        
        user.email = email
        user.username = username
        user.profileImage = profileImage
        user.facebookID = facebookID
        user.trustLevel = trustLevel
        user.gender = gender
        user.password = password
        
        return user
    }


}
