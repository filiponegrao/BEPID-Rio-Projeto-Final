//
//  NavigationContact_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class NavigationContact_View: UIView {

    var vc : Contacts_ViewController!
    
    var configButton : UIButton!
    
    var notificationsButton : UIButton!
    
    init(requester: Contacts_ViewController)
    {
        self.vc = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 60))
        self.backgroundColor = UIColor(netHex: 0x03bbff)
        
        self.configButton = UIButton(frame: CGRectMake(0, 20, 40, 40))

        self.configButton.setImage(UIImage(named: "icon_config"), forState: .Normal)
        self.configButton.addTarget(self, action: "openConfig", forControlEvents: .TouchUpInside)
        self.addSubview(self.configButton)
        
        self.notificationsButton = UIButton(frame: CGRectMake(screenWidth-40, 20, 40, 40))

        self.notificationsButton.setImage(UIImage(named: "icon_bell"), forState: .Normal)
        self.addSubview(self.notificationsButton)
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func openConfig()
    {
        
    }
    
    
    func openNotification()
    {
        
    }

}
