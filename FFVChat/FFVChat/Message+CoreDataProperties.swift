//
//  Message+CoreDataProperties.swift
//  FFVChat
//
//  Created by Filipo Negrao on 18/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var imageKey: String?
    @NSManaged var lifeTime: NSNumber!
    @NSManaged var sender: String!
    @NSManaged var sentDate: NSDate!
    @NSManaged var status: String!
    @NSManaged var target: String!
    @NSManaged var text: String?
    @NSManaged var image: NSData?

}
