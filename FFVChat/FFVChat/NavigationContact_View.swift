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
    
    weak var vc : Home_ViewController!
    
    var fundo : UIView!
    
    var blur : UIVisualEffectView!
        
    var toolsButton : UIButton!
    
    var alert : UIImageView!
    
    var searchButton : UIButton!
    
    weak var contactManager : ContactManager_View!
    
    var toolsViewController : Tools_ViewController!
    
    var animando : Bool = false
    
    init(requester: Home_ViewController)
    {
        self.vc = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 80))
        self.backgroundColor = oficialDarkGray
//        self.barTintColor = oficialDarkGray

        
        self.searchButton = UIButton(frame: CGRectMake(10, 25, 50, 50))
        self.searchButton.setImage(UIImage(named: "searchButton"), forState: .Normal)
        self.searchButton.addTarget(self.vc, action: "clickOnSearch", forControlEvents: .TouchUpInside)
        self.addSubview(self.searchButton)
        
        
        //TESTANDO PULSE ANIMATION
//        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
//        pulseAnimation.duration = 1
//        pulseAnimation.fromValue = 0.1
//        pulseAnimation.toValue = 1
//        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        pulseAnimation.autoreverses = true
//        pulseAnimation.repeatCount = FLT_MAX
//        self.searchButton.layer.addAnimation(pulseAnimation, forKey: nil)

        
        self.toolsButton = BubbleButton(frame: CGRectMake(screenWidth - 64, 20, 50 , 50))
        self.toolsButton.setImage(UIImage(named: "icon_tools"), forState: .Normal)
        self.toolsButton.addTarget(self, action: "openTools", forControlEvents: .TouchUpInside)
     
        self.addSubview(self.toolsButton)

        self.toolsViewController = Tools_ViewController()
        
        self.alert = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        self.alert.backgroundColor = oficialRed
        self.alert.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alertOn", name: NotificationController.center.friendRequest.name, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alertOn", name: NotificationController.center.printScreenReceived.name, object: nil)

        
    }
    
//    func managerContact()
//    {
//        self.vc.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
//        self.vc.blurView.frame = self.vc.view.bounds
//        self.vc.blurView.alpha = 0
//        self.vc.view.addSubview(self.vc.blurView)
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            
//            self.vc.blurView.alpha = 0.8
//            
//            }) { (success: Bool) -> Void in
//                
//        }
//
//        self.contactManager = ContactManager_View()
//        self.vc.view.addSubview(self.contactManager)
//    }
    
    func openTools()
    {
        self.vc.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.vc.blurView.frame = self.vc.view.bounds
        self.vc.blurView.alpha = 0
        self.vc.closeSearch()
        self.vc.view.addSubview(self.vc.blurView)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.vc.blurView.alpha = 0.8
            
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
//            
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
        let count = DAOFriendRequests.sharedInstance.getRequests().count
        
        if(!self.animando && count > 0)
        {
            self.animando = true
            
            self.alert.hidden = false
            
            let pulseAnimation = CABasicAnimation(keyPath: "opacity")
            pulseAnimation.duration = 1
            pulseAnimation.fromValue = 0.1
            pulseAnimation.toValue = 1
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = FLT_MAX
            self.toolsButton.layer.addAnimation(pulseAnimation, forKey: "myAnimation")

        }
    }
    
    func alertOff()
    {
        self.animando = false
        self.alert.hidden = true

        self.toolsButton.layer.removeAnimationForKey("myAnimation")
    }

}
