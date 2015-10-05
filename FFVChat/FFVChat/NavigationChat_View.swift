//
//  NavigationChat_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class NavigationChat_View: UIView
{
    var viewController : Chat_ViewController!
    
    var backButton : UIButton!
    
    var contactImage : UIImageView!
    
    var contactName : UILabel!
    
    var galleryButton : UIButton!
    
    init(requester: Chat_ViewController)
    {
        self.viewController = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 70))
        self.backgroundColor = UIColor.grayColor()
        
        self.backButton = UIButton(frame: CGRectMake(10, 30, 20, 20))
        self.backButton.setImage(UIImage(named: "backButton"), forState: UIControlState.Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.backButton.clipsToBounds = true
        self.backButton.layer.cornerRadius = self.backButton.frame.size.width/2
        self.addSubview((self.backButton))
        
        self.contactImage = UIImageView(frame: CGRectMake(screenWidth/2, 30, screenWidth/3, screenWidth/3))
        self.contactImage.backgroundColor = UIColor.grayColor()
        self.contactImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.contactImage.layer.borderWidth = 1.0
        self.contactImage.clipsToBounds = true
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.width/2
        self.addSubview(self.contactImage)
        
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        self.viewController.navigationController?.popViewControllerAnimated(true)
    }
}
