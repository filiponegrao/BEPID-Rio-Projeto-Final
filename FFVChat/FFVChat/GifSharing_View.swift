//
//  GifSharing_View.swift
//  FFVChat
//
//  Created by Filipo Negrao on 03/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class GifSharing_View : UIView
{
    var blackScreen : UIView!
    
    var imageView : UIImageView!
    
    var shareButton : UIButton!
    
    var cancelButton : UIButton!
    
    var imageOrigin : CGRect!
    
    var blurView : UIVisualEffectView!
    
    weak var chatViewController : Chat_ViewController!
    
    weak var gifGalleryController : GifGallery_UIViewController!
    
    //Gif information
    
    var gifData : NSData!
    
    var gifName : String!
    
    init(imageOrigin: CGRect, gifData: NSData, gifName: String)
    {
        self.imageOrigin = imageOrigin
        self.gifData = gifData
        self.gifName = gifName
        
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.blackScreen = UIView(frame: CGRectMake(0,0,screenWidth,screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0
        self.addSubview(self.blackScreen)
        
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        self.blurView.frame = self.blackScreen.frame
        self.blurView.alpha = 0
        self.addSubview(self.blurView)
        
        self.imageView = UIImageView(frame: CGRectMake(10, screenHeight/5, screenWidth - 20, screenWidth - 20))
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.layer.cornerRadius = 4
        self.imageView.clipsToBounds = true
        self.addSubview(self.imageView)
        
        self.shareButton = UIButton(frame: CGRectMake(0, 0,screenWidth/2.5, screenWidth/2.5))
        self.shareButton.setImage(UIImage(named: "send"), forState: .Normal)
        self.shareButton.center = CGPointMake(screenWidth/2, screenHeight - screenWidth/6 - 20)
        self.shareButton.addTarget(self, action: "sendGif", forControlEvents: .TouchUpInside)
        self.shareButton.imageView?.contentMode = .ScaleAspectFit
        self.addSubview(self.shareButton)
        
        self.cancelButton = UIButton(frame: CGRectMake(0, 25, 44, 44))
        self.cancelButton.setImage(UIImage(named: "close"), forState: .Normal)
        self.cancelButton.addTarget(self, action: "animateOff", forControlEvents: .TouchUpInside)
        self.addSubview(self.cancelButton)
    }
    
    
    func animateOn()
    {
        let finalFrame = self.imageView.frame
        let shareFinalCenter = self.shareButton.center
        let cancelFinalCenter = self.cancelButton.center
        
        self.imageView.frame = self.imageOrigin
        self.shareButton.center.y += screenWidth/2
        self.cancelButton.center.y += screenWidth/2

        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
            
            self.blackScreen.alpha = 0.7
            self.blurView.alpha = 0.7
            self.imageView.frame = finalFrame
            self.shareButton.center = shareFinalCenter
            self.cancelButton.center = cancelFinalCenter
            self.cancelButton.alpha = 1
            
            }) { (success: Bool) -> Void in
                
        }
    }
    
    func animateOff()
    {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
            
            self.imageView.frame = self.imageOrigin
            self.imageView.contentMode = .ScaleAspectFill
            self.shareButton.center.y += screenWidth/2
            self.cancelButton.alpha = 0
            self.cancelButton.center.y += screenWidth/2
            self.blackScreen.alpha = 0
            self.blurView.alpha = 0
            
            }) { (success: Bool) -> Void in
              
                self.removeFromSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendGif()
    {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
            
            self.imageView.frame = self.imageOrigin
            self.imageView.contentMode = .ScaleAspectFill
            self.shareButton.center.y += screenWidth/2
            self.cancelButton.center.y += screenWidth/2
            self.blackScreen.alpha = 0
            self.blurView.alpha = 0
            
            }) { (success: Bool) -> Void in
                
            
                self.chatViewController.sendGif(self.gifName, gifData: self.gifData)
                self.removeFromSuperview()
                self.gifGalleryController.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
        }

    }
    
    
}