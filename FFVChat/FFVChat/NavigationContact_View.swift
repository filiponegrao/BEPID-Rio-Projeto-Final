//
//  NavigationContact_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit
import Parse

class NavigationContact_View: UIView
{
    
    var vc : Contacts_ViewController!
        
    var toolsButton : MKButton!
    
    var alert : UIImageView!
    
    var filterButtons : UIButton!
    
    
    init(requester: Contacts_ViewController)
    {
        self.vc = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 70))
        self.backgroundColor = oficialGreen
        
        self.toolsButton = MKButton(frame: CGRectMake(screenWidth - 64, 20, 50 , 50))
        self.toolsButton.setImage(UIImage(named: "icon_tools"), forState: .Normal)
        self.toolsButton.addTarget(self, action: "openTools", forControlEvents: .TouchUpInside)
        self.toolsButton.rippleLocation = .Center
        self.toolsButton.rippleAniDuration = 0.5
        self.toolsButton.rippleLayerColor = UIColor.whiteColor()
        self.addSubview(self.toolsButton)
        
        self.filterButtons = UIButton(frame: CGRectMake(10, 20, screenWidth/2, 40))
//        self.filterButtons.layer.borderWidth = 1
        self.filterButtons.setTitle("Contacts", forState: .Normal)
        self.filterButtons.setTitleColor(oficialDarkGray, forState: .Normal)
        self.filterButtons.titleLabel?.textAlignment = .Left
        self.addSubview(self.filterButtons)
        
        self.alert = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        self.alert.image = UIImage(named: "icon_alert")
        self.alert.hidden = true
        self.toolsButton.addSubview(self.alert)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alertOn", name: requestNotification.requestsLoaded.rawValue, object: nil)
        
    }
    
    func openTools()
    {
        self.alertOff()
        let tools = UINavigationController(nibName: "AppNavigation2", bundle: nil)
        tools.viewControllers = [Tools_ViewController()]
        tools.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        tools.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        tools.modalInPopover = true
        self.vc.presentViewController(tools, animated: true) { () -> Void in
            (tools.viewControllers.first as! Tools_ViewController).openTools()
        }

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
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
