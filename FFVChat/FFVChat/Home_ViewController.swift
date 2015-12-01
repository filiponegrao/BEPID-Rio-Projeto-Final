//
//  Home_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/30/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Home_ViewController: UIViewController
{
    var navigationBar : NavigationContact_View!
    
    var pageMenu : CAPSPageMenu!
    
    var favourites : FavouritesBubble_CollectionViewController!
    
    var allContacts : ContactsBubble_CollectionViewController!
    
    var chatController : Chat_ViewController!
    
    var controllerArray : [UIViewController]!
    
    var contentSize : CGSize!
    
    var background : UIImageView!
    
    var blurView : UIVisualEffectView!
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialDarkGray
        
        self.background = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.background.image = UIImage(named: "ContactBackground")
        self.background.alpha =  0.5
        self.view.addSubview(self.background)
        
        //Nav Bar
        self.navigationBar = NavigationContact_View(requester: self)
        self.view.addSubview(self.navigationBar)
        
        
        self.contentSize = CGSizeMake(screenWidth, screenHeight - self.navigationBar.frame.size.height)
        
        let flow = flowLayoutSetup()
        
        self.allContacts = ContactsBubble_CollectionViewController(collectionViewLayout: flow, size: CGSize(width: screenWidth, height: self.contentSize.height))
        self.allContacts.home = self
        self.allContacts.title = "All Contacts"
        
        self.favourites = FavouritesBubble_CollectionViewController(collectionViewLayout: flow, size: CGSize(width: screenWidth, height: self.contentSize.height))
        self.favourites.home = self
        self.favourites.title = "Favourites"
        
        self.controllerArray = [self.allContacts, self.favourites]
        
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(oficialMediumGray),
            .ViewBackgroundColor(oficialMediumGray),
            .SelectionIndicatorColor(oficialGreen),
            .BottomMenuHairlineColor(oficialLightGray),
            .MenuItemFont(UIFont(name: "Helvetica", size: 16.0)!),
            .MenuHeight(40.0),
            .MenuItemWidth(screenWidth/2),
            .CenterMenuItems(true),
            .SelectedMenuItemLabelColor(oficialGreen),
            .UnselectedMenuItemLabelColor(oficialLightGray),
            .MenuMargin(0)
        ]
        
        self.pageMenu = CAPSPageMenu(viewControllers: self.controllerArray, frame: CGRectMake(0, 80, self.contentSize.width, self.contentSize.height), pageMenuOptions: parameters)
        self.pageMenu.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.pageMenu.view)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews()
    {
        
    }
    

    func flowLayoutSetup() -> UICollectionViewFlowLayout
    {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        let dimension:CGFloat = self.view.frame.width * 0.23
        let labelHeight:CGFloat = 30
        flowLayout.itemSize = CGSize(width: dimension, height: dimension + labelHeight)
        
        flowLayout.sectionInset = UIEdgeInsets(top: 50, left: 30, bottom: 10, right: 30)
        flowLayout.minimumLineSpacing = 20.0
        
        return flowLayout
    }


}
