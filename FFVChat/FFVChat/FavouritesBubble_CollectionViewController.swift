//
//  FavouritesBubble_CollectionViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/30/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CellFavourites"

class FavouritesBubble_CollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate
{
    weak var home : Home_ViewController!
    
    var favourites = [Contact]()
    
    var blurView : UIVisualEffectView!
    
    var longPress : UILongPressGestureRecognizer!
    
    var contactManager : ContactManager_View!
    
    var background : UIImageView!
    
    weak var chatController : Chat_ViewController!
    
    var collectionSize : CGSize!
    
    init(collectionViewLayout layout: UICollectionViewLayout, size: CGSize)
    {
        self.collectionSize = size
        super.init(collectionViewLayout: layout)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        self.collectionView!.frame = CGRectMake(0, -10, self.collectionSize.width , self.collectionSize.height + 10)
        
        self.view.backgroundColor = UIColor.clearColor()
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.registerClass(RandomWalk_CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.backgroundColor = UIColor.clearColor()
        
        self.longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        self.longPress.minimumPressDuration = 0.5
        self.longPress.delaysTouchesBegan = true
        self.longPress.delegate = self
        self.view.addGestureRecognizer(self.longPress)
        
        self.favourites = DAOContacts.sharedInstance.getFavorites()
        self.collectionView!.reloadData()
        
        
    }
    
    
    //** FUNCOES DE ATUALIZACAO DA TELA ***//
    
    func addNewContact()
    {
        self.favourites = DAOContacts.sharedInstance.getAllContacts()
        
        let index = self.favourites.indexOf(DAOContacts.sharedInstance.lastContactAdded)!
        
        self.collectionView!.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
    }
    
    
    func checkUnreadMessages()
    {
        for i in 0..<self.collectionView!.numberOfItemsInSection(0)
        {
            let cell = self.collectionView!.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as? RandomWalk_CollectionViewCell
            let contact = self.favourites[i]
            let cont = DAOMessages.sharedInstance.numberOfUnreadMessages(contact)
            cell?.profileBtn.setImage(UIImage(data: self.favourites[i].profileImage!) , forState: .Normal)
            cell?.setUnreadMessages(cont)
        }
    }
    
    func reloadAnimations()
    {
        for i in 0..<self.collectionView!.numberOfItemsInSection(0)
        {
            let cell = self.collectionView!.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as? RandomWalk_CollectionViewCell
            cell?.profileBtn.layer.removeAllAnimations()
            cell?.startAnimation()
        }
    }
    
    //** FIM DAS FUNCOES DE ATUALIZACAO DA TELA **//
    
    
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
        return self.favourites.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RandomWalk_CollectionViewCell
        
        cell.contactsController = self.home
        cell.profileBtn.tag = indexPath.row
        cell.setInfo(self.favourites[indexPath.row].username, profile: UIImage(data: self.favourites[indexPath.row].profileImage!)!)
        
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
            //            let cell = self.collectionView!.cellForItemAtIndexPath(indexPath!)
            let attributes : UICollectionViewLayoutAttributes = self.collectionView!.layoutAttributesForItemAtIndexPath(indexPath!)!
            let frame = attributes.frame
            
            let origin = self.collectionView!.convertRect(frame, toView: self.collectionView!.superview)
            
            self.contactManager = ContactManager_View(contact: self.favourites[(indexPath?.item)!], requester: self.home, origin: origin)
            
            self.home.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
            self.home.blurView.frame = self.home.view.bounds
            self.home.blurView.alpha = 0
            self.home.view.addSubview(self.home.blurView)
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                self.home.blurView.alpha = 0.8
                
                }) { (success: Bool) -> Void in
                    
            }

            
            self.home.view.addSubview(self.contactManager)
            self.contactManager.insertView()
        }
    }
    
    func openChat(sender: UIButton)
    {
        //NAO ESTA SENDO USADA
        //(por enquanto)
    }
    
    func mesageReceived()
    {
        self.checkUnreadMessages()
    }
    
}