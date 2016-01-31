//
//  GifSharing_View.swift
//  FFVChat
//
//  Created by Filipo Negrao on 03/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class GifSharing_View : UIView
{
    var blackScreen : UIView!
    
    var webView : WKWebView!
    
    var shareButton : UIButton!
    
    var cancelButton : UIButton!
    
    var imageOrigin : CGRect!
    
    var blurView : UIVisualEffectView!
    
    weak var chatViewController : Chat_ViewController!
    
    weak var gifGalleryController : GifGallery_UIViewController!
    
    //Gif information
    
    var gifUrl: String?
    
    var gifName: String!
    
    init(imageOrigin: CGRect, gifName: String)
    {
        self.imageOrigin = imageOrigin
        self.gifName = gifName
        self.gifUrl = DAOContents.sharedInstance.getUrlFromGifName(gifName)
        
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.blackScreen = UIView(frame: CGRectMake(0,0,screenWidth,screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0
        self.addSubview(self.blackScreen)
        
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        self.blurView.frame = self.blackScreen.frame
        self.blurView.alpha = 0
        self.addSubview(self.blurView)
        
        self.webView = WKWebView(frame: CGRectMake(10, screenHeight/5, screenWidth - 20, screenWidth - 20))
        self.webView.layer.cornerRadius = 4
        self.webView.userInteractionEnabled = false
        self.webView.scrollView.backgroundColor = oficialDarkGray
        self.webView.scrollView.zoomScale += 0.5
        
        if(self.gifUrl != nil)
        {
            let request = NSURLRequest(URL: NSURL(string: self.gifUrl!)!)
            self.webView.loadRequest(request)
        }
        
        self.addSubview(self.webView)
        
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
        let finalFrame = self.webView.frame
        let shareFinalCenter = self.shareButton.center
        let cancelFinalCenter = self.cancelButton.center
        
        self.webView.frame = self.imageOrigin
        self.shareButton.center.y += screenWidth/2
        self.cancelButton.center.y += screenWidth/2

        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
            
            self.blackScreen.alpha = 0.7
            self.blurView.alpha = 0.7
            self.webView.frame = finalFrame
            self.shareButton.center = shareFinalCenter
            self.cancelButton.center = cancelFinalCenter
            self.cancelButton.alpha = 1
            
            }) { (success: Bool) -> Void in
                
        }
    }
    
    func animateOff()
    {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
            
            self.webView.frame = self.imageOrigin
            self.webView.contentMode = .ScaleAspectFill
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
            
            self.webView.frame = self.imageOrigin
            self.webView.contentMode = .ScaleAspectFill
            self.shareButton.center.y += screenWidth/2
            self.cancelButton.center.y += screenWidth/2
            self.cancelButton.alpha = 0
            self.blackScreen.alpha = 0
            self.blurView.alpha = 0
            
            }) { (success: Bool) -> Void in
                
            
                self.chatViewController.sendGif(self.gifName)
                self.removeFromSuperview()
                self.gifGalleryController.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
        }

    }
    
    
}