//
//  ReceiverProfile_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class ReceiverProfile_ViewController: UIViewController
{
    
    @IBOutlet weak var contactImage: UIImageView!
    
    var contact : Contact!
    
    var backButton : UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if (self.contact.username == "filiponegrao")
        {
            self.view.backgroundColor = goodTrust

        }
        else
        {
            self.view.backgroundColor = badTrust
        }
        
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.height/2
        self.contactImage.clipsToBounds = true
        self.contactImage.image = DAOUser.sharedInstance.getProfileImage()
        self.contactImage.layer.borderWidth = 1.5
        self.contactImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.contactImage.image = UIImage(data: self.contact.profileImage!)
        
        self.backButton = UIButton(frame: CGRectMake(10, 35, 20, 20))
        self.backButton.setImage(UIImage(named: "backButton"), forState: UIControlState.Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
