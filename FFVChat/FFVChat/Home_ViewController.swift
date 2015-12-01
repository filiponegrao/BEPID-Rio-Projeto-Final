//
//  Home_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/30/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Home_ViewController: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate
{
    var navigationBar : NavigationContact_View!
    
    var pageMenu : CAPSPageMenu!
    
    var favouritesController : FavouritesBubble_CollectionViewController!
    
    var contactsController : ContactsBubble_CollectionViewController!
    
    var chatController : Chat_ViewController!
    
    var controllerArray : [UIViewController]!
    
    var contentSize : CGSize!
    
    var background : UIImageView!
    
    var blurView : UIVisualEffectView!
    
    var searchBar : UISearchBar!
    
    let searchBarHeight : CGFloat = 40
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialDarkGray
        
        self.background = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.background.image = UIImage(named: "ContactBackground")
        self.background.alpha =  0.60
        self.view.addSubview(self.background)
        
        //Hidden search bar
        self.searchBar = UISearchBar(frame: CGRectMake(0, 0, screenWidth, self.searchBarHeight))
        self.searchBar.searchBarStyle = .Minimal
        self.searchBar.delegate = self
        self.searchBar.keyboardAppearance = .Dark
        self.view.addSubview(self.searchBar)
        
        //Nav Bar
        self.navigationBar = NavigationContact_View(requester: self)
        self.view.addSubview(self.navigationBar)
        
        
        self.contentSize = CGSizeMake(screenWidth, screenHeight - self.navigationBar.frame.size.height)
        
        let flowContacts = flowLayoutSetup()
        let flowFavourites = flowLayoutSetup()
        
        self.contactsController = ContactsBubble_CollectionViewController(collectionViewLayout: flowContacts, size: CGSize(width: screenWidth, height: self.contentSize.height))
        self.contactsController.home = self
        self.contactsController.title = "All Contacts"
        
        self.favouritesController = FavouritesBubble_CollectionViewController(collectionViewLayout: flowFavourites, size: CGSize(width: screenWidth, height: self.contentSize.height))
        self.favouritesController.home = self
        self.favouritesController.title = "Favourites"
        
        self.controllerArray = [self.contactsController, self.favouritesController]
        
        
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
        
        self.pageMenu = CAPSPageMenu(viewControllers: self.controllerArray, frame: CGRectMake(0, self.navigationBar.frame.size.height, self.contentSize.width, self.contentSize.height), pageMenuOptions: parameters)
        self.pageMenu.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.pageMenu.view)
        
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addNewContact", name: NotificationController.center.friendAdded.name, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self.contactsController, selector: "mesageReceived", name: NotificationController.center.messageReceived.name, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCellAnimations", name:UIApplicationWillEnterForegroundNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self.favouritesController, selector: "mesageReceived", name: NotificationController.center.messageReceived.name, object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "", name: NotificationController.center.printScreenReceived.name, object: nil)
        
    }
    
    
    func reloadCellAnimations()
    {
//        self.allContacts.reloadAnimations()
//        self.favourites.reloadAnimations()
    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        DAOFriendRequests.sharedInstance.friendsAccepted()
        DAOPostgres.sharedInstance.startObserve()
        
        self.favouritesController.reloadAnimations()
        self.favouritesController.checkUnreadMessages()
        self.contactsController.reloadAnimations()
        self.contactsController.checkUnreadMessages()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationController.center.friendAdded.name, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self.contactsController, name: NotificationController.center.messageReceived.name, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self.favouritesController, name: NotificationController.center.messageReceived.name, object: nil)
        
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationController.center.printScreenReceived.name, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        DAOPostgres.sharedInstance.stopObserve()
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
    
    func clickOnSearch()
    {
        if(self.searchBar.isFirstResponder())
        {
            self.closeSearch()
        }
        else
        {
            self.openSearch()
        }
    }
    

    func openSearch()
    {
        self.searchBar.text = nil
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.searchBar.frame.origin.y = self.navigationBar.frame.size.height
            self.pageMenu.view.frame.origin.y = self.navigationBar.frame.size.height + self.searchBar.frame.size.height
            
            }) { (success: Bool) -> Void in
                
                self.searchBar.becomeFirstResponder()
        }
    }
    
    func closeSearch()
    {
        self.searchBar.resignFirstResponder()
        self.contactsController.contacts = DAOContacts.sharedInstance.getAllContacts()
        self.contactsController.resultContacts = self.contactsController.contacts
        self.contactsController.collectionView?.reloadData()
        self.contactsController.reloadAnimations()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.searchBar.frame.origin.y = self.navigationBar.frame.size.height - self.searchBarHeight
            self.pageMenu.view.frame.origin.y = self.navigationBar.frame.size.height
            
            }) { (success: Bool) -> Void in
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        self.contactsController.resultContacts = self.contactsController.contacts
        self.contactsController.collectionView?.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.contactsController.resultContacts = DAOContacts.sharedInstance.getContactsWithString(searchText)
        print(self.contactsController.resultContacts.count)
        self.contactsController.collectionView?.reloadData()
        
    }
}




