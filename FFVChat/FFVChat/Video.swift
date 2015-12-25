//
//  Video.swift
//  FFVChat
//
//  Created by Filipo Negrao on 18/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData

extension Video {
    
    @NSManaged var data: NSData!
    @NSManaged var preview: NSData!
    @NSManaged var videoKey: String!
    @NSManaged var filter: String!
}

enum VideoFilter : String
{
    case None = "None"
}

class Video: NSManagedObject
{
    class func createInManagedObjectContext(moc: NSManagedObjectContext, data: NSData, videoKey: String, filter: VideoFilter, preview: NSData) -> Video
    {
        let video = NSEntityDescription.insertNewObjectForEntityForName("Video", inManagedObjectContext: moc) as! Video
        
        video.data = data
        video.videoKey = videoKey
        video.filter = filter.rawValue
        video.preview = preview
        
        return video
    }
}
