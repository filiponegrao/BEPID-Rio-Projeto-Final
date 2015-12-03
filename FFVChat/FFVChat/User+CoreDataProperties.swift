//
//  User+CoreDataProperties.swift
//  FFVChat
//
//  Created by Filipo Negrao on 15/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var username: String!
    @NSManaged var trustLevel: NSNumber!
    @NSManaged var password: String!
    @NSManaged var profileImage: NSData?
    @NSManaged var email: String!
    @NSManaged var facebookID: String?
    @NSManaged var gender: String?


}
