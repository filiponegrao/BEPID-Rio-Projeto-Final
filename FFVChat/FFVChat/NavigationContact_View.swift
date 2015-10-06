//
//  NavigationContact_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit
import Parse

class NavigationContact_View: UIView {

    var vc : Contacts_ViewController!
    
    var toolsButton : UIButton!
    
    var alert : UIImageView!
    
    var filterButtons : UIButton!
    
    init(requester: Contacts_ViewController)
    {
        self.vc = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 70))
        self.backgroundColor = lightBlue
        
        self.toolsButton = UIButton(frame: CGRectMake(screenWidth - 50, 20, 40, 40))
        self.toolsButton.setImage(UIImage(named: "icon_tools"), forState: .Normal)
        self.addSubview(self.toolsButton)
        
        self.filterButtons = UIButton(frame: CGRectMake(10, 20, screenWidth/2, 40))
        self.filterButtons.setTitle("ALL", forState: .Normal)
        self.filterButtons.setTitleColor(lightGray, forState: .Normal)
        self.addSubview(self.filterButtons)
        
    }

    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func openConfig()
    {
        DAOUser.sharedInstance.logOut()
        self.vc.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func alertOn()
    {
        self.alert.hidden = false
    }
    
    func alertOff()
    {
        self.alert.hidden = true
    }

}
