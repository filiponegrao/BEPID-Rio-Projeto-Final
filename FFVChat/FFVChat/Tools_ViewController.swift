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

    var blackScreen : UIView!
    
    var addButton : UIButton!
    
    var notificationButton: UIButton!
    
    var configButton : UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.hidden = true
        
        self.blackScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0
        self.view.addSubview(self.blackScreen)
        
        self.notificationButton = UIButton(frame: CGRectMake(screenWidth - 80, 20, 80, 80))
        self.notificationButton.setImage(UIImage(named: "notificationButton"), forState: .Normal)
        self.notificationButton.alpha = 0
        self.view.addSubview(self.notificationButton)
        
        self.addButton = UIButton(frame: CGRectMake(screenWidth - 80, 20, 80, 80))
        self.addButton.setImage(UIImage(named: "addButton"), forState: .Normal)
        self.addButton.addTarget(self, action: "presentAddController", forControlEvents: .TouchUpInside)
        self.addButton.alpha = 0
        self.view.addSubview(self.addButton)
        
        self.configButton = UIButton(frame: CGRectMake(screenWidth - 80, 20, 80, 80))
        self.configButton.setImage(UIImage(named: "settingsButton"), forState: .Normal)
        self.configButton.alpha = 0
        self.view.addSubview(self.configButton)
        
        
        self.blackScreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "closeTools"))
        
    }
    
    func openTools()
    {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.blackScreen.alpha = 0.7
            self.notificationButton.frame.origin.y = screenHeight*1/4
            self.addButton.frame.origin.y = screenHeight/2
            self.configButton.frame.origin.y = screenHeight*3/4
            self.configButton.alpha = 1
            self.addButton.alpha = 1
            self.notificationButton.alpha = 1
            
            }) { (success) -> Void in
                
        }
    }
    
    func closeTools()
    {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            
            self.blackScreen.alpha = 0
            self.notificationButton.frame.origin.y = 20
            self.addButton.frame.origin.y = 20
            self.configButton.frame.origin.y = 20
            self.view.unBlur()
            
            }) { (success) -> Void in
                
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
                
        }

    }
    
    //***  PRESENTING FUNCTIONS *****//
    
    func presentAddController()
    {
        let addController = AddContact_ViewController()
        self.navigationController?.pushViewController(addController, animated: true)
    }
    
    
    //**** END PRESENTING FUNCTIONS   ******//

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


}
