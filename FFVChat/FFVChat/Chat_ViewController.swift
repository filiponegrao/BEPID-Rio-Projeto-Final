//
//  Chat_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

let navigationBarHeigth : CGFloat = 80

let messageViewHeigth : CGFloat = 50

let tableViewHeigth : CGFloat = screenHeight - navigationBarHeigth - messageViewHeigth

class Chat_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    var imageZoom : ImageZoom_View!
    
    var tableView: UITableView!
    
    var messages = [Message]()
    
    var contact : Contact!
    
    var navBar : NavigationChat_View!
    
    var containerView : UIView!
    
    var messageView : UIView!
    
    var messageText : UITextView!
    
    var cameraButton : UIButton!
    
    var sendButton : UIButton!
    
    var imagePicker : UIImagePickerController!
    
    var redScreen : UIView!
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didTakeScreenShot", name: UIApplicationUserDidTakeScreenshotNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadMessages", name: appNotification.messageReceived.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageEvaporated:", name: "messageEvaporated", object: nil)

        
        DAOMessages.sharedInstance.receiveMessagesFromContact()
        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        self.tableView.reloadData()
        
        self.tableViewScrollToBottom(false)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: appNotification.messageReceived.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationUserDidTakeScreenshotNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "messageEvaporated", object: nil)

    }
    
    func reloadTrustLevel()
    {
        DAOParse.getTrustLevel(self.contact.username) { (trustLevel) -> Void in
            
            if(trustLevel != nil)
            {
                self.redScreen.alpha = CGFloat(100 - CGFloat(trustLevel!))/100
            }
        }
    }
    
    func messageSent()
    {
        
    }
    
    
    func messageEvaporated(notification: NSNotification)
    {
        let info : [NSObject : AnyObject] = notification.userInfo!
        let index = info["index"] as! Int
        print("Meu indicie é \(index) e minha abela tem \(self.messages.count)")
        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        print("agora minha tabela tem \(self.messages.count) linhas e eu vou apagar a lnha \(index)")
        self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Top)
        self.imageZoom?.fadeOut()
    }
    
    
    func reloadMessages()
    {
        if(DAOMessages.sharedInstance.lastMessage.sender == self.contact.username)
        {
            self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
            let index = self.messages.indexOf(DAOMessages.sharedInstance.lastMessage)!
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Top)
            self.tableViewScrollToBottom(false)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = oficialMediumGray
//        badTrustNav
        self.navBar = NavigationChat_View(requester: self)
        self.navBar.layer.zPosition = 5
        self.view.addSubview(self.navBar)
        
        self.containerView = UIView(frame: CGRectMake(0, self.navBar.frame.size.height, screenWidth, screenHeight - self.navBar.frame.size.height))
        self.containerView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(containerView)
        
        self.redScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.redScreen.backgroundColor = UIColor.redColor()
        self.redScreen.alpha = 0
//        self.containerView.addSubview(self.redScreen)
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, tableViewHeigth))
        self.tableView.registerClass(CellChat_TableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(CellImage_TableViewCell.self, forCellReuseIdentifier: "ImageCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.zPosition = 0
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.containerView.addSubview(tableView)
        
        self.messageView = UIView(frame: CGRectMake(0, self.containerView.frame.height - 50, screenWidth, messageViewHeigth))
        self.messageView.backgroundColor = oficialDarkGray
        self.containerView.addSubview(messageView)
        
        self.cameraButton = UIButton(frame: CGRectMake(5, 5 , self.messageView.frame.size.height - 10, self.messageView.frame.size.height - 10))
        self.cameraButton.setImage(UIImage(named: "chatCameraButton"), forState: UIControlState.Normal)
        self.cameraButton.alpha = 0.7
//        self.cameraButton.backgroundColor = UIColor.grayColor()
        self.cameraButton.addTarget(self, action: "takePhoto", forControlEvents: UIControlEvents.TouchUpInside)
        self.messageView.addSubview(cameraButton)
        
        self.sendButton = UIButton(frame: CGRectMake(screenWidth - screenWidth/4, 0, screenWidth/4, self.messageView.frame.size.height))
        self.sendButton.setTitle("Send", forState: UIControlState.Normal)
        self.sendButton.setTitleColor(oficialGreen, forState: UIControlState.Normal)
        self.sendButton.addTarget(self, action: "sendMessage", forControlEvents: UIControlEvents.TouchUpInside)
        self.messageView.addSubview(sendButton)
        
        self.messageText = UITextView(frame: CGRectMake(self.cameraButton.frame.width + 5, 10, screenWidth - (self.cameraButton.frame.size.width + self.sendButton.frame.size.width), self.messageView.frame.size.height - 20))
        self.messageText.autocorrectionType = UITextAutocorrectionType.Yes
        self.messageText.font = UIFont(name: "Helvetica", size: 16)
        self.messageText.textContainer.lineFragmentPadding = 10;
        self.messageText.text = "Message..."
        self.messageText.textAlignment = .Left
        self.messageText.textColor = oficialLightGray
        self.messageText.backgroundColor = UIColor.clearColor()
        self.messageText.delegate = self
        self.messageText.keyboardAppearance = .Dark
        self.messageView.addSubview(self.messageText)

        self.navBar.contactImage.setImage(UIImage(data: self.contact.profileImage!), forState: UIControlState.Normal)
        
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
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
            {
                self.containerView.frame.size.height = screenHeight - navigationBarHeigth - keyboardSize.height
                self.messageView.frame.origin.y = self.containerView.frame.size.height - 50
                self.tableView.frame.size.height = tableViewHeigth - keyboardSize.height

                if(self.tableView.contentSize.height > self.tableView.frame.size.height)
                {
                    self.tableView.contentOffset.y += keyboardSize.height
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.containerView.frame.size.height = screenHeight - navigationBarHeigth
        self.messageView.frame.origin.y = self.containerView.frame.size.height - 50
        self.tableView.frame.size.height = tableViewHeigth
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        print("viado");
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
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        //IMAGE
        if(self.messages[indexPath.row].text == nil && self.messages[indexPath.row].image != nil)
        {
            return cellBackgroundWidth + 10
        }
        //TEXT
        else
        {
            let necessaryHeigth = self.heightForView(self.messages[indexPath.row].text!, font: textMessageFont!, width: cellTextWidth)
            let textHeight = cellTextHeigth
            
            if(necessaryHeigth > textHeight)
            {
                let increase = necessaryHeigth - textHeight
                return cellHeightDefault + increase
                
            }
            else
            {
                return cellHeightDefault
            }
        }
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
        //IMAGE
        if(self.messages[indexPath.row].text == nil  && self.messages[indexPath.row].image != nil)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! CellImage_TableViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.imageCell.image = UIImage(data: self.messages[indexPath.row].image!)
            
            //blur
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
            
            visualEffectView.frame = cell.imageCell.bounds
            cell.imageCell.subviews.last?.removeFromSuperview()
            cell.imageCell.addSubview(visualEffectView)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .LongStyle
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
//            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            dateFormatter.dateFormat = "HH:mm"
            let date = dateFormatter.stringFromDate(self.messages[indexPath.row].sentDate)
            cell.sentDate.text = date
            
            cell.backgroundLabel.layer.cornerRadius = 4
            cell.backgroundLabel.layer.shadowColor = UIColor.blackColor().CGColor
            cell.backgroundLabel.layer.shadowOffset = CGSizeMake(5, 5)
            cell.backgroundLabel.layer.shadowRadius = 3
            cell.backgroundLabel.layer.shadowOpacity = 1
            cell.backgroundLabel.layer.masksToBounds = false
            cell.backgroundLabel.layer.shadowPath = UIBezierPath(roundedRect: cell.backgroundLabel.bounds, cornerRadius: cell.backgroundLabel.layer.cornerRadius).CGPath
            
            if(self.messages[indexPath.row].sender == DAOUser.sharedInstance.getUserName())
            {
                cell.backgroundLabel.alpha = 0.2
            }
            else
            {
                cell.backgroundLabel.alpha = 0.1
            }
            
            return cell
        }
        //TEXT
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellChat_TableViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            //adiciona mensagens do array
                        
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .LongStyle
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
//            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            dateFormatter.dateFormat = "HH:mm"
            let date = dateFormatter.stringFromDate(self.messages[indexPath.row].sentDate)
            
            cell.textMessage.text = self.messages[indexPath.row].text
            cell.sentDate.text = date
            //Verificando o tamanho
            let necessaryHeigth = self.heightForView(self.messages[indexPath.row].text!, font: textMessageFont!, width: cellTextWidth)
            if(necessaryHeigth > cellTextHeigth)
            {
                let increase = necessaryHeigth - cellTextHeigth
                cell.backgroundLabel.frame.size.height = cellBackgroundHeigth + increase
                cell.textMessage.frame.size.height = cellTextHeigth + increase
                cell.sentDate.frame.origin.y = cell.textMessage.frame.origin.y + cell.textMessage.frame.size.height + 5
            }
            
            cell.backgroundLabel.layer.cornerRadius = 4
            cell.backgroundLabel.layer.shadowColor = UIColor.blackColor().CGColor
            cell.backgroundLabel.layer.shadowOffset = CGSizeMake(5, 5)
            cell.backgroundLabel.layer.shadowRadius = 3
            cell.backgroundLabel.layer.shadowOpacity = 1
            cell.backgroundLabel.layer.masksToBounds = false
            cell.backgroundLabel.layer.shadowPath = UIBezierPath(roundedRect: cell.backgroundLabel.bounds, cornerRadius: cell.backgroundLabel.layer.cornerRadius).CGPath
            
            if(self.messages[indexPath.row].sender == DAOUser.sharedInstance.getUserName())
            {
                cell.backgroundLabel.alpha = 0.2
            }
            else
            {
                cell.backgroundLabel.alpha = 0.08
            }
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("clicando")
        self.messageText.endEditing(true)
        let message = self.messages[indexPath.row]
        if(message.image != nil)
        {
            self.imageZoom = ImageZoom_View(image: UIImage(data: message.image!)!)
            self.view.addSubview(self.imageZoom)
            
            print(message.status)
            if(message.sender != DAOUser.sharedInstance.getUserName() && message.status == "unseen")
            {
                DAOMessages.sharedInstance.deleteMessageAfterTime(message)
                message.status = "seen"
            }
        }
        
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
    
    //****************************************************//
    //*********** END TABLE VIEW PROPERTIES **************//
    //****************************************************//
    
    
    
    //****************************************************//
    //*********** TEXT VIEW DELEGATES ********************//
    //****************************************************//
    func textViewDidBeginEditing(textView: UITextView)
    {
        if(textView.text == "Message...")
        {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        if(textView.text == "")
        {
            textView.text = "Message..."
        }
    }
    
    func textViewDidChange(textView: UITextView)
    {
        let frame = self.messageText.frame
        
        let h = self.messageText.contentSize.height
        
        if(h > frame.size.height)
        {
            self.expandTextField()
        }
        else if(h < frame.size.height)
        {
            self.reduceTextField()
        }
    }
    
    func expandTextField()
    {
        let frame = self.messageText.frame
        
        let h = self.messageText.contentSize.height
        
        let plus = h - frame.size.height
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.messageView.frame.origin.y -= plus
            self.messageView.frame.size.height += plus
            self.tableView.frame.size.height -= plus
            self.messageText.frame.size.height += plus
            
            }) { (success: Bool) -> Void in
        }
    }
    
    func reduceTextField()
    {
        let frame = self.messageText.frame
        
        let h = self.messageText.contentSize.height
        
        let plus = frame.size.height - h
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.messageView.frame.origin.y += plus
            self.messageView.frame.size.height -= plus
            self.tableView.frame.size.height += plus
            self.messageText.frame.size.height -= plus
            
            }) { (success: Bool) -> Void in
        }
    }
    
    func backToOriginal()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.messageView.frame.origin.y = self.containerView.frame.size.height - 50
            self.messageView.frame.size.height = 50
            self.tableView.frame.size.height = self.containerView.frame.size.height - 50
            self.messageText.frame.size.height = self.messageView.frame.size.height - 20
            
            }) { (success: Bool) -> Void in
        }
    }
    
    func endEditing()
    {
        self.messageText.endEditing(true)
    }

    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    //****************************************************//
    //***********  END TEXT VIEW DELEGATES ***************//
    //****************************************************//
    
    

    //****************************************************//
    //*********** MESSAGE FUNCTIONS AND HANDLES  *********//
    //****************************************************//
    
    func takePhoto()
    {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .Camera
        self.imagePicker.cameraDevice = .Front
        
        presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let message = DAOMessages.sharedInstance.sendMessage(self.contact.username, image: image, lifeTime: 60)
        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        let index = self.messages.indexOf(message)
        
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Automatic)
        
        self.tableViewScrollToBottom(false)
    }
    
    
    func sendMessage()
    {
        if (self.messageText.text?.characters.count > 0 && self.messageText.text != "Message...")
        {
            let message = DAOMessages.sharedInstance.sendMessage(self.contact.username, text: self.messageText.text!)
            self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
            let index = self.messages.indexOf(message)
            
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Top)
            let h = self.heightForView(self.messageText.text!, font: fontCell!, width: cellBackgroundWidth)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.tableView.contentOffset.y += (h + cellBackgroundHeigth + margemVertical)
                
                }, completion: { (success: Bool) -> Void in
                    
            })
            
            self.messageText.text = ""
            self.backToOriginal()
        }
    }
    
    //****************************************************//
    //******* END MESSAGE FUNCTIONS AND HANDLES  *********//
    //****************************************************//
    
    
    func didTakeScreenShot()
    {
        let alert = JudgerAlert_ViewController()
        alert.modalPresentationStyle = .OverFullScreen
        self.presentViewController(alert, animated: true) { () -> Void in
            
        }
    }
    
    
}
