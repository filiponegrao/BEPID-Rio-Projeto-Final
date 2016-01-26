//
//  MessageAlertSettings_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 26/01/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class MessageAlertSettings_ViewController: UIViewController
{
    var tableView : UITableView!
    
    var navBar : UIView!
    
    var tittle : UILabel!
    
    var backButton : UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        self.navBar = UIView(frame: CGRectMake(0, 0, screenWidth, 70))
        self.navBar.backgroundColor = oficialDarkGray
        self.view.addSubview(self.navBar)
        
        self.tittle = UILabel(frame: CGRectMake(0, 25, screenWidth, 35))
        self.tittle.text = "Notifications"
        self.tittle.font = UIFont(name: "Sukhumvit Set", size: 22)
        self.tittle.textAlignment = .Center
        self.tittle.textColor = oficialGreen
        self.view.addSubview(self.tittle)
        
        self.backButton = UIButton(frame: CGRectMake(0, 20, 45, 45))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.backButton)
        


    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()

    }
    
    override func viewDidLayoutSubviews()
    {
        self.tittle.setSizeFont(22)
    }
    
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
