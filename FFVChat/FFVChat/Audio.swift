//
//  Audio.swift
//  FFVChat
//
//  Created by Filipo Negrao on 18/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData

extension Audio {
    
    @NSManaged var data: NSData!
    @NSManaged var audioKey: String!
    @NSManaged var filter: String!
    
}

enum AudioFilter : String
{
    case None = "None"
}

class Audio: NSManagedObject
{
    class func createInManagedObjectContext(moc: NSManagedObjectContext, data: NSData, audioKey: String, filter: AudioFilter) -> Audio
    {
        let audio = NSEntityDescription.insertNewObjectForEntityForName("Audio", inManagedObjectContext: moc) as! Audio
        
        audio.data = data
        audio.audioKey = audioKey
        audio.filter = filter.rawValue
        
        return audio
    }
}
