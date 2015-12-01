//
//  Message+CoreDataProperties.swift
//  FFVChat
//
//  Created by Filipo Negrao on 01/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var target: String!
    @NSManaged var sender: String!
    @NSManaged var status: String!
    @NSManaged var contentKey: String?
    @NSManaged var image: NSData?
    @NSManaged var type: String!
    @NSManaged var lifeTime: NSNumber!
    @NSManaged var filter: String?
    @NSManaged var text: String?
    @NSManaged var audio: NSData?
    @NSManaged var sentDate: NSDate!
    @NSManaged var gif: NSData?

}
