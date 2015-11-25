//
//  NavigationChat_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class NavigationChat_View: UIView
{
    weak var viewController : Chat_ViewController!
    
    var backButton : UIButton!
    
    var contactImage : UIButton!
    
    var contactName : UILabel!
    
    var galleryButton : UIButton!
    
    init(requester: Chat_ViewController)
    {
        self.viewController = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 80))
        self.backgroundColor = oficialDarkGray
        
        
        self.backButton = UIButton(frame: CGRectMake(0, 25, 44, 44))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview((self.backButton))
        
        self.contactImage = UIButton(frame: CGRectMake(screenWidth/2, 25, screenWidth/5.5, screenWidth/5.5))
        self.contactImage.backgroundColor = UIColor.grayColor()
        self.contactImage.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.contactImage.layer.borderWidth = 2.0
        self.contactImage.layer.shadowOpacity = 1
        self.contactImage.layer.shadowRadius = 3.5
        self.contactImage.layer.shadowColor = UIColor.blackColor().CGColor
        self.contactImage.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        self.contactImage.clipsToBounds = true
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.width/2
        self.contactImage.center = CGPointMake(self.center.x, self.center.y + 15)
        self.contactImage.addTarget(self, action: "goToProfile", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.contactImage)
        
        self.galleryButton = UIButton(frame: CGRectMake(self.frame.size.width - 54 , 25, 44, 44))
        self.galleryButton.alpha = 0.7
        self.galleryButton.setImage(UIImage(named: "galleryButton"), forState: .Normal)
        self.galleryButton.addTarget(self, action: "goToGallery", forControlEvents: .TouchUpInside)
        self.addSubview(self.galleryButton)

        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        
        //Limpando memoria:
        self.viewController.tableView.delegate = nil
        self.viewController.tableView.dataSource = nil
        self.viewController.messageText.delegate = nil
        self.viewController.imagePicker?.delegate = nil
        
        self.viewController.navigationController?.popViewControllerAnimated(true)
    }
    
    func goToProfile()
    {
        let profile = ReceiverProfile_ViewController()
        profile.contact = self.viewController.contact
        self.viewController.navigationController?.pushViewController(profile, animated: true)
    }
    
    func goToGallery()
    {
        let gallery = SentMidiaGallery_ViewController(nibName: "SentMidiaGallery_ViewController",bundle: nil)
        gallery.contact = self.viewController.contact
        self.viewController.navigationController?.pushViewController(gallery, animated: true)
    }
    
    
    
}
