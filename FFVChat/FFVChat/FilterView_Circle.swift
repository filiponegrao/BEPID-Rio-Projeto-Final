//
//  ImageZoom_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit


class FilterView_Circle: UIView {
    
    var imageInfo : Image!
    
    var image : UIImage!
    
    var imageView : UIImageView!
    
    var blurFilter : UIVisualEffectView!
    
    var unblurVision : UIImageView!
    
    init(image: Image)
    {
        self.imageInfo = image
        self.image = UIImage(data: self.imageInfo.data)!
        
        super.init(frame: CGRectMake(0, 70, screenWidth, screenHeight - 70))
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.blackColor()
        self.layer.zPosition = 10
        self.alpha = 1
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.image = self.image
        self.imageView.layer.zPosition = 0
        self.addSubview(self.imageView)
    
        
        //Blur
        self.blurFilter = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.blurFilter.frame = self.imageView.frame
        self.blurFilter.alpha = 1
        self.addSubview(self.blurFilter)
                
        self.unblurVision = UIImageView(frame: CGRectMake(0, 0, diametro, diametro))
        self.unblurVision.image = Editor.circleUnblur(self.image, x: 0, y: 0, imageFrame: self.imageView.frame)
        self.unblurVision.layer.cornerRadius = raio
        self.unblurVision.alpha = 0
        self.unblurVision.layer.zPosition = 5
        self.addSubview(self.unblurVision)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //*** UNBLUR FUNCTIONS ****///
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let touch = touches.first
        {
            let x = touch.locationInView(self).x - raio
            let y = touch.locationInView(self).y - raio
            self.unblurVision.alpha = 1
            self.unblurVision.image = Editor.circleUnblur(self.image, x: x, y: y, imageFrame: self.imageView.frame)
            
            self.unblurVision.frame.origin = CGPointMake(x, y)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let touch = touches.first
        {
            let x = touch.locationInView(self).x - raio
            let y = touch.locationInView(self).y - raio
            self.unblurVision.image = Editor.circleUnblur(self.image, x: x, y: y, imageFrame: self.imageView.frame)
            self.unblurVision.frame.origin = CGPointMake(x, y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.unblurVision.alpha = 0
    }
    
    
}
