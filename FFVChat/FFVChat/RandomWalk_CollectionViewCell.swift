//
//  RandomWalk_CollectionViewCell.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/13/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class RandomWalk_CollectionViewCell: UICollectionViewCell
{
    var container : UIView!
    
    var username: UILabel!
    
    var profileBtn: BubbleButton!
    
    var numberOfMessages : UILabel!
    
    var indicator : UILabel!
    
    weak var contactsController : Home_ViewController!
    
    var index : Int!
    
    // animate variables
    private var animate = false
    
    private var paths:[CGPoint] = []
    
    private var stepDuration : Double!
    
    private var duration: Double!
    
    // MARK: - Init and Cell Layout Setup
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.container = UIView(frame: CGRectMake(0, 0, self.frame.width, self.frame.width))
        self.container.backgroundColor = UIColor.clearColor()
        self.addSubview(self.container)
        
        self.username = UILabel(frame: CGRectMake(0,0,frame.size.width,40))
        self.username.textAlignment = NSTextAlignment.Center
//        self.username.font = UIFont( name: (username.font?.fontName)!, size: 13)
        self.username.font = UIFont(name: "SukhumvitSet-Text", size: 13)
        self.username.textColor = oficialGreen
        self.addSubview(self.username)
        
        self.profileBtn = BubbleButton(radius: self.frame.width)
        self.profileBtn.layer.borderWidth = 2.0
        self.profileBtn.layer.borderColor = UIColor.grayColor().CGColor
        self.profileBtn.contentMode = .ScaleToFill
        self.profileBtn.clipsToBounds = true
        self.profileBtn.addTargetOnEnd("openChat", target: self)
        self.container.addSubview(self.profileBtn)

        self.numberOfMessages = UILabel(frame: CGRectMake(self.frame.size.width-20,-5, self.profileBtn.frame.size.width/3, self.profileBtn.frame.size.width/3))
        self.numberOfMessages.text = "0"
        self.numberOfMessages.textAlignment = .Center
        self.numberOfMessages.backgroundColor = oficialRed
        self.numberOfMessages.textColor = UIColor.whiteColor()
        self.numberOfMessages.layer.cornerRadius = self.numberOfMessages.frame.size.height/2
        self.numberOfMessages.clipsToBounds = true
        self.numberOfMessages.hidden = true
        self.container.addSubview(self.numberOfMessages)
        
        //        self.sendSubviewToBack(profileBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // NAO CONSIDERA NOME COMPOSTO... EXEMPLO: LUIS HAROLDO SOARES
    func setInfo(name:String, profile:UIImage)
    {
        self.username.text = name
        self.profileBtn.setImage(profile, forState: .Normal)
        
        let labelHeight:CGFloat = self.frame.height - self.frame.width
        self.username.frame = CGRectMake( 0, profileBtn.frame.maxY, self.frame.width, labelHeight )
    }
    
    
    func loadAnimations(withDuration:Double)
    {
        if animate
        {
            return
        }
        srandom(UInt32(time(nil)))
        
        let numberOfSteps = random()%5 + 3
        let numberOfPaths = random()%5 + 3
        self.stepDuration = 1 / (2 * Double(numberOfSteps * numberOfPaths))
        self.duration = withDuration
        
        let xRange = random()%5 + 3
        let yRange = random()%6 + 4
        
        paths = UsefulFunctions.randomWalk(withNumberOfSteps: numberOfSteps, withNumberOfPaths: numberOfPaths, xRange: xRange, yRange: yRange)
        
    }
    
    // MARK: - Animation Setup
    
    
    func startAnimation()
    {
        if(self.duration == nil) { self.loadAnimations(45) }
        UIView.animateKeyframesWithDuration(self.duration, delay: 0.0, options: [.Repeat, .BeginFromCurrentState, .CalculationModeCubicPaced, .AllowUserInteraction], animations:
            {
                () -> Void in
                
                for index in 0..<self.paths.count
                {
                    UIView.addKeyframeWithRelativeStartTime(self.stepDuration * Double(index), relativeDuration: self.stepDuration, animations:
                        {
                            () -> Void in
                            self.container.center.x += self.paths[index].x
                            self.container.center.y += self.paths[index].y
                            
                    })
                }
            },
            completion: nil)
        
        animate = true
    }
    
    func setUnreadMessages(count: Int)
    {
        if(count > 0)
        {
            self.numberOfMessages.text = "\(count)"
            self.numberOfMessages.hidden = false
            
            let width = self.profileBtn.frame.size.width/3
            self.numberOfMessages.frame.size = CGSizeMake(1, 1)
            
            var size : CGSize!
            
            if(count > 9 && count < 99)
            {
                size = CGSizeMake(width+(width/5), width)
            }
            else if(count < 10)
            {
                size = CGSizeMake(width, width)
            }
            else
            {
                size = CGSizeMake(width*(3/2), width)
            }
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                self.numberOfMessages.frame.size = size
                
                }, completion: { (success: Bool) -> Void in
                    
            })
        }
        else
        {
            if(self.numberOfMessages.hidden)
            {
                //redundante, eu sei. Desnecessario na verdade, mas eu quero.
                self.numberOfMessages.hidden = true
            }
            else
            {
                let originalSize = self.numberOfMessages.frame.size
                
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    
                    self.numberOfMessages.frame.size = CGSizeMake(1, 1)
                    
                    }, completion: { (success: Bool) -> Void in
                        
                        self.numberOfMessages.hidden = true
                        self.numberOfMessages.text = "0"
                        self.numberOfMessages.frame.size = originalSize
                })
            }
        }
    }
    
    func openChat()
    {
        let contact = DAOContacts.sharedInstance.getContactByUsername(self.username.text!)
//        let chat = Chat_ViewController(contact: contact!)
        
        var chat : Chat_ViewController!
        if(self.contactsController.chatController == nil)
        {
            chat = Chat_ViewController(contact: contact!, homeController: self.contactsController)
            self.contactsController.chatController = chat
        }
        else
        {
            self.contactsController.chatController.contact = contact
        }
        self.contactsController.navigationController?.pushViewController(self.contactsController.chatController, animated: true)
    }
    
    
}
