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
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.height/2
        self.contactImage.clipsToBounds = true
        self.contactImage.image = DAOUser.sharedInstance.getProfileImage()
        self.contactImage.layer.borderWidth = 1.5
        self.contactImage.layer.borderColor = UIColor.whiteColor().CGColor
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
