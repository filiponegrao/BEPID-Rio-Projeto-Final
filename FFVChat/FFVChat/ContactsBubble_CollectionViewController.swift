//
//  ContactsBubble_CollectionViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/13/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ContactsBubble_CollectionViewController: UICollectionViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate
{
    let transition = BubbleTransition()

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
        self.longPress.minimumPressDuration = 0.5
        self.longPress.delaysTouchesBegan = true
        self.longPress.delegate = self
        self.view.addGestureRecognizer(self.longPress)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadContacts", name: NotificationController.center.friendAdded.name, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadAnimations", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkUnreadMessages", name: NotificationController.center.messageReceived.name, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contactsRefreshed", name: NotificationController.center.contactsRefresheded.name, object: nil)

    }
    
    override func viewDidDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationController.center.friendAdded.name, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationController.center.messageReceived.name, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationController.center.contactsRefresheded.name, object: nil)

    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        self.reloadAnimations()
        DAOContacts.sharedInstance.refreshContacts()
        DAOFriendRequests.sharedInstance.friendsAccepted()
        self.checkUnreadMessages()
    }
    
    func reloadAnimations()
    {
        for i in 0..<self.collectionView!.numberOfItemsInSection(0)
        {
            let cell = self.collectionView!.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as! RandomWalk_CollectionViewCell
            cell.profileBtn.layer.removeAllAnimations()
            cell.startAnimation()
        }
    }
    
    
    
    override func viewDidLayoutSubviews()
    {
        self.navigationBar.filterButtons.titleLabel?.font = self.navigationBar.filterButtons.titleLabel?.font.fontWithSize(22)
//        self.navigationBar.filterButtons.titleLabel?.font = UIFont(name: "Sukhumvit Set", size: 40)
    }

    
    func reloadContacts()
    {
        self.contacts = DAOContacts.sharedInstance.getAllContacts()
        
        let index = self.contacts.indexOf(DAOContacts.sharedInstance.lastContactAdded)!

        self.collectionView!.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "reloadAnimations", userInfo: nil, repeats: false)
    }
    
    
    func contactsRefreshed()
    {
        self.contacts = DAOContacts.sharedInstance.getAllContacts()
        var i = 0
        for contact in self.contacts
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as? RandomWalk_CollectionViewCell
            cell?.profileBtn.setImage(UIImage(data: self.contacts[i].profileImage), forState: .Normal)
            i++
        }
    }
    
    
    func checkUnreadMessages()
    {
        var i = 0
        for contact in self.contacts
        {
            let count = DAOMessages.sharedInstance.numberOfUnreadMessages(contact)
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as? RandomWalk_CollectionViewCell
            cell?.setUnreadMessages(count)
            i++
        }
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
        
        cell.contactsController = self
        cell.profileBtn.tag = indexPath.row
        cell.setInfo(self.contacts[indexPath.row].username, profile: UIImage(data: contacts[indexPath.row].profileImage!)!)
        
        cell.loadAnimations(45)
        // Configure the cell
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
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
            let frame = CGRectMake(cell!.frame.origin.x, cell!.frame.origin.y + 70, cell!.frame.size.width, cell!.frame.size.height)
            self.contactManager = ContactManager_View(contact: self.contacts[(indexPath?.item)!], requester: self, origin: frame)
            
            self.view.addSubview(self.contactManager)
            self.contactManager.insertView()
        }
    }
    
    func openChat(sender: UIButton)
    {
        let index = sender.tag
        let chat = Chat_ViewController()
        chat.contact = self.contacts[index]
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(0.5) * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.navigationController?.pushViewController(chat, animated: true)
        }
    }
    
    
    //******* TRANSITIONS ********
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        transition.transitionMode = .Present
        transition.startingPoint = self.view.center
        transition.bubbleColor = oficialMediumGray
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        transition.transitionMode = .Dismiss
        transition.startingPoint = self.view.center
        transition.bubbleColor = oficialMediumGray
        return transition
    }
    
}


