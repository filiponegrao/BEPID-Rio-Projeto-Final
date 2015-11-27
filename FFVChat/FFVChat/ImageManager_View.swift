//
//  ImageManager_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/26/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class ImageManager_View: UIView
{
    var viewController : SentMidiaGallery_ViewController!
    
    var selectedPhoto : UIImageView!
    
    var deleteButton : MKButton!
    
    var sendButton : MKButton!
    
    var blackScreen : UIView!
    
    var closeButton : UIButton!
    
    var closeView : UIView!

    init(image: UIImage, requester: SentMidiaGallery_ViewController)
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.viewController = requester

        self.backgroundColor = UIColor.clearColor()

        self.blackScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0.9
        self.addSubview(self.blackScreen)
        
        self.closeButton = UIButton(frame: CGRectMake(0, 25, 44, 44))
        self.closeButton.setImage(UIImage(named: "close"), forState: .Normal)
        self.closeButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.closeButton)
        
        self.selectedPhoto = UIImageView(frame: CGRectMake(screenWidth/14, screenHeight/6, screenWidth - (screenWidth/14 * 2), screenHeight/8 * 5))
        self.selectedPhoto.image = image
        self.selectedPhoto.contentMode = .ScaleAspectFit
        self.selectedPhoto.backgroundColor = UIColor.clearColor()
        self.addSubview(selectedPhoto)
        
        self.sendButton = MKButton(frame: CGRectMake(screenWidth/2 - screenWidth/6 - 10, screenHeight - screenWidth/6 - 20, screenWidth/6, screenWidth/6))
        self.sendButton.layer.cornerRadius = self.sendButton.frame.size.height/2
        self.sendButton.clipsToBounds = true
        self.sendButton.setImage(UIImage(named: "send"), forState: .Normal)
        self.sendButton.backgroundLayerCornerRadius = 600
        self.sendButton.rippleLocation = .Center
        self.sendButton.ripplePercent = 2
        self.sendButton.rippleLayerColor = UIColor.blackColor()
        self.sendButton.contentMode = .ScaleAspectFill
        self.sendButton.addTarget(self, action: "sendPhoto", forControlEvents: .TouchUpInside)
        self.addSubview(self.sendButton)
        
        self.deleteButton = MKButton(frame: CGRectMake(screenWidth/2 + 10, screenHeight - screenWidth/6 - 20, screenWidth/6, screenWidth/6))
        self.deleteButton.layer.cornerRadius = self.deleteButton.frame.size.height/2
        self.deleteButton.clipsToBounds = true
        self.deleteButton.setImage(UIImage(named: "trash"), forState: .Normal)
        self.deleteButton.backgroundLayerCornerRadius = 600
        self.deleteButton.rippleLocation = .Center
        self.deleteButton.ripplePercent = 2
        self.deleteButton.rippleLayerColor = UIColor.blackColor()
        self.deleteButton.contentMode = .ScaleAspectFill
        self.deleteButton.addTarget(self, action: "deletePhoto", forControlEvents: .TouchUpInside)
        self.addSubview(self.deleteButton)
        
        self.closeView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight/6))
        self.closeView.backgroundColor = UIColor.clearColor()
        self.closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "back"))
        self.addSubview(self.closeView)

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        self.removeFromSuperview()
    }
    
    func sendPhoto()
    {
        //APRESENTA SELECTEDMIDIA_VC
//        let sentMidia = SelectedMidia_ViewController(image: self.selectedPhoto.image!, contact: self.viewController.contact)
//        back()
//        self.viewController.presentViewController(sentMidia, animated: true, completion: nil)
    }
    
    func deletePhoto()
    {
        
    }
}
