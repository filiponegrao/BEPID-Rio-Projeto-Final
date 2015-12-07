//
//  Gif+CoreDataProperties.swift
//  FFVChat
//
//  Created by Filipo Negrao on 03/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Gif {

    @NSManaged var name: String!
    @NSManaged var data: NSData!
    @NSManaged var launchedDate: NSDate!
    @NSManaged var hashtags: NSData!

}
