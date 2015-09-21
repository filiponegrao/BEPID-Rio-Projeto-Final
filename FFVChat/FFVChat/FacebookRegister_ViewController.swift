//
//  FacebookRegister_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 12/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class FacebookRegister_ViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var labelUsername: UITextField!
    
    @IBOutlet var labelPassword: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let image = DAOUser.getProfileImage()
        
        self.imageView.image = image
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2
        
        let name = DAOUser.getUserName()
        let trimmedString = name.removeWhitespace()
        let username = trimmedString.lowercaseString
        print(username)
        self.labelUsername.text = username

        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func register(sender: UIButton)
    {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
}
