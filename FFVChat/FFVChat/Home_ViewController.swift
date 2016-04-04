//
//  Home_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/30/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Home_ViewController: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate, CAPSPageMenuDelegate
{
    var navigationBar : NavigationContact_View!
    
    var pageMenu : CAPSPageMenu!
    
    var favouritesController : FavouritesBubble_CollectionViewController!
    
    var contactsController : ContactsBubble_CollectionViewController!
    
    var chatController : Chat_ViewController!
    
    var controllerArray : [UIViewController]!
    
    var contentSize : CGSize!
    
    var background : UIImageView!
    
    var searchBar : UISearchBar!
    
    var searchBarView : UIView!
    
    let searchBarHeight : CGFloat = 40
    
    var isSearching : Bool = false
    
    var blackScreen : UIView!
    
    var blurView : UIVisualEffectView!
    
    var closeButton : UIButton!
    
    var chatLabel : UILabel!
    
    var managerLabel : UILabel!
    
    var clickImage : UIImageView!
    
    var pressImage : UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialDarkGray
        
        self.background = UIImageView(frame: CGRectMake(-10, 10, screenWidth+20, screenHeight+20))
        self.background.image = UIImage(named: "ContactBackground")
        self.background.alpha = 0.60
        self.view.addSubview(self.background)
        Optimization.addParallaxToView(self.background)
        
        
//        for family: String in UIFont.familyNames()
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNamesForFamilyName(family)
//            {
//                print("== \(names)")
//            }
//        }
//        
        
        
        //Nav Bar
        self.navigationBar = NavigationContact_View(requester: self)
        self.view.addSubview(self.navigationBar)
        
        self.contentSize = CGSizeMake(screenWidth, screenHeight - self.navigationBar.frame.size.height)
        let flowContacts = flowLayoutSetup()
        let flowFavourites = flowLayoutSetup()
        
        
        //Contacts
        self.contactsController = ContactsBubble_CollectionViewController(collectionViewLayout: flowContacts, size: CGSize(width: screenWidth, height: self.contentSize.height))
        self.contactsController.home = self
        self.contactsController.title = "All Contacts"
        Optimization.addInverseParallaxToView(self.contactsController.collectionView!)
        let tap = UITapGestureRecognizer(target: self, action: "closeSearch")
        self.contactsController.collectionView?.addGestureRecognizer(tap)
        
        
        //Favourites
        self.favouritesController = FavouritesBubble_CollectionViewController(collectionViewLayout: flowFavourites, size: CGSize(width: screenWidth, height: self.contentSize.height))
        self.favouritesController.home = self
        self.favouritesController.title = "Favorites"
        let tap2 = UITapGestureRecognizer(target: self, action: "closeSearch")
        self.favouritesController.collectionView?.addGestureRecognizer(tap2)
        self.controllerArray = [self.contactsController, self.favouritesController]
        
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(oficialMediumGray),
            .ViewBackgroundColor(oficialMediumGray),
            .SelectionIndicatorColor(oficialGreen),
            .BottomMenuHairlineColor(oficialLightGray),
            .MenuItemFont(UIFont(name: "SukhumvitSet-Medium", size: 16.0)!),
            .MenuHeight(40.0),
            .MenuItemWidth(screenWidth/2),
            .CenterMenuItems(true),
            .SelectedMenuItemLabelColor(oficialGreen),
            .UnselectedMenuItemLabelColor(oficialLightGray),
            .MenuMargin(0)
        ]
        
        self.pageMenu = CAPSPageMenu(viewControllers: self.controllerArray, frame: CGRectMake(0, self.navigationBar.frame.size.height, self.contentSize.width, self.contentSize.height), pageMenuOptions: parameters)
        self.pageMenu.view.backgroundColor = UIColor.clearColor()
        self.pageMenu.delegate = self
