//
//  ReceiverProfile_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class ReceiverProfile_ViewController: UIViewController
{
    
    var contactImage: UIImageView!
    
    var contact : Contact!
    
    var username : String!
    
    var usernameLabel : UILabel!
    
    var userSince: String! // MUDAR PARA DATE
    
    var userSinceLabel : UILabel!
    
    var screenshots : Int!
    
    var screenshotsLabel : UILabel!
    
    var reports : Int!
    
    var reportsLabel : UILabel!
    
    var trustLevel : Int!
    
    var trustLevelLabel : UILabel!
    
    var backButton : UIButton!
    
    var contentView : UIView!
    
    var circleView : CircleView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialDarkGray
        self.view.clipsToBounds = true

        self.backButton = UIButton(frame: CGRectMake(0, 25, 45, 45))
        self.backButton.setImage(UIImage(named: "backButton"), forState: UIControlState.Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.backButton)
        
        self.contentView = UIView(frame: CGRectMake(-screenWidth/3, screenHeight/2.5, screenHeight/1.5, screenHeight/1.5))
        self.contentView.backgroundColor = oficialMediumGray
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = self.contentView.frame.size.height/2
        self.view.addSubview(self.contentView)
        
        self.username = self.contact.username
        self.trustLevel = 0 // PEGAR DAO PARSE
        
        //mostra o trust level do usuário
        self.trustLevelLabel = UILabel(frame: CGRectMake(20, screenHeight/2.5 + screenWidth/6, screenWidth/2, screenWidth/7))
        self.trustLevelLabel.text = "\(self.trustLevel)%"
        self.trustLevelLabel.font = UIFont(name: "Helvetica", size: 40)
        self.trustLevelLabel.textAlignment = .Left
        self.trustLevelLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(self.trustLevelLabel)
        
        //mostra o nome do usuário
        self.usernameLabel = UILabel(frame: CGRectMake(20, screenHeight/2.5 + screenWidth/6 + self.trustLevelLabel.frame.size.height, screenWidth/3 * 2, self.trustLevelLabel.frame.size.height/2))
        self.usernameLabel.text = self.username
        self.usernameLabel.font = UIFont(name: "Helvetica", size: 20)
        self.usernameLabel.textColor = UIColor.whiteColor()
        self.usernameLabel.textAlignment = .Left
        self.view.addSubview(self.usernameLabel)
        
        //mostra a imagem do usuário
        self.contactImage = UIImageView(frame: CGRectMake(screenWidth/7 * 2 + 10, screenHeight/5, screenWidth/2, screenWidth/2))
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.height/2
        self.contactImage.clipsToBounds = true
        self.contactImage.image = DAOUser.sharedInstance.getProfileImage()
        self.contactImage.image = UIImage(data: self.contact.profileImage!)
        self.view.addSubview(self.contactImage)



        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        addCircleView()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addCircleView()
    {
        let circleWidth = screenWidth/1.95
        let circleHeight = screenWidth/1.95
        
        // Create a new CircleView
        let circleView = CircleView(frame: CGRectMake(0, 0, circleWidth, circleHeight))
        
        circleView.center = CGPointMake(self.contactImage.center.x, self.contactImage.center.y)
        
        circleView.setColor(self.trustLevel)
        
        view.addSubview(circleView)
        
        // Animate the drawing of the circle over the course of 1 second
        
        DAOParse.getTrustLevel(self.contact.username) { (trustLevel) -> Void in
            
            if(trustLevel != nil)
            {
                circleView.animateCircle(1.0, trustLevel: trustLevel!)
                self.trustLevelLabel.text = "\(trustLevel!)%"
            }
            
        }
    }


}
