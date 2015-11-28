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

    var iphoneShape : UIImageView!
    
    var skipButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = oficialDarkGray
        
//        self.skipButton = UIButton(frame: CGRectMake(screenWidth/4 * 3, screenHeight - screenWidth/7, screenWidth/4, screenWidth/7))
        self.skipButton = UIButton(frame: CGRectMake(screenWidth/4 * 3, 15, screenWidth/4, screenWidth/7))
        self.skipButton.setTitle("skip", forState: .Normal)
        self.skipButton.setTitleColor(oficialGreen, forState: .Normal)
        self.skipButton.addTarget(self, action: "skipToPrivacy", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.skipButton)
        
        self.iphoneShape = UIImageView(frame: CGRectMake(screenWidth/5, screenHeight/4, screenWidth/5 * 3, screenHeight/6 * 4))
        self.iphoneShape.image = UIImage(named: "tutorialSoon")
        self.view.addSubview(self.iphoneShape)


    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func skipToPrivacy()
    {
        let privacy = Privacy_ViewController()
        self.presentViewController(privacy, animated: true, completion: nil)
    }
    
}
