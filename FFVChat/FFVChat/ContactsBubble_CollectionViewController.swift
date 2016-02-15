//
//  ContactsBubble_CollectionViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/13/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit
import AVFoundation


private let reuseIdentifier = "Cell"

class ContactsBubble_CollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate
{
    weak var home : Home_ViewController!
    
    var contacts = [Contact]()
    
    var blurView : UIVisualEffectView!
    
    var longPress : UILongPressGestureRecognizer!
    
    var contactManager : ContactManager_View!
    
    var background : UIImageView!
        
    var messageSound: AVAudioPlayer!
    
    var collectionSize : CGSize!
    
    //Aux
    var celulaClicada : Int = -1
    
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
        self.collectionView!.frame = CGRectMake(0, 0, self.collectionSize.width , screenHeight)
        
        self.view.backgroundColor = UIColor.clearColor()
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.registerClass(RandomWalk_CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.backgroundColor = UIColor.clearColor()
    
        
        self.longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        self.longPress.minimumPressDuration = 0.5
        self.longPress.delaysTouchesBegan = true
        self.longPress.delegate = self
//        self.view.addGestureRecognizer(self.longPress)
        
        self.contacts = DAOContacts.sharedInstance.getAllContacts()
        self.collectionView!.reloadData()
    }
    
    
    //** FUNCOES DE ATUALIZACAO DA TELA ***//
    
    func addNewContact()
    {
        self.contacts = DAOContacts.sharedInstance.getAllContacts()
        
        //Checa se o usuario esta buscando alguem
        if(!self.home.searchBar.isFirstResponder())
        {
            let index = self.contacts.indexOf(DAOContacts.sharedInstance.lastContactAdded)!
            
            self.collectionView!.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
            
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as? RandomWalk_CollectionViewCell
            cell?.startAnimation()
        }
    }
    
    func mesageReceived()
    {
        self.playSound()
        self.checkUnreadMessages()
    }
    
    
    func checkUnreadMessages()
    {
        for i in 0..<self.collectionView!.numberOfItemsInSection(0)
        {
            let cell = self.collectionView!.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as? RandomWalk_CollectionViewCell
            let contact = self.contacts[i]
            let cont = DAOMessages.sharedInstance.numberOfUnreadMessages(contact)
            cell?.profileBtn.setImage(UIImage(data: self.contacts[i].profileImage!) , forState: .Normal)
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
        return self.contacts.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RandomWalk_CollectionViewCell
        
        cell.contactsController = self.home
        cell.profileBtn.tag = indexPath.row
        
        cell.gestureRecognizers?.last?.removeTarget(self, action: "handleLongPress:")
        cell.profileBtn.addLongClickAction("handleLongPress:", target: self, time: 1)
        
        cell.setInfo(self.contacts[indexPath.row].username, profile: UIImage(data: self.contacts[indexPath.row].thumb!)!)
        let cont = DAOMessages.sharedInstance.numberOfUnreadMessages(self.contacts[indexPath.item])
        cell.setUnreadMessages(cont)
        
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    
    func handleLongPress(button: UIButton)
    {
        let attributes : UICollectionViewLayoutAttributes = self.collectionView!.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: button.tag, inSection: 0))!
        let frame = attributes.frame
        
        var origin = self.collectionView!.convertRect(frame, toView: self.collectionView!.superview)
        origin = CGRectMake(origin.origin.x, origin.origin.y + 80 + self.collectionView!.frame.origin.y + 40, origin.size.width, origin.size.height)

        self.contactManager = ContactManager_View(contact: self.contacts[(button.tag)], requester: self.home, origin: origin)
        
        self.home.closeSearch()
        self.home.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.home.blurView.frame = self.home.view.bounds
        self.home.blurView.alpha = 0
        self.home.view.addSubview(self.home.blurView)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.home.blurView.alpha = 0.8
            
            }, completion: nil)
        
        self.home.view.addSubview(self.contactManager)
        self.contactManager.insertView()
        
    }
    
    
    func openChat(sender: UIButton)
    {
        //NAO ESTA SENDO USADA
        //(por enquanto)
    }
    
    
    func playSound()
    {
        let path = NSBundle.mainBundle().pathForResource("messageNotification.mp3", ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        
        do
        {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            self.messageSound = sound
            sound.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    
    
}


