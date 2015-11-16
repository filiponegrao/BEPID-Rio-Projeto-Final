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
    
    var blackScreen : UIView!
    
    var backButton : UIButton!
    
    var title : UILabel!
    
    init()
    {
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
        
        self.title = UILabel(frame: CGRectMake(0,150, screenWidth, 50))
        self.title.text = "Temporary Contact Manager"
        self.title.textColor = oficialGreen
        self.title.textAlignment = .Center
        self.title.font = UIFont(name: "Helvetica", size: 22)
        self.addSubview(self.title)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        self.removeFromSuperview()
//        self.viewController.blurView.removeFromSuperview()
    }
    
}
