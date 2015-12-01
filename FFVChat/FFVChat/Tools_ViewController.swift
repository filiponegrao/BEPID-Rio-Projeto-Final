//
//  Tools_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 06/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Tools_ViewController: UIViewController
{
    var contacts : Home_ViewController!
    
    var blackScreen : UIView!
    
    var notificationButton: UIButton!
    
    var notificationLabel : UIButton!
    
    var addButton : UIButton!
    
    var addLabel : UIButton!
    
    var configButton : UIButton!
    
    var configLabel : UIButton!
    
    var closeButton : UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.hidden = true
        self.title = " "
        
        self.blackScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0
        self.view.addSubview(self.blackScreen)
        
        self.notificationButton = UIButton(frame: CGRectMake(screenWidth - 80, 20, 80, 80))
        self.notificationButton.setImage(UIImage(named: "notificationButton"), forState: .Normal)
        self.notificationButton.addTarget(self, action: "presentNotificationsController", forControlEvents: .TouchUpInside)
        self.notificationButton.alpha = 0
        self.view.addSubview(self.notificationButton)
        
        self.notificationLabel = UIButton(frame: CGRectMake(60, 20, screenWidth/2, 30))
        self.notificationLabel.setTitle("Notifications", forState: .Normal)
        self.notificationLabel.alpha = 0
//        self.notificationLabel.backgroundColor = UIColor.whiteColor()
        self.notificationLabel.setTitleColor(oficialGreen, forState: .Normal)
        self.notificationLabel.titleLabel?.font = UIFont(name: "Sukhumvit Set", size: 25)
        self.notificationLabel.titleLabel?.setSizeFont(25)
        self.notificationLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.notificationLabel.addTarget(self, action: "presentNotificationsController", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.notificationLabel)
        
        self.addButton = UIButton(frame: CGRectMake(screenWidth - 80, 20, 80, 80))
        self.addButton.setImage(UIImage(named: "addButton"), forState: .Normal)
        self.addButton.addTarget(self, action: "presentAddController", forControlEvents: .TouchUpInside)
        self.addButton.alpha = 0
        self.view.addSubview(self.addButton)
        
        self.addLabel = UIButton(frame: CGRectMake(60, 20, screenWidth/2, 30))
        self.addLabel.setTitle("Add contact", forState: .Normal)
        self.addLabel.alpha = 0
//        self.addLabel.backgroundColor = UIColor.whiteColor()
        self.addLabel.setTitleColor(oficialGreen, forState: .Normal)
        self.addLabel.titleLabel?.font = UIFont(name: "Sukhumvit Set", size: 25)
        self.addLabel.titleLabel?.setSizeFont(25)
        self.addLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.addLabel.addTarget(self, action: "presentAddController", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.addLabel)
        
        self.configButton = UIButton(frame: CGRectMake(screenWidth - 80, 20, 80, 80))
        self.configButton.setImage(UIImage(named: "settingsButton"), forState: .Normal)
        self.configButton.alpha = 0
        self.configButton.addTarget(self, action: "showSettings", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.configButton)
        
        self.configLabel = UIButton(frame: CGRectMake(60, 20, screenWidth/2, 30))
        self.configLabel.setTitle("Settings", forState: .Normal)
        self.configLabel.alpha = 0
//        self.configLabel.backgroundColor = UIColor.whiteColor()
        self.configLabel.setTitleColor(oficialGreen, forState: .Normal)
        self.configLabel.titleLabel?.font = UIFont(name: "Sukhumvit Set", size: 25)
        self.configLabel.titleLabel?.setSizeFont(25)
        self.configLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.configLabel.addTarget(self, action: "showSettings", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.configLabel)
        
        self.closeButton = UIButton(frame: CGRectMake(screenWidth - 80, 20, 80 , 80))
        self.closeButton.setImage(UIImage(named: "closeButton"), forState: .Normal)
        self.closeButton.addTarget(self, action: "closeTools", forControlEvents: .TouchUpInside)
        self.closeButton.frame.origin.y = 6
        self.closeButton.alpha = 0
        self.view.addSubview(self.closeButton)
        
        self.blackScreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "closeTools"))
        
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBar.hidden = true
    }
    
    func openTools()
    {
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.blackScreen.alpha = 0.8
            self.closeButton.alpha = 1
            
            self.notificationButton.frame.origin.y = screenHeight*1/4
            self.notificationButton.alpha = 1
            
            self.addButton.frame.origin.y = screenHeight/2
            self.addButton.alpha = 1
            
            self.configButton.frame.origin.y = screenHeight*3/4
            self.configButton.alpha = 1
            
            self.notificationLabel.center.y = self.notificationButton.center.y
            self.notificationLabel.alpha = 1
            
            self.addLabel.center.y = self.addButton.center.y
            self.addLabel.alpha = 1
            
            self.configLabel.center.y = self.configButton.center.y
            self.configLabel.alpha = 1

            
            }, completion: nil)
        
//        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//            
//            
//            }) { (success) -> Void in
//                
//        }
    }
    
    func closeTools()
    {
        self.notificationLabel.alpha = 0
        self.addLabel.alpha = 0
        self.configLabel.alpha = 0
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            
            self.blackScreen.alpha = 0
            self.closeButton.alpha = 0

            self.notificationButton.frame.origin.y = 6
            self.addButton.frame.origin.y = 6
            self.configButton.frame.origin.y = 6
            
            self.contacts.blurView.alpha = 0
            
            }) { (success) -> Void in
                
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.contacts.blurView.removeFromSuperview()
                })
                
        }

    }
    
    
    //going to settings
    func showSettings()
    {
        let settingsController = Settings_ViewController()
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    //***  PRESENTING FUNCTIONS *****//
    
    func presentAddController()
    {
        let addController = AddContact_ViewController()
        self.navigationController?.pushViewController(addController, animated: true)
    }
    
    
    func presentNotificationsController()
    {
        let notifiController = Notifications_ViewController()
        self.navigationController?.pushViewController(notifiController, animated: true)
    }
    
    //**** END PRESENTING FUNCTIONS   ******//

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


}
