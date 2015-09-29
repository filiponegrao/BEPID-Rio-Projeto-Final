//
//  TutoSecond_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 29/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class TutoSecond_ViewController: UIViewController
{
    var index = 1

    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func skipToPrivacy(sender: AnyObject)
    {
        let privacy = Privacy_ViewController()
        self.presentViewController(privacy, animated: true, completion: nil)
    }
    
}
