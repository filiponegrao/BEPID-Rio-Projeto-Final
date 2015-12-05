//
//  MidiaViewer_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class MidiaViewer_View: UIView
{
    var myImage : UIImageView!
    
    var viewController : UIViewController!

    var backButton : UIButton!
    
    var passwordView : Password_View!
    
    var blackScreen : UIView!
    
    init(image: UIImage, requester: UIViewController)
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.backgroundColor = UIColor.clearColor()
        
        self.viewController = requester
        
        self.blackScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0.9
        self.addSubview(self.blackScreen)
        
        self.myImage = UIImageView(frame: CGRectMake(screenWidth/10, screenHeight/5, screenWidth - (screenWidth/10 * 2), screenHeight - (screenHeight/5 * 2)))
        self.myImage.image = image
        self.myImage.backgroundColor = oficialGreen
        self.addSubview(self.myImage)
        
        self.backButton = UIButton(frame: CGRectMake(0, 25, 44, 44))
        self.backButton.setImage(UIImage(named: "close"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview((self.backButton))
        
        self.passwordView = Password_View(requester: requester)
        self.addSubview(self.passwordView)
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