//        self.pageMenu.scrollAnimationDurationOnMenuItemTap = 0.3
        self.view.addSubview(self.pageMenu.view)
        
        
        //Hidden search bar
        self.searchBar = UISearchBar(frame: CGRectMake(10, 0, screenWidth - 20, self.searchBarHeight))
        self.searchBar.searchBarStyle = .Minimal
        self.searchBar.delegate = self
        self.searchBar.keyboardAppearance = .Dark
        self.searchBar.placeholder = "Search for a username"
        self.searchBar.tintColor = oficialGreen
        
        //cor do texto
        let textFieldInsideSearchBar = self.searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = oficialLightGray
        textFieldInsideSearchBar?.tintColor = oficialGreen
        textFieldInsideSearchBar?.font = UIFont(name: "SukhumvitSet-Light", size: 14)
        
        self.searchBarView = UIView(frame: CGRectMake(0,0,screenWidth, self.searchBarHeight))
        self.searchBarView.frame.size.height += 2
        self.searchBarView.backgroundColor = oficialMediumGray
        self.view.addSubview(self.searchBarView)
        self.view.addSubview(self.searchBar)
        
        self.view.bringSubviewToFront(self.navigationBar)
        
        NSNotificationCenter.defaultCenter().addObserver(self.contactsController, selector: "addNewContact", name: NotificationController.center.friendAdded.name, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCellAnimations", name:UIApplicationWillEnterForegroundNotification, object: nil)
        
        self.reloadCellAnimations()
        
        //para primeiro uso
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.blurView.frame = self.view.bounds
        self.blurView.alpha = 0
        self.view.addSubview(self.blurView)
        
        self.blackScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0
        self.view.addSubview(self.blackScreen)
        
        self.closeButton = UIButton(frame: CGRectMake(0, 25, 44, 44))
        self.closeButton.setImage(UIImage(named: "close"), forState: .Normal)
        self.closeButton.alpha = 0
        self.closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview((self.closeButton))
        
        self.clickImage = UIImageView(frame: CGRectMake(screenWidth/4, screenHeight/7, screenWidth/2, screenWidth/2))
        self.clickImage.image = UIImage(named: "clickImg")
        self.clickImage.alpha = 0
        self.view.addSubview(self.clickImage)
        
        self.chatLabel = UILabel(frame: CGRectMake(screenWidth/6, self.clickImage.frame.origin.y + self.clickImage.frame.size.height - 20, screenWidth/6 * 4, screenHeight/7))
        self.chatLabel.text = "Click to open chat"
        self.chatLabel.textColor = UIColor.whiteColor()
        self.chatLabel.font = UIFont(name: "SukhumvitSet-Text", size: 22)
        self.chatLabel.textAlignment = .Center
        self.chatLabel.alpha = 0
        self.view.addSubview(self.chatLabel)
        
        self.pressImage = UIImageView(frame: CGRectMake(screenWidth/4, self.chatLabel.frame.origin.y + self.chatLabel.frame.size.height, screenWidth/2, screenWidth/2))
        self.pressImage.image = UIImage(named: "pressImg")
        self.pressImage.alpha = 0
        self.view.addSubview(self.pressImage)
        
        self.managerLabel = UILabel(frame: CGRectMake(screenWidth/6, self.pressImage.frame.origin.y + self.pressImage.frame.size.height - 20, screenWidth/6 * 4, screenHeight/7))
        self.managerLabel.text = "Press to manager"
        self.managerLabel.textColor = UIColor.whiteColor()
        self.managerLabel.font = UIFont(name: "SukhumvitSet-Text", size: 22)
        self.managerLabel.textAlignment = .Center
        self.managerLabel.alpha = 0
        self.view.addSubview(self.managerLabel)
        
        //se é o primeiro uso
                let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
        
                if launchedBefore
                {
                    print("Not first launch.")
                }
                else
                {
                    print("First launch, setting NSUserDefault.")
        
                    UIView.animateWithDuration(0.6, delay: 0.3, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                        
                        self.blurView.alpha = 0.8
                        self.blackScreen.alpha = 0.8
                        self.closeButton.alpha = 1
                        
                        }, completion: { (true) in
                            
                            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
                                
                                self.chatLabel.alpha = 1
                                self.managerLabel.alpha = 1
                                self.clickImage.alpha = 1
                                self.pressImage.alpha = 1
                                
                                }, completion: nil)
                            
                    })

                    
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
                }
        
    }
    
    
    
    func reloadCellAnimations()
    {
        self.contactsController.reloadAnimations()
        self.favouritesController.reloadAnimations()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        DAOPostgres.sharedInstance.startObserve()
        
        NSNotificationCenter.defaultCenter().addObserver(self.contactsController, selector: "mesageReceived", name: FTNChatNotifications.newMessage(), object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self.favouritesController, selector: "mesageReceived", name: FTNChatNotifications.newMessage(), object: nil)
        
    }
    
    
    override func viewDidDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self.contactsController, name: FTNChatNotifications.newMessage(), object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self.favouritesController, name: FTNChatNotifications.newMessage(), object: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if(self.isSearching)
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
        self.isSearching = true
        self.searchBar.text = nil
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.searchBarView.frame.origin.y = self.navigationBar.frame.size.height
            
            self.searchBar.frame.origin.y = self.navigationBar.frame.size.height
            
            }) { (success: Bool) -> Void in
                
                self.searchBar.becomeFirstResponder()
        }
    }
    
    func closeSearch()
    {
        if(self.isSearching)
        {
            self.isSearching = false
            self.searchBar.resignFirstResponder()
            self.contactsController.contacts = DAOContacts.sharedInstance.getAllContacts()
            self.contactsController.collectionView?.reloadData()
            self.favouritesController.favourites = DAOContacts.sharedInstance.getFavorites()
            self.favouritesController.collectionView?.reloadData()
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.searchBar.frame.origin.y = self.navigationBar.frame.size.height - self.searchBarHeight
                self.searchBarView.frame.origin.y = self.navigationBar.frame.size.height - self.searchBarHeight
                
                //            self.pageMenu.view.frame.origin.y = self.navigationBar.frame.size.height
                
                }) { (success: Bool) -> Void in
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.closeSearch()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        self.contactsController.contacts = self.contactsController.contacts
        self.contactsController.collectionView?.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        if(searchText == "")
        {
            self.contactsController.contacts = DAOContacts.sharedInstance.getAllContacts()
            self.contactsController.collectionView?.reloadData()
            self.favouritesController.favourites = DAOContacts.sharedInstance.getFavorites()
            self.favouritesController.collectionView?.reloadData()
        }
        else
        {
            self.contactsController.contacts = DAOContacts.sharedInstance.getContactsWithString(searchText)
            self.contactsController.collectionView?.reloadData()
            self.favouritesController.favourites = DAOContacts.sharedInstance.getFavouritesWithString(searchText)
            self.favouritesController.collectionView?.reloadData()
        }
        
    }
    
    /******************************************/
    /******** Page Menu Delegate **************/
    /******************************************/
    
    func didMoveToPage(controller: UIViewController, index: Int)
    {
//        self.closeSearch()
    }
    
    
    func close()
    {
        UIView.animateWithDuration(0.6, delay: 0.3, options: .CurveEaseOut, animations: { 
            
            self.closeButton.alpha = 0
            self.chatLabel.alpha = 0
            self.managerLabel.alpha = 0
            self.clickImage.alpha = 0
            self.pressImage.alpha = 0
            
            }) { (true) in
                
                self.closeButton.removeFromSuperview()
                self.chatLabel.removeFromSuperview()
                self.managerLabel.removeFromSuperview()
                self.clickImage.removeFromSuperview()
                self.pressImage.removeFromSuperview()
                self.blackScreen.removeFromSuperview()
                self.blurView.removeFromSuperview()

        }
        
    }

}




