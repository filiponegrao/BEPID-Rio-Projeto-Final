//
//  PrintscreenNotification.swift
//  FFVChat
//
//  Created by Filipo Negrao on 28/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData




class PrintscreenNotification: NSManagedObject {

    class func createInManagedObjectContext(moc: NSManagedObjectContext, printer: String, image: NSData?, imageKey: String, printDate: NSDate) -> PrintscreenNotification
    {
        let print = NSEntityDescription.insertNewObjectForEntityForName("PrintscreenNotification", inManagedObjectContext: moc) as! PrintscreenNotification
        
        print.printer = printer
        print.image = image
        print.imageKey = imageKey
        print.printDate = printDate
        print.status = PrintScreenStatus.received.rawValue
        
        return print
    }

    
}
