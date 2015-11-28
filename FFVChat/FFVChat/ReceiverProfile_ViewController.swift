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
    
    var userSince: NSDate!
    
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
        self.userSince = self.contact.createdAt
        print(self.userSince)
        
        //mostra o trust level do usuário
        self.trustLevelLabel = UILabel(frame: CGRectMake(20, screenHeight/2.5 + screenWidth/6, screenWidth/2, screenWidth/6))
        self.trustLevelLabel.text = "\(self.trustLevel)%"
        self.trustLevelLabel.font = UIFont(name: "Sukhumvit Set", size: 40)
        self.trustLevelLabel.setSizeFont(40)
        self.trustLevelLabel.textAlignment = .Left
        self.trustLevelLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(self.trustLevelLabel)
        
        //mostra o nome do usuário
        self.usernameLabel = UILabel(frame: CGRectMake(20, screenHeight/2.5 + screenWidth/6 + self.trustLevelLabel.frame.size.height, screenHeight/1.5, self.trustLevelLabel.frame.size.height/2 + 5))
        self.usernameLabel.text = self.username
        self.usernameLabel.font = UIFont(name: "Sukhumvit Set", size: 25)
        self.usernameLabel.setSizeFont(22)
        self.usernameLabel.textColor = UIColor.whiteColor()
        self.usernameLabel.textAlignment = .Left
        self.view.addSubview(self.usernameLabel)
        
        let date = self.userSince
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let sync = dateFormatter.stringFromDate(date)
        
        
        //mostra desde quando é usuário do app
        self.userSinceLabel = UILabel(frame: CGRectMake(20,screenHeight/2.5 + screenWidth/6 + self.trustLevelLabel.frame.size.height + self.usernameLabel.frame.size.height + 15, screenWidth/3 * 2, self.usernameLabel.frame.size.height))
        self.userSinceLabel.text = "User since: " + sync
        self.userSinceLabel.textColor = UIColor.whiteColor()
        self.userSinceLabel.textAlignment = .Left
        self.userSinceLabel.font = UIFont(name: "Sukhumvit Set", size: 17)
        self.userSinceLabel.setSizeFont(17)
        self.view.addSubview(self.userSinceLabel)
        
        //mostra quantos prints o usuário tirou
        self.screenshotsLabel = UILabel(frame: CGRectMake(20, screenHeight/2.5 + screenWidth/6 + self.trustLevelLabel.frame.size.height + self.usernameLabel.frame.size.height + self.userSinceLabel.frame.size.height + 10, screenWidth/3 * 2, self.userSinceLabel.frame.size.height))
        self.screenshotsLabel.text = "Screenshots: "
        self.screenshotsLabel.textColor = UIColor.whiteColor()
        self.screenshotsLabel.textAlignment = .Left
        self.screenshotsLabel.font = UIFont(name: "Sukhumvit Set", size: 17)
        self.screenshotsLabel.setSizeFont(17)
        self.view.addSubview(self.screenshotsLabel)
        
        //mostra quantas denúncias o usuário tem
        self.reportsLabel = UILabel(frame: CGRectMake(20, screenHeight/2.5 + screenWidth/6 + self.trustLevelLabel.frame.size.height + self.usernameLabel.frame.size.height + self.userSinceLabel.frame.size.height + self.screenshotsLabel.frame.size.height + 5, screenWidth/3 * 2, self.userSinceLabel.frame.size.height))
        self.reportsLabel.text = "Reports: "
        self.reportsLabel.textColor = UIColor.whiteColor()
        self.reportsLabel.textAlignment = .Left
        self.reportsLabel.font = UIFont(name: "Sukhumvit Set", size: 17)
        self.reportsLabel.setSizeFont(17)
        self.view.addSubview(self.reportsLabel)
        
        //mostra a imagem do usuário
        self.contactImage = UIImageView(frame: CGRectMake(screenWidth/7 * 2 + 10, screenHeight/5, screenWidth/2, screenWidth/2))
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.height/2
        self.contactImage.clipsToBounds = true
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
        
        DAOParse.getTrustLevel(self.contact.username) { (trustLevel) -> Void in
            
            if(trustLevel != nil)
            {
                self.trustLevel = trustLevel
                self.trustLevelLabel.text = "\(self.trustLevel)%"
                
                circleView.setColor(self.trustLevel)
                circleView.animateCircle(1.0, trustLevel: self.trustLevel)
            }
            
        }
        
        view.addSubview(circleView)
        
    }


}
