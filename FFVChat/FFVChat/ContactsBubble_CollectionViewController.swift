//
//  ContactsBubble_CollectionViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/13/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ContactsBubble_CollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate
{
    var contacts = [Contact]()
    
    var navigationBar : NavigationContact_View!
    
    var blurView : UIVisualEffectView!
    
    var longPress : UILongPressGestureRecognizer!
    
    var contactManager : ContactManager_View!
    
    
    override init(collectionViewLayout layout: UICollectionViewLayout)
    {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        self.collectionView?.frame = CGRectMake(0, 40, self.view.frame.width, self.view.frame.height - 40)
        
        super.viewDidLoad()

        
        //Nav Bar
        self.navigationBar = NavigationContact_View(requester: self)
        self.view.addSubview(self.navigationBar)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.registerClass(RandomWalk_CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.backgroundColor = oficialMediumGray
        
        self.contacts = DAOContacts.sharedInstance.getAllContacts()

        self.longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        self.longPress.minimumPressDuration = 0.6
        self.longPress.delaysTouchesBegan = true
        self.longPress.delegate = self
        self.view.addGestureRecognizer(self.longPress)
        
//        setupNavBar()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadContacts", name: NotificationController.center.friendAdded.name, object: nil)
        
        DAOFriendRequests.sharedInstance.friendsAccepted()

    }
    
    override func viewDidDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationController.center.friendAdded.name, object: nil)
    }
    
    override func viewDidLayoutSubviews()
    {
        self.navigationBar.filterButtons.titleLabel?.font = self.navigationBar.filterButtons.titleLabel?.font.fontWithSize(22)
//        self.navigationBar.filterButtons.titleLabel?.font = UIFont(name: "Sukhumvit Set", size: 40)

    }
    
//    func setupNavBar()
//    {
//        self.navigationController?.navigationBarHidden = false
//        let navBar = self.navigationController?.navigationBar
//        
//        navBar?.barTintColor = oficialDarkGray
//        navBar?.tintColor = oficialGreen
//        //navBar?.titleTextAttributes = [NSForegroundColorAttributeName: oficialGreen]
//        
//        //let favoritBtn = UIButton()
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Favourites", style: .Plain, target: self, action: "filterContacts")
//        
//        let img = UIImage()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: img, style: .Plain, target: self, action: "goToMenu")
//    }
    
    func reloadContacts()
    {
        self.contacts = DAOContacts.sharedInstance.getAllContacts()
        
        let index = self.contacts.indexOf(DAOContacts.sharedInstance.lastContactAdded)!

        self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
        
    }
    
    func filterContacts()
    {
        print("filter")
    }
    
    func goToMenu()
    {
        print("menu")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of items
        return contacts.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RandomWalk_CollectionViewCell
        
        cell.setInfo(self.contacts[indexPath.row].username, profile: UIImage(data: contacts[indexPath.row].profileImage!)!)
        
        cell.startAnimation(45)
        // Configure the cell
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let chat = Chat_ViewController(nibName: "Chat_ViewController", bundle: nil)
        chat.contact = self.contacts[indexPath.item]
        self.navigationController?.pushViewController(chat, animated: true)

    }
   
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer)
    {
        if gestureReconizer.state != UIGestureRecognizerState.Ended
        {
            return
        }
        
        let point = gestureReconizer.locationInView(self.collectionView)
        let indexPath = self.collectionView?.indexPathForItemAtPoint(point)
        
        if ((indexPath) != nil)
        {
            let cell = self.collectionView!.cellForItemAtIndexPath(indexPath!)
//            cell?.blur(blurRadius: 0.7)
            //Dar feedback ao usuário

            
//            cell?.blur(blurRadius: 0)
            
            print("ALGUMA COISA ANTES \(indexPath!.item)")
            print(self.contacts.count)
            print("INDEX DA CELL \(indexPath)")
            self.contactManager = ContactManager_View(contact: self.contacts[indexPath!.item])
            
            
            self.view.addSubview(self.contactManager)
            //            print(indexPath!.row)
            

        }
        else
        {
            print("Could not find index path")
        }
    }
    
}
