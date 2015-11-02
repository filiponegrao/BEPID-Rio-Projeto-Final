//
//  SentMidia+CoreDataProperties.swift
//  FFVChat
//
//  Created by Filipo Negrao on 02/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SentMidia {

    @NSManaged var sentDate: NSDate?
    @NSManaged var image: NSData?
    @NSManaged var lastSent: NSDate?
    @NSManaged var target: String?

}
