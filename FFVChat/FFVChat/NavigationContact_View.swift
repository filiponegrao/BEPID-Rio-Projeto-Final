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
    
    var fundo : UIView!
    
    var blur : UIVisualEffectView!
        
    var toolsButton : UIButton!
    
    var alert : UIImageView!
    
    var filterButtons : UIButton!
    
    
    init(requester: Contacts_ViewController)
    {
        self.vc = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 80))
        self.backgroundColor = oficialDarkGray
//        self.barTintColor = oficialDarkGray

        self.toolsButton = UIButton(frame: CGRectMake(screenWidth - 64, 20, 50 , 50))
        self.toolsButton.setImage(UIImage(named: "icon_tools"), forState: .Normal)
        self.toolsButton.addTarget(self, action: "openTools", forControlEvents: .TouchUpInside)
        
//        self.toolsButton.rippleLocation = .Center
//        self.toolsButton.rippleLayerColor = UIColor.clearColor()
//        self.toolsButton.rippleAniDuration = 0.5
//        self.toolsButton.rippleLayerColor = UIColor.whiteColor()
        self.addSubview(self.toolsButton)
        
        self.filterButtons = UIButton(frame: CGRectMake(10, 20, screenWidth/2, 45))
//        self.filterButtons.layer.borderWidth = 1
        self.filterButtons.setTitle("Contacts", forState: .Normal)
        self.filterButtons.setTitleColor(oficialGreen, forState: .Normal)
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
        self.vc.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.vc.blurView.frame = self.vc.view.bounds
        self.vc.blurView.alpha = 0
        self.vc.view.addSubview(self.vc.blurView)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.vc.blurView.alpha = 0.7
            
            }) { (success: Bool) -> Void in
                
        }

        
        self.alertOff()
        let toolscontroller = Tools_ViewController()
        toolscontroller.contacts = self.vc
        let toolsNavigation = UINavigationController(nibName: "AppNavigation2", bundle: nil)
        toolsNavigation.viewControllers = [toolscontroller]
        toolsNavigation.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        toolsNavigation.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        toolsNavigation.modalInPopover = true
        self.vc.presentViewController(toolsNavigation, animated: true) { () -> Void in
            (toolsNavigation.viewControllers.first as! Tools_ViewController).openTools()
            
//            //blur
//            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
//            visualEffectView.frame = self.vc.view.bounds
//            self.vc.view.addSubview(visualEffectView)
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
