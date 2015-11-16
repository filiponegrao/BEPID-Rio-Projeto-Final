//
//  ContactManager_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class ContactManager_View: UIView
{
    var viewController : ContactsBubble_CollectionViewController!
    
    var contact : Contact!
    
    var blackScreen : UIView!
    
    var backButton : UIButton!
    
    var contactImage : UIImageView!
    
    var circleView : CircleView!
    
    var trustLevel : Int!
    
    var favouriteButton : UIButton!
    
    var deleteButton : UIButton!
    
    init(contact: Contact)
    {
        self.contact = contact
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.backgroundColor = UIColor.clearColor()
        
        self.blackScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0.9
        self.addSubview(self.blackScreen)
        
        self.backButton = UIButton(frame: CGRectMake(0, 25, 44, 44))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview((self.backButton))
        
        self.trustLevel = Int(self.contact.trustLevel)
        
        self.contactImage = UIImageView(frame: CGRectMake(screenWidth/5 * 2, screenHeight/5, screenWidth/2, screenWidth/2))
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.height/2
        self.contactImage.clipsToBounds = true
        self.contactImage.backgroundColor = oficialGreen
        self.contactImage.image = UIImage(data: self.contact.profileImage)
        self.addSubview(self.contactImage)
        
        addCircleView()
        
        self.favouriteButton = UIButton(frame: CGRectMake(screenWidth/8, screenHeight/7 * 3, screenWidth/5, screenWidth/5))
        self.favouriteButton.backgroundColor = oficialLightGray
        self.favouriteButton.layer.cornerRadius = self.favouriteButton.frame.size.height/2
        self.favouriteButton.clipsToBounds = true
        self.addSubview(self.favouriteButton)
        
        self.deleteButton = UIButton(frame: CGRectMake(screenWidth/8 * 3, screenHeight/7 * 4 - 10, screenWidth/5, screenWidth/5))
        self.deleteButton.backgroundColor = oficialLightGray
        self.deleteButton.layer.cornerRadius = self.deleteButton.frame.size.height/2
        self.deleteButton.clipsToBounds = true
        self.addSubview(self.deleteButton)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        self.removeFromSuperview()
//        self.viewController.blurView.removeFromSuperview()
    }
    
    func addCircleView()
    {
        let circleWidth = screenWidth/1.95
        let circleHeight = screenWidth/1.95

        self.circleView = CircleView(frame: CGRectMake(0, 0, circleWidth, circleHeight))
        self.circleView.center = CGPointMake(self.contactImage.center.x, self.contactImage.center.y)
        
        self.circleView.setColor(self.trustLevel)
        self.circleView.animateCircle(1.0, trustLevel: self.trustLevel)
        
        self.addSubview(self.circleView)

    }
    
}
