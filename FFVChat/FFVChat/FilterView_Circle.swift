//
//  ImageZoom_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit


class FilterView_Circle: UIView {
    
    var message : Message!
    
    var image : Image!
    
    var imageView : UIImageView!
    
    var blurFilter : UIVisualEffectView!
    
    var backButton : UIButton!
    
    var unblurVision : UIImageView!
    
    weak var chatController : Chat_ViewController!
    
    var origin : CGRect!
    
    init(image: Image, message: Message, origin: CGRect)
    {
        self.message = message
        self.origin = origin
        self.image = image
        
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.blackColor()
        self.layer.zPosition = 10
        self.alpha = 0
        
        self.imageView = UIImageView(frame: CGRectMake(0, 70, screenWidth, screenHeight - 70))
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.image = UIImage(data: self.image.data)!
        self.imageView.layer.zPosition = 0
        self.addSubview(self.imageView)
        
        self.backButton = UIButton(frame: CGRectMake(0, 20, 50, 50))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "fadeOut", forControlEvents: .TouchUpInside)
        self.addSubview(self.backButton)
        
        //Blur
        self.blurFilter = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.blurFilter.frame = self.imageView.frame
        self.blurFilter.alpha = 1
        self.addSubview(self.blurFilter)
        
        let type = ImageFilter(rawValue: self.image.filter)!
        
        let img = UIImage(data: self.image.data)!
        self.unblurVision = UIImageView(frame: CGRectMake(0, 0, diametro, diametro))
        self.unblurVision.image = Editor.circleUnblur(img, x: 0, y: 0, imageFrame: self.imageView.frame)
        self.unblurVision.layer.cornerRadius = raio
        self.unblurVision.alpha = 0
        self.unblurVision.layer.zPosition = 5
        self.addSubview(self.unblurVision)
        
        print(type)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fadeIn()
    {
        self.frame = self.origin
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.alpha = 1
            self.frame = CGRectMake(0, 0, screenWidth, screenHeight)
            
            }) { (success: Bool) -> Void in
        }
    }
    
    func fadeOut()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.alpha = 0
            self.frame = self.origin
            
            }) { (success: Bool) -> Void in
                self.chatController.isViewing = false

                self.removeFromSuperview()
        }
    }
    
    
    
    //*** UNBLUR FUNCTIONS ****///
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if(self.image.filter == ImageFilter.Circle.rawValue)
        {
            if let touch = touches.first
            {
                let img = UIImage(data: self.image.data)!
                let x = touch.locationInView(self).x - raio
                let y = touch.locationInView(self).y - raio
                self.unblurVision.alpha = 1
                self.unblurVision.image = Editor.circleUnblur(img, x: x, y: y, imageFrame: self.imageView.frame)
                
                self.unblurVision.frame.origin = CGPointMake(x, y)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if(self.image.filter == ImageFilter.Circle.rawValue)
        {
            if let touch = touches.first
            {
                let img = UIImage(data: self.image.data)!
                let x = touch.locationInView(self).x - raio
                let y = touch.locationInView(self).y - raio
                self.unblurVision.image = Editor.circleUnblur(img, x: x, y: y, imageFrame: self.imageView.frame)
                self.unblurVision.frame.origin = CGPointMake(x, y)
            }
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if(self.image.filter == ImageFilter.Circle.rawValue)
        {
            self.unblurVision.alpha = 0
        }
    }
    
    
}
