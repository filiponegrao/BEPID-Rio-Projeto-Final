//
//  PrintscreenNotification+CoreDataProperties.swift
//  FFVChat
//
//  Created by Filipo Negrao on 28/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PrintscreenNotification {

    @NSManaged var printer: String!
    @NSManaged var image: NSData?
    @NSManaged var imageKey: String!
    @NSManaged var printDate: NSDate!
    @NSManaged var status: String!

}
