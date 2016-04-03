//
//  ContactManager_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class ContactManager_View: UIView
{
    weak var homeController : Home_ViewController!
    
    var contact : Contact!
    
    var blackScreen : UIView!
    
    var backButton : UIButton!
    
    var contactImage : UIImageView!
    
    var circleView : CircleView!
    
    var trustLevel : Int!
    
    var usernameLabel : UILabel!
    
    var trustLevelLabel : UILabel!

    var favouriteButton : UIButton!
    
    var deleteButton : MKButton!
    
    var clearChat : UIButton!
    
    var blurView : UIVisualEffectView!
    
    var origin : CGRect!
    
    init(contact: Contact, requester: Home_ViewController, origin: CGRect)
    {
        self.origin = origin
        self.homeController = requester
        self.contact = contact
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.backgroundColor = UIColor.clearColor()
        
        self.blackScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0
        self.addSubview(self.blackScreen)
        
        self.backButton = UIButton(frame: CGRectMake(0, 25, 44, 44))
        self.backButton.setImage(UIImage(named: "close"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview((self.backButton))
        
        //VALOR DO TRUST LEVEL DO CONTATO
        self.trustLevel = Int(self.contact.trustLevel)
        
        //EXIBE TRUST LEVEL DO CONTATO
        self.trustLevelLabel = UILabel(frame: CGRectMake(screenWidth/9, screenHeight/6 * 2.5 + 10, screenWidth/2, screenWidth/6))
        self.trustLevelLabel.text = "\(self.trustLevel)%"
        self.trustLevelLabel.textColor = UIColor.whiteColor()
        self.trustLevelLabel.textAlignment = .Left
        self.trustLevelLabel.font = UIFont(name: "SukhumvitSet-Light", size: 45)
        self.trustLevelLabel.font.fontWithSize(45)
        self.trustLevelLabel.setSizeFont(45)
        self.addSubview(self.trustLevelLabel)
        
        //EXIBE USERNAME DO CONTATO
        self.usernameLabel = UILabel(frame: CGRectMake(screenWidth/9, screenHeight/6 * 2.5 + self.trustLevelLabel.frame.size.height - 5, screenWidth, screenWidth/6))
        self.usernameLabel.text = self.contact.username
        self.usernameLabel.textColor = UIColor.whiteColor()
        self.usernameLabel.textAlignment = .Left
        self.usernameLabel.font = UIFont(name: "SukhumvitSet-Light", size: 20)
        self.usernameLabel.font.fontWithSize(20)
        self.usernameLabel.setSizeFont(20)
        self.addSubview(self.usernameLabel)
        
        self.contactImage = UIImageView(frame: CGRectMake(screenWidth/5 * 2, screenHeight/5, screenWidth/2, screenWidth/2))
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.height/2
        self.contactImage.clipsToBounds = true
//        self.contactImage.backgroundColor = oficialGreen
        self.contactImage.image = UIImage(data: self.contact.profileImage)
//        self.contactImage.contentMode = .ScaleAspectFill
        self.addSubview(self.contactImage)
        
        
        //ADICIONA CIRCULO DE ACORDO COM TRUST LEVEL
        addCircleView()
        
        //BOTÃO PARA FAVORITAR/DESFAVORITAR CONTATO
        self.favouriteButton = UIButton(frame: CGRectMake(screenWidth/2 - screenWidth/6 - 10, screenHeight - screenWidth/6 - 20, screenWidth/6, screenWidth/6))
        if(self.contact.isFavorit == true)
        {
            self.favouriteButton.backgroundColor = oficialGreen
        }
        else
        {
            self.favouriteButton.backgroundColor = oficialLightGray
        }
        self.favouriteButton.layer.cornerRadius = self.favouriteButton.frame.size.height/2
        self.favouriteButton.clipsToBounds = true
        self.favouriteButton.addTarget(self, action: "addOrRemoveFavourite", forControlEvents: .TouchUpInside)
        self.favouriteButton.setImage(UIImage(named: "favouriteButton"), forState: .Normal)
        self.addSubview(self.favouriteButton)
        
        //BOTÃO PARA DELETAR CONTATO
        self.deleteButton = MKButton(frame: CGRectMake(screenWidth/2 + 10, screenHeight - screenWidth/6 - 20, screenWidth/6, screenWidth/6))
        self.deleteButton.backgroundColor = oficialLightGray
        self.deleteButton.layer.cornerRadius = self.deleteButton.frame.size.height/2
        self.deleteButton.clipsToBounds = true
        self.deleteButton.addTarget(self, action: "deleteContact", forControlEvents: .TouchUpInside)
        self.deleteButton.setImage(UIImage(named: "removeContact"), forState: .Normal)
        self.deleteButton.backgroundLayerCornerRadius = 600
        self.deleteButton.rippleLocation = .Center
        self.deleteButton.ripplePercent = 4
        self.deleteButton.rippleLayerColor = UIColor.blackColor()
        self.addSubview(self.deleteButton)
        
        //BOTÃO PARA LIMPAR CONVERSA
        self.clearChat = UIButton(frame: CGRectMake(screenWidth/9 - 3, screenHeight/6 * 2.5 + self.trustLevelLabel.frame.size.height + self.usernameLabel.frame.size.height - 5, screenWidth/3, screenWidth/9.5))
        self.clearChat.setTitle("Clear chat", forState: .Normal)
        self.clearChat.setTitleColor(oficialGreen, forState: .Normal)
        self.clearChat.setTitleColor(oficialLightGray, forState: .Highlighted)
        self.clearChat.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        self.clearChat.addTarget(self, action: "clearConversation", forControlEvents: .TouchUpInside)
        self.clearChat.titleLabel?.font = UIFont(name: "SukhumvitSet-Text", size: 18)
        self.clearChat.backgroundColor = oficialDarkGray
        self.clearChat.clipsToBounds = true
        self.clearChat.layer.cornerRadius = 18

        
        // set the attributed title for different states
        
        // .Selected
        let mySelectedAttributedTitle = NSAttributedString(string: "Clear chat",
            attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.clearChat.setAttributedTitle(mySelectedAttributedTitle, forState: .Selected)
        
        // .Normal
        let myNormalAttributedTitle = NSAttributedString(string: "Clear chat",
            attributes: [NSForegroundColorAttributeName : oficialGreen])
        self.clearChat.setAttributedTitle(myNormalAttributedTitle, forState: .Normal)
        
        self.addSubview(self.clearChat)
        
    }
    
    
    func insertView()
    {
        self.blackScreen.alpha = 0.9
       
        
//        self.sendSubviewToBack(self.viewController.blurView)
        
        let finalFrame = self.contactImage.frame
        self.contactImage.frame = self.origin
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.width/2
        
        let posUsername = self.usernameLabel.center
        let postrustLevel = self.trustLevelLabel.center
        let posClearchat = self.clearChat.center
        let posFavorite = self.favouriteButton.center
        let posDelete = self.deleteButton.center
        
        self.trustLevelLabel.center.x -= screenWidth
        self.usernameLabel.center.x -= screenWidth
        self.clearChat.center.x -= screenWidth
        
        self.favouriteButton.center.y += screenHeight/2
        self.deleteButton.center.y += screenHeight/2
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.blackScreen.alpha = 0.8
            self.homeController.blurView.alpha = 0.8
            self.trustLevelLabel.center = postrustLevel
            self.usernameLabel.center = posUsername
            self.clearChat.center = posClearchat
            self.favouriteButton.center = posFavorite
            self.deleteButton.center = posDelete
            self.contactImage.frame = finalFrame
            self.contactImage.layer.cornerRadius = finalFrame.size.width/2

            
            }) { (success: Bool) -> Void in
                
        }
        
    }
    
    func removeView()
    {
//        self.blackScreen.alpha = 0
//        self.blurView.alpha = 0

        self.circleView.removeFromSuperview()
        self.backButton.removeFromSuperview()
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.contactImage.frame = self.origin
            self.contactImage.frame.size = CGSizeMake(self.origin.width, self.origin.width)
            self.contactImage.layer.cornerRadius = self.origin.size.width/2
            self.blackScreen.alpha = 0
            self.homeController.blurView.alpha = 0
            
            self.favouriteButton.center.y += screenHeight/2
            self.deleteButton.center.y += screenHeight/2
            
            self.clearChat.center.x -= screenWidth/2
            self.trustLevelLabel.center.x -= screenWidth/2
            self.usernameLabel.center.x -= screenWidth
            
            self.contactImage.alpha = 0

            
            }) { (success: Bool) -> Void in
                
                self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    func back()
    {
        self.removeView()
    }
    
    func addCircleView()
    {
        let circleWidth = screenWidth/1.95
        let circleHeight = screenWidth/1.95

        self.circleView = CircleView(frame: CGRectMake(0, 0, circleWidth, circleHeight))
        self.circleView.center = CGPointMake(self.contactImage.center.x, self.contactImage.center.y)
        
        self.circleView.setColor(self.trustLevel)
        self.circleView.animateCircle(1.0, trustLevel: self.trustLevel)
        self.addSubview(self.circleView)

    }
    
    //ADICIONA OU REMOVE UM CONTATO DA LISTA DE FAVORITOS
    func addOrRemoveFavourite()
    {
        if(self.contact.isFavorit == true)
        {
            DAOContacts.sharedInstance.setNonFavorite(self.contact)
            self.favouriteButton.backgroundColor = oficialLightGray
            
            self.homeController.favouritesController.favourites = DAOContacts.sharedInstance.getFavorites()
            self.homeController.favouritesController.collectionView?.reloadData()
        }
        else
        {
            DAOContacts.sharedInstance.setFavorite(self.contact)
            self.favouriteButton.backgroundColor = oficialGreen
            
            self.homeController.favouritesController.favourites = DAOContacts.sharedInstance.getFavorites()
            self.homeController.favouritesController.collectionView?.reloadData()
        }
    }
    
    //DELETA UM CONTATO DA LISTA
    func deleteContact()
    {
        let alert = UIAlertController(title: "Are you sure?", message: "Do you want to remove this contact from your list? You cannot undo this action.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            
            DAOContacts.sharedInstance.deleteContact(self.contact.username)
            
            self.homeController.contactsController.contacts = DAOContacts.sharedInstance.getAllContacts()
            self.homeController.contactsController.collectionView?.reloadData()
            self.homeController.contactsController.reloadAnimations()
            self.removeView()
            
            self.homeController.favouritesController.favourites = DAOContacts.sharedInstance.getFavorites()
            self.homeController.favouritesController.collectionView?.reloadData()
            self.homeController.favouritesController.reloadAnimations()
            self.removeView()
  
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
        
            
      }))
        
        self.homeController.presentViewController(alert, animated: true) { () -> Void in
            
        }
 
    }
    
    //LIMPA UMA CONVERSA
    func clearConversation()
    {
        let alert = UIAlertController(title: "Are you sure?", message: "Do you want to clear chat? You cannot undo this action.", preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            
            DAOMessages.sharedInstance.clearConversation(self.contact.username)

        }))

        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
            
            
        }))
        
        self.homeController.presentViewController(alert, animated: true, completion: nil)

    }
}


