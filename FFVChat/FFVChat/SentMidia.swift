//
//  SentMidia.swift
//  FFVChat
//
//  Created by Filipo Negrao on 02/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData


class SentMidia: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func createInManagedObjectContext(moc: NSManagedObjectContext, sentDate: NSDate, target: String, image: NSData, lastSent: NSDate) -> SentMidia
    {
        let midia = NSEntityDescription.insertNewObjectForEntityForName("SentMidia", inManagedObjectContext: moc) as! SentMidia
        
        midia.sentDate = sentDate
        midia.target = target
        midia.image = image
        midia.lastSent = lastSent
        
        return midia
    }
}
