//
//  Chat_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Chat_ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(DAOUser.getUserName())
        print(DAOUser.getEmail())
        print(DAOUser.getPassword())
        print(DAOUser.getTrustLevel())
        print(DAOUser.getProfileImage())
        DAOUser.getFaceContacts()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


    @IBAction func logOut(sender: UIButton)
    {
        DAOUser.logOut()
        let login = Login_ViewController(nibName: "Login_ViewController", bundle: nil)
        self.presentViewController(login, animated: true, completion: nil)
    }
}
