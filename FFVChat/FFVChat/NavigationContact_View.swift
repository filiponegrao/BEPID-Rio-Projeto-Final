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
    
    var searchButton : UIButton!
    
    init(requester: Contacts_ViewController)
    {
        self.vc = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 60))
        self.backgroundColor = UIColor(netHex: 0x03bbff)
        
        self.configButton = UIButton(frame: CGRectMake(0, 20, 40, 40))
//        self.configButton.setTitle("Config", forState: .Normal)
//        self.configButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.configButton.setImage(UIImage(named: "icon_profile"), forState: .Normal)
        self.configButton.addTarget(self, action: "openConfig", forControlEvents: .TouchUpInside)
        self.addSubview(self.configButton)
        
        self.searchButton = UIButton(frame: CGRectMake(screenWidth-40, 20, 40, 40))
//        self.searchButton.setTitle("Search", forState: .Normal)
//        self.searchButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.searchButton.setImage(UIImage(named: "icon_search"), forState: .Normal)
        self.searchButton.addTarget(self, action: "openSearch", forControlEvents: .TouchUpInside)
        self.addSubview(self.searchButton)
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func openConfig()
    {
        
    }
    
    
    func openSearch()
    {
        let searchView = Search_View()
        searchView.contacts = vc
        vc.view.addSubview(searchView)
        searchView.insertView()
    }
    
    
    func openNotification()
    {
        
    }

}
