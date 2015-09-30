//
//  NavigationContact_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class NavigationContact_View: UIView {

    var vc : UIViewController!
    
    init(requester: UIViewController)
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, 60))
        self.backgroundColor = UIColor.grayColor()
        
        let searchButton = UIButton(frame: CGRectMake(screenWidth-50, 10, 40, 40))
        searchButton.setImage(UIImage(named: "icon_search"), forState: .Normal)
        searchButton.addTarget(self, action: "openSearch", forControlEvents: .TouchUpInside)
        self.addSubview(searchButton)
        
        let configButton = UIButton(frame: CGRectMake(10, 10, 40, 40))
        configButton.setImage(UIImage(named: "icon_profile"), forState: .Noraml)
        configButton.addTarget(self, action: "openConfig", forControlEvents: .TouchUpInside)
        self.addSubview(configButton)
        
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func openSearch()
    {
        
    }
    
    
    func openConfig()
    {
        
    }
    
    
    func openNotification()
    {
        
    }

}
