//
//  Chat_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Chat_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{

    var tableView: UITableView!
    
    var senderMessages = ["Hello", "Good to see you"]
    var receiverMessages = ["Hi", "Manda nudes!" ]
    
    var contacts : Contact!
    
    var navBar : NavigationChat_View!
    
    var messageView : UIView!
    
    var messageText : UITextField!
    
    var cameraButton : UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = lightGray
        
        self.navBar = NavigationChat_View(requester: self)
        self.navBar.layer.zPosition = 5
        self.view.addSubview(self.navBar)
        
        self.tableView = UITableView(frame: CGRectMake(0, 80, screenWidth, screenHeight))
        self.tableView.registerClass(CellChat_TableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.zPosition = 0
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(tableView)
        
        self.messageView = UIView(frame: CGRectMake(0, screenHeight - 50, screenWidth, 50))
        self.messageView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(messageView)
        
        self.cameraButton = UIButton(frame: CGRectMake(10, 15 , 30, 20))
        self.cameraButton.setImage(UIImage(named: "cameraChatButton"), forState: UIControlState.Normal)
        self.cameraButton.alpha = 0.7
        self.messageView.addSubview(cameraButton)
        
        self.messageText = UITextField(frame: CGRectMake(50, 10, screenWidth - 60, 30))
        self.messageText.delegate = self
        self.messageText.borderStyle = UITextBorderStyle.RoundedRect
        self.messageText.placeholder = "Message"
        self.messageView.addSubview(messageText)
        
        print(DAOUser.sharedInstance.getUserName())
        print(DAOUser.sharedInstance.getEmail())
        print(DAOUser.sharedInstance.getPassword())
        print(DAOUser.sharedInstance.getTrustLevel())
        print(DAOUser.sharedInstance.getProfileImage())
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.messageText.endEditing(true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let message = self.senderMessages[0]
        let currentMessage : NSString = message as NSString
        let messageSize : CGSize! = currentMessage.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14.0)])
        return messageSize.height + 48
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ((self.senderMessages.count) + (self.receiverMessages.count))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellChat_TableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.messageText.endEditing(true)
    }
    
}
