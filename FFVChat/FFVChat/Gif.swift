//
//  Gif.swift
//  FFVChat
//
//  Created by Filipo Negrao on 03/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData


class Gif: NSManagedObject
{
    class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String, data: NSData, launchedDate: NSDate, hashtags: NSData) -> Gif
    {
        let gif = NSEntityDescription.insertNewObjectForEntityForName("Gif", inManagedObjectContext: moc) as! Gif
        
        gif.data = data
        gif.name = name
        gif.launchedDate = launchedDate
        gif.hashtags = hashtags
        
        return gif
    }

}
