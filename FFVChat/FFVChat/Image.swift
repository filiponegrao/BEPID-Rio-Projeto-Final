//
//  Image.swift
//  FFVChat
//
//  Created by Filipo Negrao on 18/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData

extension Image {
    
    @NSManaged var data: NSData!
    @NSManaged var preview: NSData!
    @NSManaged var imageKey: String!
    @NSManaged var filter: String!
    
}

enum ImageFilter : String
{
    case None = "None"
    
    case Circle = "Circle"
    
    case Rect = "Rect"
    
    case Spark = "Spark"
    
    case Half = "Half"
    
    case Noise = "Noise"
    
}

class Image: NSManagedObject
{
    class func createInManagedObjectContext(moc: NSManagedObjectContext, data: NSData, filter: ImageFilter, imageKey: String, preview: NSData) -> Image
    {
        let image = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: moc) as! Image
        
        image.data = data
        image.filter = filter.rawValue
        image.imageKey = imageKey
        image.preview = preview
        
        return image
    }

}
