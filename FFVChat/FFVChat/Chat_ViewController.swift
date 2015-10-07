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
    
    var contact : Contact!
    
    var navBar : NavigationChat_View!
    
    var containerView : UIView!
    
    var messageView : UIView!
    
    var messageText : UITextField!
    
    var cameraButton : UIButton!
    
    var sendButton : UIButton!
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        

    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = lightGray
        
        self.navBar = NavigationChat_View(requester: self)
        self.navBar.layer.zPosition = 5
        self.view.addSubview(self.navBar)
        
        self.containerView = UIView(frame: CGRectMake(0, 80, screenWidth, screenHeight - 80))
        self.containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "EndEditing"))
        self.view.addSubview(containerView)
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, self.containerView.frame.height - 50))
        self.tableView.registerClass(CellChat_TableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.zPosition = 0
        self.tableView.backgroundColor = UIColor.clearColor()
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.containerView.addSubview(tableView)
        
        self.messageView = UIView(frame: CGRectMake(0, self.containerView.frame.height - 50, screenWidth, 50))
        self.messageView.backgroundColor = UIColor.whiteColor()
        self.containerView.addSubview(messageView)
        
        self.cameraButton = UIButton(frame: CGRectMake(10, 15 , 30, 20))
        self.cameraButton.setImage(UIImage(named: "cameraChatButton"), forState: UIControlState.Normal)
        self.cameraButton.alpha = 0.7
        self.cameraButton.backgroundColor = UIColor.grayColor()
        self.messageView.addSubview(cameraButton)
        
        self.sendButton = UIButton(frame: CGRectMake(self.messageView.frame.width - 65, 17, 55, 16))
        self.sendButton.setTitle("Send", forState: UIControlState.Normal)
        self.sendButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.messageView.addSubview(sendButton)
        
        self.messageText = UITextField(frame: CGRectMake(self.cameraButton.frame.width + 20, 10, screenWidth - (self.cameraButton.frame.width + 20 + self.sendButton.frame.width + 20), 30))
        self.messageText.delegate = self
        self.messageText.borderStyle = UITextBorderStyle.RoundedRect
        self.messageText.placeholder = "Message"
        self.messageText.autocorrectionType = UITextAutocorrectionType.Yes
        self.messageView.addSubview(messageText)

        
        self.navBar.contactImage.image = contact.thumb
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    
    //Sobe a view e desce a view
    func keyboardWillShow(notification: NSNotification)
    {
        if(self.view.frame.origin.y == 0)
        {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.containerView.frame.origin.y = -keyboardSize.height + 80
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.containerView.frame.origin.y = 80
        }
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.messageText.endEditing(true)
        print("touches")
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
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.messageText.endEditing(true)
        print("didSelected")
    }
    
    func EndEditing()
    {
        self.containerView.endEditing(true)
        print("container did editing")
    }
    
}
