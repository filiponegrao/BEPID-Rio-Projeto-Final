//
//  Contacts_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Contacts_ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func logout(sender: UIButton)
    {
        self.presentViewController(Login_ViewController(nibName: "", bundle: nil), animated: true, completion: nil)
        
        self.navigationController?.pushViewController(Login_ViewController(nibName: "", bundle: nil), animated: true)
    }
    


}
