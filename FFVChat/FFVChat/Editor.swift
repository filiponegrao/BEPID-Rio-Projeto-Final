//
//  Editor.swift
//  FFVChat
//
//  Created by Filipo Negrao on 27/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class Editor
{
    class func circleUnblur(image: UIImage, x: CGFloat, y: CGFloat) -> UIImage
    {
        var prop : CGFloat!
        var margem : CGFloat!
        
        if(image.size.width > image.size.height)
        {
            prop = screenHeight/image.size.height
        }
        else if(image.size.height > image.size.width)
        {
            prop = screenWidth/image.size.width
        }
        else
        {
            if(image.size.width > screenWidth)
            {
                prop = screenWidth/image.size.width
            }
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(diametro, diametro))
        image.drawInRect(CGRectMake(-x, -y, image.size.width * prop, image.size.height * prop), blendMode: CGBlendMode.Normal, alpha: 1)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}