//
//  Settings_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Settings_ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = lightGray

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func logout(sender: AnyObject)
    {
        let login = Login_ViewController()
        self.presentViewController(login, animated: true, completion: nil)
    }
    
    @IBAction func back(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
