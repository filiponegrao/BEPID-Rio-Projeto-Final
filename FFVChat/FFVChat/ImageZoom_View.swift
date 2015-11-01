//
//  ImageZoom_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

let diametro = screenWidth/2

let raio = diametro/2

class ImageZoom_View: UIView {
    
    var image : UIImage!
    
    var imageView : UIImageView!
    
    var backButton : UIButton!
    
    var unblurVision : UIImageView!

    init(image: UIImage)
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.backgroundColor = UIColor.blackColor()
        self.layer.zPosition = 10
        self.alpha = 0
        
        self.image = image
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenWidth))
        self.imageView.center = self.center
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = image
        
        //blur
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = imageView.bounds
        imageView.addSubview(visualEffectView)
        
        self.imageView.layer.zPosition = 0
        self.addSubview(self.imageView)
        
        
        self.unblurVision = UIImageView(frame: CGRectMake(0, screenHeight/2, screenWidth, screenHeight/4))
        
        self.backButton = UIButton(frame: CGRectMake(0, 10, 44, 44))
        self.backButton.setImage(UIImage(named: "paperBurn"), forState: .Normal)
        self.backButton.addTarget(self, action: "fadeOut", forControlEvents: .TouchUpInside)
        self.addSubview(self.backButton)
        
        let delay = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "fadeIn", userInfo: nil, repeats: false)
        
        self.unblurVision = UIImageView(frame: CGRectMake(0, 0, diametro, diametro))
        self.unblurVision.image = Editor.circleUnblur(self.image!, x: 0, y: 0)
        self.unblurVision.layer.cornerRadius = raio
        self.unblurVision.alpha = 0
        self.unblurVision.layer.zPosition = 5
        self.addSubview(self.unblurVision)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fadeIn()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.alpha = 1
            
            }) { (success: Bool) -> Void in
        }
    }
    
    func fadeOut()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.alpha = 0
            
            }) { (success: Bool) -> Void in
               self.removeFromSuperview()
        }
    }
    
    
    
    //*** UNBLUR FUNCTIONS ****///
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let touch = touches.first
        {
            let x = touch.locationInView(self).x - raio
            let y = touch.locationInView(self).y - raio
            self.unblurVision.alpha = 1
            self.unblurVision.image = Editor.circleUnblur(self.image!, x: x, y: y)
            self.unblurVision.frame.origin = CGPointMake(x, y)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let touch = touches.first
        {
            let x = touch.locationInView(self).x - raio
            let y = touch.locationInView(self).y - raio
            self.unblurVision.image = Editor.circleUnblur(self.image!, x: x, y: y)
            self.unblurVision.frame.origin = CGPointMake(x, y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.unblurVision.alpha = 0
    }
    
    
}
