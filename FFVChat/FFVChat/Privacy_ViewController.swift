//
//  Privacy_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Privacy_ViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate
{
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var termsText: UITextView!

    @IBOutlet weak var backView: UIView!
    
    var disagreeButton: MKButton!
    
    var agreeButton: MKButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = oficialDarkGray
        self.backView.backgroundColor = oficialSemiGray
        self.termsText.backgroundColor = oficialSemiGray
        self.termsText.textColor = oficialLightGray
        self.termsText.delegate = self
//        self.termsText.contentInset = UIEdgeInsetsMake(-1,-1, 0, 0)
//        self.termsText.scrollRangeToVisible(NSMakeRange(0, 0))
//        self.termsText.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        
        self.topLabel.textColor = oficialGreen
        self.topLabel.font = UIFont(name: "Sukhumvit Set", size: 22)
        self.topLabel.setSizeFont(22)

        self.disagreeButton = MKButton(frame: CGRectMake(0,screenHeight - 44, screenWidth/2 - 2, 44))
        self.disagreeButton.backgroundColor = oficialLightGray
        self.disagreeButton.setTitle("Disagree", forState: .Normal)
        self.disagreeButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.disagreeButton.addTarget(self, action: "userDisagreed", forControlEvents: UIControlEvents.TouchUpInside)
        self.disagreeButton.enabled = false
        self.disagreeButton.backgroundLayerCornerRadius = 300
        self.disagreeButton.rippleLocation = .Center
        self.disagreeButton.ripplePercent = 4
        self.disagreeButton.rippleLayerColor = oficialDarkGray
        self.view.addSubview(self.disagreeButton)
        
        self.agreeButton = MKButton(frame: CGRectMake(screenWidth/2 + 2, screenHeight - 44, screenWidth/2 - 2.5, 44))
        self.agreeButton.backgroundColor = oficialLightGray
        self.agreeButton.setTitle("Agree", forState: .Normal)
        self.agreeButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.agreeButton.addTarget(self, action: "userAgreed", forControlEvents: UIControlEvents.TouchUpInside)
        self.agreeButton.enabled = false
        self.agreeButton.backgroundLayerCornerRadius = 300
        self.agreeButton.rippleLocation = .Center
        self.agreeButton.ripplePercent = 4
        self.agreeButton.rippleLayerColor = oficialDarkGray
        self.view.addSubview(self.agreeButton)
        
        if(screenHeight > self.termsText.contentSize.height)
        {
            self.agreeButton.backgroundColor = oficialGreen
            self.disagreeButton.backgroundColor = oficialGreen
            self.disagreeButton.enabled = true
            self.agreeButton.enabled = true
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews()
    {
        self.termsText.setContentOffset(CGPointZero, animated: false)

    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        let bottomEdge = self.termsText.contentOffset.y + self.termsText.frame.size.height
        
        if(bottomEdge >= self.termsText.contentSize.height)
        {
            self.agreeButton.backgroundColor = oficialGreen
            self.disagreeButton.backgroundColor = oficialGreen
            self.disagreeButton.enabled = true
            self.agreeButton.enabled = true
        }

    }
    
    func userDisagreed()
    {
        let alert = UIAlertView(title: "Sorry", message: "You must agree to the terms for using this app", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
        
        
        
    }

    func userAgreed()
    {
        AppStateData.sharedInstance.acceptTermsOfUse()
        
        let id = DAOUser.sharedInstance.getFacebookId()
        
        if(id == nil)
        {
            let linkFace = AppLoginImport_ViewController()
            self.presentViewController(linkFace, animated: true, completion: nil)
        }
        else
        {
            let importContact = Import_ViewController()
            self.presentViewController(importContact, animated: true, completion: nil)
        }
    }
}
