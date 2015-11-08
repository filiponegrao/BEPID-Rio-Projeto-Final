//
//  NavigationSettings_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 07/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class NavigationSettings_View: UIView
{
    var viewController : Settings_ViewController!
    
    var backButton : UIButton!
    
    var tittle : UILabel!
    
    init(requester: Settings_ViewController)
    {
        self.viewController = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 60))
        self.backgroundColor = oficialDarkGray
        
        self.backButton = UIButton(frame: CGRectMake(0, 15, 45, 45))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(backButton)
        
        self.tittle = UILabel(frame: CGRectMake(0, 25, screenWidth, 20))
        self.tittle.text = "Settings"
        self.tittle.textAlignment = .Center
        self.tittle.textColor = oficialGreen
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
