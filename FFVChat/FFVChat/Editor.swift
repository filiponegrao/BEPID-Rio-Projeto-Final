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
    class func circleUnblur(image: UIImage, x: CGFloat, y: CGFloat, imageFrame : CGRect) -> UIImage
    {
        var prop : CGFloat!
        var margemX : CGFloat!
        var margemY : CGFloat!
        let w : CGFloat = imageFrame.size.width
        let h : CGFloat = imageFrame.size.height
        
        if(image.size.width > image.size.height)
        {
            if(image.size.width > w)
            {
                prop = w/image.size.width
                margemX = 0
                margemY = (h - image.size.height * prop)/2
            }
            else
            {
                prop = w/image.size.width
                margemX = 0
                margemY = (h - image.size.height * prop)/2
            }
        }
        else if(image.size.height > image.size.width)
        {
            
            if(image.size.height > h)
            {
                prop = h/image.size.height
                margemX = (w - image.size.width * prop)/2
                margemY = 0
            }
            else
            {
                prop = h/image.size.height
                margemX = (w - image.size.width * prop)/2
                margemY = 0
            }
        }
        else
        {
            if(image.size.width > w)
            {
                prop = w/image.size.width
            }
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(diametro, diametro))
        image.drawInRect(CGRectMake(-(x)+margemX+imageFrame.origin.x , -(y)+margemY+imageFrame.origin.y, image.size.width * prop, image.size.height * prop), blendMode: CGBlendMode.Normal, alpha: 1)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}