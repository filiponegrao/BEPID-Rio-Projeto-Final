//
//  TutoFirst_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class TutoFirst_ViewController: UIViewController
{
    var index = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.redColor()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logOut(sender: AnyObject)
    {
        DAOUser.logOut()
        let login = Login_ViewController(nibName: "Login_ViewController", bundle: nil)
        self.presentViewController(login, animated: true, completion: nil)
    }
 
}
