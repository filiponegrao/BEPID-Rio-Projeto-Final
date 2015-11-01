//
//  Message+CoreDataProperties.swift
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

extension Message {

    @NSManaged var sender: String!
    @NSManaged var target: String!
    @NSManaged var sentDate: NSDate!
    @NSManaged var lifeTime: NSNumber!
    @NSManaged var text: String?
    @NSManaged var image: NSData?
    @NSManaged var status: String!

}
