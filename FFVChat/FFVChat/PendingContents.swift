//
//  PendingContents.swift
//  FFVChat
//
//  Created by Filipo Negrao on 23/01/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData

extension PendingContents {
    
    @NSManaged var contentKey: String?
    @NSManaged var data: NSData?
    
}

class PendingContents: NSManagedObject {

    class func createInManagedObjectContext(moc: NSManagedObjectContext, data: NSData, contentKey: String) -> PendingContents
    {
        let content = NSEntityDescription.insertNewObjectForEntityForName("PendingContents", inManagedObjectContext: moc) as! PendingContents
        
        content.data = data
        content.contentKey = contentKey
        
        return content
    }
}
