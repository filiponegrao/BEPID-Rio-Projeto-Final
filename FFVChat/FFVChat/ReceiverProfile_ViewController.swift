//
//  ReceiverProfile_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class ReceiverProfile_ViewController: UIViewController, UIViewControllerTransitioningDelegate
{
    let transition = BubbleTransition()

    var contactImage: UIButton!
    
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
    
    var background : UIImageView!
    
    var alert : UITextView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialDarkGray
        self.view.clipsToBounds = true

        self.background = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.background.image = UIImage(named: "ContactBackground")
        self.background.alpha = 0.6
        self.view.addSubview(self.background)
        
        self.backButton = UIButton(frame: CGRectMake(0, 25, 45, 45))
        self.backButton.setImage(UIImage(named: "backButton"), forState: UIControlState.Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.backButton)
        
        self.contentView = UIView(frame: CGRectMake(-screenWidth/3, screenHeight/2.5, screenHeight/1.5, screenHeight/1.5))
        self.contentView.backgroundColor = oficialDarkGray
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = self.contentView.frame.size.height/2
        self.view.addSubview(self.contentView)
        
        self.username = self.contact.username
        self.trustLevel = 0 // PEGAR DAO PARSE
        self.userSince = self.contact.createdAt
        print(self.userSince)
        
        //mostra o trust level do usuário
        self.trustLevelLabel = UILabel(frame: CGRectMake(20, screenHeight/2.4 + screenWidth/6, screenWidth/2, screenWidth/6))
        self.trustLevelLabel.text = "\(self.trustLevel)%"
        self.trustLevelLabel.font = UIFont(name: "SukhumvitSet-Medium", size: 40)
        self.trustLevelLabel.setSizeFont(40)
        self.trustLevelLabel.textAlignment = .Left
        self.trustLevelLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(self.trustLevelLabel)
        
        //mostra o nome do usuário
        self.usernameLabel = UILabel(frame: CGRectMake(20, screenHeight/2.5 + screenWidth/6 + self.trustLevelLabel.frame.size.height - 5, screenHeight/1.5, self.trustLevelLabel.frame.size.height/2 + 5))
        self.usernameLabel.text = self.username
        self.usernameLabel.font = UIFont(name: "SukhumvitSet-Text", size: 25)
        self.usernameLabel.setSizeFont(22)
        self.usernameLabel.textColor = oficialGreen
        self.usernameLabel.textAlignment = .Left
        self.view.addSubview(self.usernameLabel)
        
        let date = self.userSince
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let sync = dateFormatter.stringFromDate(date)
        
        
        //mostra desde quando é usuário do app
        self.userSinceLabel = UILabel(frame: CGRectMake(20, screenHeight/2.5 + screenWidth/6 + self.trustLevelLabel.frame.size.height + self.usernameLabel.frame.size.height + 10, screenWidth/3 * 2, self.usernameLabel.frame.size.height))
        self.userSinceLabel.text = "User since: " + sync
        self.userSinceLabel.textColor = UIColor.whiteColor()
        self.userSinceLabel.textAlignment = .Left
        self.userSinceLabel.font = UIFont(name: "SukhumvitSet-Light", size: 17)
        self.userSinceLabel.setSizeFont(17)
        self.view.addSubview(self.userSinceLabel)
        
        //mostra quantos prints o usuário tirou
        
        self.screenshotsLabel = UILabel(frame: CGRectMake(20, screenHeight/2.5 + screenWidth/6 + self.trustLevelLabel.frame.size.height + self.usernameLabel.frame.size.height + self.userSinceLabel.frame.size.height + 10, screenWidth/3 * 2, self.userSinceLabel.frame.size.height))
        self.screenshotsLabel.textColor = UIColor.whiteColor()
        self.screenshotsLabel.textAlignment = .Left
        self.screenshotsLabel.font = UIFont(name: "SukhumvitSet-Light", size: 17)
        self.screenshotsLabel.setSizeFont(17)
        
        let text = "Screenshots: \(DAOPrints.sharedInstance.getNumberOfPrintScreens(self.contact.username)) (of your pics)"
        let mutable = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: UIFont(name: "SukhumvitSet-Light", size: 17)!])
        mutable.addAttribute(NSForegroundColorAttributeName, value: oficialLightGray, range: NSRange(location: 15, length: 14))
        
        self.screenshotsLabel.attributedText = mutable
        
        self.view.addSubview(self.screenshotsLabel)
        
        //mostra quantas denúncias o usuário tem
        self.reportsLabel = UILabel(frame: CGRectMake(20, screenHeight/2.5 + screenWidth/6 + self.trustLevelLabel.frame.size.height + self.usernameLabel.frame.size.height + self.userSinceLabel.frame.size.height + self.screenshotsLabel.frame.size.height + 5, screenWidth/3 * 2, self.userSinceLabel.frame.size.height))
        self.reportsLabel.text = "Reports: "
        self.reportsLabel.textColor = UIColor.whiteColor()
        self.reportsLabel.textAlignment = .Left
        self.reportsLabel.font = UIFont(name: "Sukhumvit Set", size: 17)
        self.reportsLabel.setSizeFont(17)
        self.reportsLabel.hidden = true
        self.view.addSubview(self.reportsLabel)
        
        //mostra a imagem do usuário
        self.contactImage = UIButton(frame: CGRectMake(screenWidth/7 * 2 + 10, screenHeight/5, screenWidth/2, screenWidth/2))
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.height/2
        self.contactImage.clipsToBounds = true
        self.contactImage.setImage(UIImage(data: self.contact.profileImage!), forState: .Normal)
        self.contactImage.addTarget(self, action: "zoomImage", forControlEvents: .TouchUpInside)
        self.contactImage.backgroundColor = oficialDarkGray
        self.view.addSubview(self.contactImage)

        self.alert = UITextView(frame: CGRectMake(0, 0, self.screenshotsLabel.frame.size.width, screenWidth/4))
        self.alert.center = CGPointMake(self.screenshotsLabel.center.x - 5, self.screenshotsLabel.center.y + self.screenshotsLabel.frame.size.height + 35)
        self.alert.text = "The #trustLevel is affected by screenshots taken into the App."
        self.alert.textColor = oficialLightGray
        self.alert.backgroundColor = UIColor.clearColor()
        self.alert.font = UIFont(name: "Helvetica-Light", size: 14)
        self.alert.textAlignment = .Left
        self.view.addSubview(self.alert)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        addCircleView()
        
        self.view.bringSubviewToFront(self.contactImage)
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
        
        self.trustLevel = Int(self.contact.trustLevel)
        self.trustLevelLabel.text = "\(self.trustLevel)%"
        
        circleView.setColor(self.trustLevel)
        circleView.animateCircle(1.0, trustLevel: self.trustLevel)
        
        
        view.addSubview(circleView)
        
    }
    
    func zoomImage()
    {
        let zoom = ImageViewController(image: UIImage(data: self.contact.profileImage)!)
        self.transition.duration = 0.3
        
        zoom.transitioningDelegate = self
        zoom.modalInPopover = true
        zoom.modalPresentationStyle = .Custom
        
        self.presentViewController(zoom, animated: true) { () -> Void in
        
        }
    }
    
    /**####################### BUBLE TRANSITION ################### */
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = self.contactImage.center
        transition.bubbleColor = self.contactImage.backgroundColor!
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = self.contactImage.center
        transition.bubbleColor = self.contactImage.backgroundColor!
        return transition
    }


}
