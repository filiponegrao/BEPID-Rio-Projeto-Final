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
    var viewController : ContactsBubble_CollectionViewController!
    
    var contact : Contact!
    
    var blackScreen : UIView!
    
    var backButton : UIButton!
    
    var contactImage : UIImageView!
    
    var circleView : CircleView!
    
    var trustLevel : Int!
    
    var usernameLabel : UILabel!
    
    var trustLevelLabel : UILabel!

    var favouriteButton : UIButton!
    
    var deleteButton : UIButton!
    
    var clearChat : UIButton!
    
    init(contact: Contact)
    {
        self.contact = contact
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.backgroundColor = UIColor.clearColor()
        
        self.blackScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0.9
        self.addSubview(self.blackScreen)
        
        self.backButton = UIButton(frame: CGRectMake(0, 25, 44, 44))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview((self.backButton))
        
        //VALOR DO TRUST LEVEL DO CONTATO
        self.trustLevel = Int(self.contact.trustLevel)
        
        //EXIBE TRUST LEVEL DO CONTATO
        self.trustLevelLabel = UILabel(frame: CGRectMake(screenWidth/9, screenHeight/6 * 2.5 + 10, screenWidth/2, screenWidth/6))
        self.trustLevelLabel.text = "\(self.trustLevel)%"
        self.trustLevelLabel.textColor = UIColor.whiteColor()
        self.trustLevelLabel.textAlignment = .Left
        self.trustLevelLabel.font = UIFont(name: "Sukhumvit Set", size: 40)
        self.trustLevelLabel.font.fontWithSize(40)
        self.trustLevelLabel.setSizeFont(40)
        self.addSubview(self.trustLevelLabel)
        
        //EXIBE USERNAME DO CONTATO
        self.usernameLabel = UILabel(frame: CGRectMake(screenWidth/9, screenHeight/6 * 2.5 + self.trustLevelLabel.frame.size.height, screenWidth/2, screenWidth/6))
        self.usernameLabel.text = self.contact.username
        self.usernameLabel.textColor = UIColor.whiteColor()
        self.usernameLabel.textAlignment = .Left
        self.usernameLabel.font = UIFont(name: "Sukhumvit Set", size: 20)
        self.usernameLabel.font.fontWithSize(20)
        self.usernameLabel.setSizeFont(20)
        self.addSubview(self.usernameLabel)
        
        self.contactImage = UIImageView(frame: CGRectMake(screenWidth/5 * 2, screenHeight/5, screenWidth/2, screenWidth/2))
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.height/2
        self.contactImage.clipsToBounds = true
        self.contactImage.backgroundColor = oficialGreen
        self.contactImage.image = UIImage(data: self.contact.profileImage)
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
        self.deleteButton = UIButton(frame: CGRectMake(screenWidth/2 + 10, screenHeight - screenWidth/6 - 20, screenWidth/6, screenWidth/6))
        self.deleteButton.backgroundColor = oficialLightGray
        self.deleteButton.layer.cornerRadius = self.deleteButton.frame.size.height/2
        self.deleteButton.clipsToBounds = true
        self.deleteButton.addTarget(self, action: "deleteContact", forControlEvents: .TouchUpInside)
        self.deleteButton.setImage(UIImage(named: "deleteButton"), forState: .Normal)
        self.addSubview(self.deleteButton)
        
        self.clearChat = UIButton(frame: CGRectMake(screenWidth/9, screenHeight/6 * 2.5 + self.trustLevelLabel.frame.size.height + self.usernameLabel.frame.size.height, screenWidth/2, screenWidth/8))
        self.clearChat.setTitle("Clear chat", forState: .Normal)
        self.clearChat.setTitleColor(oficialGreen, forState: .Normal)
        self.clearChat.titleLabel?.textAlignment = NSTextAlignment.Left
        self.clearChat.backgroundColor = oficialRed
        self.clearChat.addTarget(self, action: "clearConversation", forControlEvents: .TouchUpInside)
        self.addSubview(self.clearChat)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    func back()
    {
        self.removeFromSuperview()
//        self.viewController.blurView.removeFromSuperview()
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
        }
        else
        {
            DAOContacts.sharedInstance.setFavorite(self.contact)
            self.favouriteButton.backgroundColor = oficialGreen
        }
    }
    
    //DELETA UM CONTATO DA LISTA DE FAVORITOS
    func deleteContact()
    {
        let alert = UIAlertView(title: "Wow", message: "Are you sure you want to remove this contact from your list? You cannot undo this action.", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
        
//        DAOContacts.sharedInstance.deleteContact(self.contact.username)
 
    }
    
    //LIMPA UMA CONVERSA
    func clearConversation()
    {
        DAOMessages.sharedInstance.clearConversation(self.contact.username)
    }
}


