//
//  Privacy_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Privacy_ViewController: UIViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var termsText: UITextView!

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var disagreeButton: UIButton!
    
    @IBOutlet weak var agreeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func userDisagreed(sender: AnyObject)
    {
        
        
        
    }

    @IBAction func userAgreed(sender: AnyObject)
    {
        let importContact = Import_ViewController()
        self.presentViewController(importContact, animated: true, completion: nil)
    }
}
