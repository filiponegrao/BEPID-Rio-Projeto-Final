//
//  ImageEdition.swift
//  FFVChat
//
//  Created by Filipo Negrao on 24/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class ImageEdition
{
    
    class func compressImage(image: UIImage) -> UIImage
    {
        UIGraphicsBeginImageContext(image.size)
//        let context = UIGraphicsGetCurrentContext()
        
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
}