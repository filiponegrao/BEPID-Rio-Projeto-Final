//
//  ImageZoom_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class ImageZoom_View: UIView {
    
    var image : UIImageView!
    
    var backButton : UIButton!
    
    var unblurVision : UIImageView!

    init(image: UIImage)
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.backgroundColor = UIColor.blackColor()
        self.layer.zPosition = 10
        
        self.image = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenWidth))
        self.image.center = self.center
        self.image.contentMode = .ScaleAspectFill
        self.image.clipsToBounds = true
        self.image.image = image
        self.addSubview(self.image)
        
        
        self.unblurVision = UIImageView(frame: CGRectMake(0, screenHeight/2, screenWidth, screenHeight/4))
        
        self.backButton = UIButton(frame: CGRectMake(0, 10, 44, 44))
        self.backButton.setImage(UIImage(named: "paperBurn"), forState: .Normal)
        self.backButton.addTarget(self, action: "fadeOut", forControlEvents: .TouchUpInside)
        self.addSubview(self.backButton)
        
        let delay = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "fadeIn", userInfo: nil, repeats: false)
        
        self.alpha = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fadeIn()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.alpha = 1
            self.image.blur(blurRadius: 10)
            
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
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
    }
    
//    
//    func getRectImage(original: UIImage, point: CGPoint) -> UIImage
//    {
//        let size = CGSizeMake(screenWidth, screenHeight/4)
//        UIGraphicsBeginImageContext(size)
//        
//        
//        
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//    }
    
    
}
