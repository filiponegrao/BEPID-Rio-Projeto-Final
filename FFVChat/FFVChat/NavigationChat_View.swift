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
    
    var contactImage : UIButton!
    
    var contactName : UILabel!
    
    var galleryButton : UIButton!
    
    init(requester: Chat_ViewController)
    {
        self.viewController = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 80))
        self.backgroundColor = UIColor.grayColor()
        
        
        self.backButton = UIButton(frame: CGRectMake(10, 20, 100, 44))
//        self.backButton.setImage(UIImage(named: "backButton"), forState: UIControlState.Normal)
        self.backButton.setTitle("< Contacts", forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.backButton.clipsToBounds = true
//        self.backButton.backgroundColor = UIColor.whiteColor()
        self.addSubview((self.backButton))
        
        self.contactImage = UIButton(frame: CGRectMake(screenWidth/2, 25, screenWidth/5, screenWidth/5))
        self.contactImage.backgroundColor = UIColor.grayColor()
        self.contactImage.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.contactImage.layer.borderWidth = 1.0
        self.contactImage.layer.shadowOpacity = 1
        self.contactImage.layer.shadowRadius = 3.5
        self.contactImage.layer.shadowColor = UIColor.blackColor().CGColor
        self.contactImage.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        self.contactImage.clipsToBounds = true
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.width/2
        self.contactImage.center = CGPointMake(self.center.x, self.center.y + 15)
        self.contactImage.addTarget(self, action: "goToProfile", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.contactImage)
        
        self.galleryButton = UIButton(frame: CGRectMake(self.frame.size.width - 54 , 25, 44, 44))
        self.galleryButton.alpha = 0.3
        self.galleryButton.setImage(UIImage(named: "galleryButton"), forState: .Normal)
        self.addSubview(galleryButton)
        
//        self.galleryButton = UIButton(frame: CGRectMake(self.center.x - (self.contactImage.frame.width/2 + 65), 30, 40, 40))
//        self.galleryButton.setImage(UIImage(named: "galleryButton"), forState: UIControlState.Normal)
//        self.galleryButton.center = CGPointMake(self.center.x/2, self.galleryButton.frame.height/2 + 30)
//        self.addSubview(self.galleryButton)
        
//        self.contactName = UILabel(frame: CGRectMake(self.contactImage.center.x + self.contactImage.frame.height/2 + 10, self.contactImage.center.y - 25, screenWidth/3, self.frame.height/2))
//        self.contactName.text = "filiponegrao"
//        self.contactName.textAlignment = .Center
//        self.contactName.textColor = UIColor.whiteColor()
//        self.addSubview(self.contactName)

        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        self.viewController.navigationController?.popViewControllerAnimated(true)
    }
    
    func goToProfile()
    {
        let profile = ReceiverProfile_ViewController()
        profile.contact = viewController.contact
        self.viewController.navigationController?.pushViewController(profile, animated: true)
    }
}
