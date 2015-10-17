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
    
    var messages = [Message]()
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadMessages", name: appNotification.messageReady.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadMessages", name: appNotification.messageSent.rawValue, object: nil)
        
        DAOParseMessages.sharedInstance.checkForContactMessages(self.contact.username)
        
        self.messages = DAOParseMessages.sharedInstance.getMessages(self.contact.username)
        print(self.messages.count)

    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func reloadMessages()
    {
        self.messages = DAOParseMessages.sharedInstance.getMessages(self.contact.username)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = lightGray
        
        self.navBar = NavigationChat_View(requester: self)
        self.navBar.layer.zPosition = 5
        self.view.addSubview(self.navBar)
        
        self.containerView = UIView(frame: CGRectMake(0, self.navBar.frame.size.height, screenWidth, screenHeight - self.navBar.frame.size.height))
        self.containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "EndEditing"))
        self.containerView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(containerView)
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, self.containerView.frame.height - 50))
        self.tableView.registerClass(CellChat_TableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.zPosition = 0
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.containerView.addSubview(tableView)
        
        self.messageView = UIView(frame: CGRectMake(0, self.containerView.frame.height - 50, screenWidth, 50))
        self.messageView.backgroundColor = UIColor.whiteColor()
        self.containerView.addSubview(messageView)
        
        self.cameraButton = UIButton(frame: CGRectMake(10, 15 , 30, 20))
        self.cameraButton.setImage(UIImage(named: "cameraChatButton"), forState: UIControlState.Normal)
        self.cameraButton.alpha = 0.7
//        self.cameraButton.backgroundColor = UIColor.grayColor()
        self.messageView.addSubview(cameraButton)
        
        self.sendButton = UIButton(frame: CGRectMake(self.messageView.frame.width - 65, 5, 55, 40))
        self.sendButton.setTitle("Send", forState: UIControlState.Normal)
        self.sendButton.setTitleColor(oficialGreen, forState: UIControlState.Normal)
        self.sendButton.addTarget(self, action: "sendMessage", forControlEvents: UIControlEvents.TouchUpInside)
        self.messageView.addSubview(sendButton)
        
        self.messageText = UITextField(frame: CGRectMake(self.cameraButton.frame.width + 20, 10, screenWidth - (self.cameraButton.frame.width + 20 + self.sendButton.frame.width + 20), 30))
        self.messageText.delegate = self
        self.messageText.borderStyle = UITextBorderStyle.RoundedRect
        self.messageText.placeholder = "Message"
        self.messageText.autocorrectionType = UITextAutocorrectionType.Yes
        self.messageView.addSubview(messageText)

        self.navBar.contactImage.setImage(self.contact.thumb, forState: UIControlState.Normal)
        
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
            self.containerView.frame.origin.y = 82.5
        }
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.messageText.endEditing(true)
    }
    
    
    //****************************************************//
    //*********** TABLE VIEW PROPERTIES ******************//
    //****************************************************//
    
    //Espaçamento em baixo
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    //Espaçamento em cima
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    //View transparente do espaçamento de baixo
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let clear = UIView(frame: CGRectMake(0, 0, screenWidth, 10))
        clear.backgroundColor = UIColor.clearColor()
        return clear
    }
    
    //View transparente do espaçamento de cima
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let clear = UIView(frame: CGRectMake(0, 0, screenWidth, 10))
        clear.backgroundColor = UIColor.clearColor()
        return clear
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 40
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellChat_TableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        //adiciona mensagens do array
        cell.message.text = self.messages[indexPath.row].text
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.messageText.endEditing(true)
    }
    
    //****************************************************//
    //*********** END TABLE VIEW PROPERTIES **************//
    //****************************************************//
    
    
    func EndEditing()
    {
        self.containerView.endEditing(true)
    }
    
    func sendMessage()
    {
        if (self.messageText.text?.characters.count > 0)
        {            
            DAOParseMessages.sharedInstance.sendMessage(self.contact.username, text: self.messageText.text!, callback: { (ret) -> Void in
                
                if(ret == messageCondRet.unknowError)
                {
                    print("deu erro ao enviar mesangegem")
                }
                else
                {
//                    let lastPath = NSIndexPath(forRow: self.messages.count - 1, inSection: 0)
//                    self.tableView.beginUpdates()
//                    self.tableView.insertRowsAtIndexPaths([lastPath], withRowAnimation: .Automatic)
//                    self.tableView.contentSize = CGSize(width: self.tableView.contentSize.width, height: self.tableView.contentSize.height + self.tableView.rowHeight)
//                    self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentSize.height), animated: true)
//                    self.tableView.endUpdates()
//                    self.tableviewScroll(true)
                    
                    self.messageText.text = ""
                    DAOParseMessages.sharedInstance.checkForContactMessages(self.contact.username)
                }
                
            })
            
        }
    }
    
    func tableviewScroll(animated: Bool)
    {
        if (self.tableView.numberOfRowsInSection(0) > 0)
        {
//            let indexPath = NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0) - 1, inSection: (self.tableView.numberOfSections-1))
            
            let lastRowIndex = self.tableView.numberOfRowsInSection(0)
            let pathToLastRow = NSIndexPath(forRow: lastRowIndex - 1, inSection: 0)
            
            print(lastRowIndex)
            
            self.tableView.scrollToRowAtIndexPath(pathToLastRow, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
        }
        
    }
}
