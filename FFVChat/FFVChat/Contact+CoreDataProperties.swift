//
//  Contact+CoreDataProperties.swift
//  FFVChat
//
//  Created by Filipo Negrao on 31/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contact {

    @NSManaged var username: String!
    @NSManaged var facebookId: String?
    @NSManaged var trustLevel: NSNumber!
    @NSManaged var profileImage: NSData?
    @NSManaged var createdAt: NSDate!

}
