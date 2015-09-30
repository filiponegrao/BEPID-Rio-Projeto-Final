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
        self.vc = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 60))
        self.backgroundColor = UIColor.grayColor()
        
        let searchButton = UIButton(frame: CGRectMake(screenWidth-50, 20, 30, 30))
        searchButton.setImage(UIImage(named: "icon_search"), forState: .Normal)
        searchButton.addTarget(self, action: "openSearch", forControlEvents: .TouchUpInside)
        self.addSubview(searchButton)
        
        let configButton = UIButton(frame: CGRectMake(10, 20, 30, 30))
        configButton.setImage(UIImage(named: "icon_profile"), forState: .Normal)
        configButton.addTarget(self, action: "openConfig", forControlEvents: .TouchUpInside)
        self.addSubview(configButton)
        
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func openSearch()
    {
        let search = Search_View()
        vc.view.addSubview(search)
        search.animateView()
        
    }
    
    
    func openConfig()
    {
        
    }
    
    
    func openNotification()
    {
        
    }

}
