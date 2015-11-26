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
    
    var deleteButton : UIButton!
    
    var sendButton : UIButton!
    
    var blackScreen : UIView!
    
    var closeButton : UIButton!

    init(image: UIImage)
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))

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
        
        self.sendButton = UIButton(frame: CGRectMake(screenWidth/2 - screenWidth/6 - 10, screenHeight - screenWidth/6 - 20, screenWidth/6, screenWidth/6))
        self.sendButton.backgroundColor = oficialGreen
        self.addSubview(self.sendButton)
        
        self.deleteButton = UIButton(frame: CGRectMake(screenWidth/2 + 10, screenHeight - screenWidth/6 - 20, screenWidth/6, screenWidth/6))
        self.deleteButton.backgroundColor = oficialLightGray
        self.addSubview(self.deleteButton)

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        self.removeFromSuperview()
    }
}
