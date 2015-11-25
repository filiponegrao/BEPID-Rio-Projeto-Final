//
//  NavigationChangePassword_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 15/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class NavigationChangePassword_View: UIView
{
    var viewController : ChangePassword_ViewController!
    
    var backButton : UIButton!
    
    var tittle : UILabel!
    
    init(requester: ChangePassword_ViewController)
    {
        self.viewController = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 70))
        self.backgroundColor = oficialDarkGray
        
        self.backButton = UIButton(frame: CGRectMake(0, 20, 45, 45))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(backButton)
        
        self.tittle = UILabel(frame: CGRectMake(0, 25, screenWidth, 35))
        self.tittle.text = "Password"
        self.tittle.textAlignment = .Center
        self.tittle.textColor = oficialGreen
        self.tittle.font = self.tittle.font
            .fontWithSize(22)
        self.addSubview(tittle)
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
