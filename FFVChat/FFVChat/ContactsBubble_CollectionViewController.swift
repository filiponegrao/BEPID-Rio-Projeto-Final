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
    
    var contacts = [Contact]()
    
    var navigationBar : NavigationContact_View!
    
    var blurView : UIVisualEffectView!
    
    var longPress : UILongPressGestureRecognizer!
    
    var contactManager : ContactManager_View!
    
    var background : UIImageView!
    
    weak var chatController : Chat_ViewController!
    
    var messageSound: AVAudioPlayer!
    
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
        self.collectionView!.frame = CGRectMake(0, 40, self.view.frame.width, self.view.frame.height - 40)
        
        self.view.backgroundColor = oficialMediumGray
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.registerClass(RandomWalk_CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.backgroundColor = UIColor.clearColor()
        
        self.background = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.background.image = UIImage(named: "ContactBackground")
        self.background.alpha = 0.1
        self.view.addSubview(self.background)
        self.view.sendSubviewToBack(self.background)
        
        //Nav Bar
        self.navigationBar = NavigationContact_View(requester: self)
        self.view.addSubview(self.navigationBar)
        
        self.longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        self.longPress.minimumPressDuration = 0.5
        self.longPress.delaysTouchesBegan = true
        self.longPress.delegate = self
        self.view.addGestureRecognizer(self.longPress)
        
        self.contacts = DAOContacts.sharedInstance.getAllContacts()
        self.collectionView!.reloadData()
        
        
    }
    
    //** FUNCOES DE INTRDOUCAO À TELA, E DESAPARECIMENTO DA MESMA **//
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addNewContact", name: NotificationController.center.friendAdded.name, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadAnimations", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkUnreadMessages", name: NotificationController.center.messageReceived.name, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        DAOFriendRequests.sharedInstance.friendsAccepted()
        DAOPostgres.sharedInstance.startObserve()
        self.reloadAnimations()
        self.checkUnreadMessages()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationController.center.friendAdded.name, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationController.center.messageReceived.name, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        DAOPostgres.sharedInstance.stopObserve()
    }
    
    //** FIM FUNCOES DE INTRDOUCAO À TELA, E DESAPARECIMENTO DA MESMA **//
    
    
    override func viewDidLayoutSubviews()
    {
        self.navigationBar.filterButtons.titleLabel?.font = self.navigationBar.filterButtons.titleLabel?.font.fontWithSize(22)
    }
    
    
    //** FUNCOES DE ATUALIZACAO DA TELA ***//
    
    func addNewContact()
    {
        self.contacts = DAOContacts.sharedInstance.getAllContacts()
        
        let index = self.contacts.indexOf(DAOContacts.sharedInstance.lastContactAdded)!
        
        self.collectionView!.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
    }
    
    func checkUnreadMessages()
    {
        for i in 0..<self.collectionView!.numberOfItemsInSection(0)
        {
            let cell = self.collectionView!.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as? RandomWalk_CollectionViewCell
            let contact = self.contacts[i]
            let cont = DAOMessages.sharedInstance.numberOfUnreadMessages(contact)
            if(cont > 0)
            {
                self.playSound()
            }
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
        //NAO ESTA SENDO USADA
        //(por enquanto)
    }
    
    
    func playSound()
    {
        let path = NSBundle.mainBundle().pathForResource("messageNotification.mp3", ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            self.messageSound = sound
            sound.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    
    
}


