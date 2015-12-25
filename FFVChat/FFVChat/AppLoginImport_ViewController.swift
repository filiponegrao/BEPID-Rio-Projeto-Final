//
//  AppLoginImport_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 22/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class AppLoginImport_ViewController: UIViewController
{
    var titleLabel : UILabel!
    
    var titleLabel2 : UILabel!
    
    var backView : UIView!
    
    var textView : UITextView!
    
    var facebookConnect : UIButton!
    
    var skipButton : UIButton!
    
    var loadingView : LoadScreen_View!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialDarkGray
        
        self.titleLabel = UILabel(frame: CGRectMake(0, 55, screenWidth, 35))
        self.titleLabel.text = "Facebook"
        self.titleLabel.textAlignment = .Center
        self.titleLabel.textColor = oficialGreen
        self.titleLabel.font = UIFont(name: "Sukhumvit Set", size: 22)
        self.titleLabel.setSizeFont(22)
        self.view.addSubview(self.titleLabel)

        self.titleLabel2 = UILabel(frame: CGRectMake(0, 80, screenWidth, 35))
        self.titleLabel2.text = "Contacts"
        self.titleLabel2.textAlignment = .Center
        self.titleLabel2.textColor = oficialGreen
        self.titleLabel2.font = UIFont(name: "Sukhumvit Set", size: 22)
        self.titleLabel2.setSizeFont(22)
        self.view.addSubview(self.titleLabel2)
        
//        self.backView = UIView(frame: CGRectMake(20, 55 + self.titleLabel.frame.size.height + self.titleLabel2.frame.size.height + 20, screenWidth - 40, screenHeight/4 - 10))
//        self.backView.backgroundColor = UIColor.clearColor()
//        self.backView.layer.cornerRadius = 7
//        self.backView.clipsToBounds = true
//        self.view.addSubview(self.backView)
        let text = "Do you want to import your contacts from Facebook? Choosing this option you will become visible and other contacts can import you also. If you want, please allow Myne to link with your Facebook."
        let font = UIFont(name: "Helvetica", size: 16)!
        let heigth = Optimization.heightForView(text, font: font, width: screenWidth-20)+10
        
        self.textView = UITextView(frame: CGRectMake(20, self.titleLabel2.frame.origin.y + self.titleLabel2.frame.size.height + 30, screenWidth - 30, heigth))
        self.textView.text = text
        self.textView.font = font
        self.textView.userInteractionEnabled = false
        self.textView.textColor = oficialLightGray
        self.textView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.textView)
        
        self.facebookConnect = UIButton(frame: CGRectMake(screenWidth/3 - 10, screenHeight/2 + 20, screenWidth/3 + 20, 55))
        self.facebookConnect.setImage(UIImage(named: "facebookConnect"), forState: .Normal)
        self.facebookConnect.addTarget(self, action: "linkFacebook", forControlEvents: UIControlEvents.TouchUpInside)
        self.facebookConnect.imageView?.contentMode = .ScaleAspectFit
        self.view.addSubview(self.facebookConnect)
        
        self.skipButton = UIButton(frame: CGRectMake(screenWidth/3, screenHeight/2 + 20 + self.facebookConnect.frame.size.height + 20, screenWidth/3, 44))
        self.skipButton.setTitle("No, thanks.", forState: .Normal)
        self.skipButton.setTitleColor(oficialLightGray, forState: .Normal)
        self.skipButton.addTarget(self, action: "skip", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.skipButton)

    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "linkedWithFacebook", name: UserCondition.userLogged.rawValue, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UserCondition.userLogged.rawValue, object: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func linkFacebook()
    {
        self.loadingView = LoadScreen_View()
        self.view.addSubview(self.loadingView)
        DAOUser.sharedInstance.linkParseAccountWithFacebook()
    }
    
    func linkedWithFacebook()
    {
        AppStateData.sharedInstance.importContacts()
        let faceimport = Import_ViewController(nibName: "Import_ViewController", bundle: nil)
        self.presentViewController(faceimport, animated: true, completion: nil)
    }
    
    func skip()
    {
        AppStateData.sharedInstance.importContacts()
        let contacts = AppNavigationController()
//        DAOGifs.sharedInstance.checkNewGifsFromServer()
        self.presentViewController(contacts, animated: true, completion: nil)
    }

}
