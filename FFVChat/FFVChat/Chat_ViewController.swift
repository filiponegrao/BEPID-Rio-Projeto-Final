//
//  Chat_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit
import AVFoundation

let navigationBarHeigth : CGFloat = 80

let messageViewHeigth : CGFloat = 50

let tableViewHeigth : CGFloat = screenHeight - navigationBarHeigth - messageViewHeigth

class Chat_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    var imageZoom : ImageZoom_View!
    
    var tableView: UITableView!
    
    var backgorundImage : UIImageView!
    
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
    
    var messageSound: AVAudioPlayer!
    
    let fundos = ["fundoTeste0","fundoTeste1","fundoTeste2","fundoTeste3","fundoTeste4"]
    
    var fundosIndex = 0
    
    var isViewing : Bool = false
    
    init(contact: Contact)
    {
        self.contact = contact
        super.init(nibName: "Chat_ViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = oficialMediumGray
        
        self.navBar = NavigationChat_View(requester: self)
        self.navBar.layer.zPosition = 5
        self.view.addSubview(self.navBar)
        
        self.containerView = UIView(frame: CGRectMake(0, self.navBar.frame.size.height, screenWidth, screenHeight - self.navBar.frame.size.height))
        self.containerView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(containerView)
        
        //Só pro filipo que tem isso
        self.backgorundImage = UIImageView(frame: CGRectMake(0, 0, screenWidth, tableViewHeigth))
        self.backgorundImage.image = UIImage(named: self.fundos[self.fundosIndex])
        self.backgorundImage.contentMode = .ScaleAspectFill
        self.backgorundImage.alpha = 0.7
        self.containerView.addSubview(self.backgorundImage)
        
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, tableViewHeigth))
        self.tableView.registerClass(CellChat_TableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(CellImage_TableViewCell.self, forCellReuseIdentifier: "ImageCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.zPosition = 0
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.keyboardDismissMode = .Interactive
        
        let gesture = UISwipeGestureRecognizer(target: self, action: "changeBackground")
        gesture.direction = .Right
        self.view.addGestureRecognizer(gesture)
        
        self.redScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.redScreen.backgroundColor = badTrust
        self.redScreen.alpha = 0
        self.containerView.addSubview(self.redScreen)
        self.containerView.addSubview(tableView)
        
        self.messageView = UIView(frame: CGRectMake(0, self.containerView.frame.height - 50, screenWidth, messageViewHeigth))
        self.messageView.backgroundColor = oficialDarkGray
        self.containerView.addSubview(messageView)
        
        self.cameraButton = UIButton(frame: CGRectMake(5, 5 , self.messageView.frame.size.height - 10, self.messageView.frame.size.height - 10))
        self.cameraButton.setImage(UIImage(named: "chatCameraButton"), forState: UIControlState.Normal)
        self.cameraButton.alpha = 0.7
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
        self.messageText.keyboardDismissMode = .None
        self.messageView.addSubview(self.messageText)
        
        self.navBar.contactImage.setImage(UIImage(data: self.contact.profileImage!), forState: UIControlState.Normal)
        
        
    }
    
    //** FUNCOES DE APARICAO DA TELA E DESAPARECIMENTO DA MESMA **//
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didTakeScreenShot", name: UIApplicationUserDidTakeScreenshotNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addNewMessage", name: NotificationController.center.messageReceived.name, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageEvaporated:", name: "messageEvaporated", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadImageCell:", name: "imageLoaded", object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        self.tableView.reloadData()
        self.tableViewScrollToBottom(false)
        DAOPostgres.sharedInstance.startRefreshing()
        self.redAlertScreen()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationController.center.messageReceived.name, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationUserDidTakeScreenshotNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "messageEvaporated", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "imageLoaded", object: nil)
        
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        DAOPostgres.sharedInstance.stopRefreshing()
    }
    
    //** FIM DAS FUNCOES DE APARICAO DA TELA E DESAPARECIMENTO DA MESMA **//
    
    
    func redAlertScreen()
    {
        let trustLevel = Int(self.contact.trustLevel)
        if(trustLevel < 100)
        {
            self.redScreen.alpha = 1
            
            UIView.animateWithDuration(2, animations: { () -> Void in
                
                self.redScreen.alpha = 0
                
                }, completion: { (success: Bool) -> Void in
                    
            })
        }
    }
    
    func messageEvaporated(notification: NSNotification)
    {
        let info : [NSObject : AnyObject] = notification.userInfo!
        let index = info["index"] as! Int
        
        print("Meu indicie é \(index) e minha abela tem \(self.messages.count)")
        
        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        
        print("agora minha tabela tem \(self.messages.count) linhas e eu vou apagar a linha \(index)")
        
        if(index > self.messages.count)
        {
            self.tableView.reloadData()
            return
        }
        
        self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Top)
        self.imageZoom?.fadeOut()
        
    }
    
    func reloadImageCell(notification: NSNotification)
    {
        print("loading image")
        let info : [NSObject : AnyObject] = notification.userInfo!
        let key = info["messageKey"] as! String
        
        for mssg in self.messages
        {
            if(mssg.imageKey == key)
            {
                let index = self.messages.indexOf(mssg)!
                print("Atualizando")
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? CellImage_TableViewCell
                cell?.imageCell.image = UIImage(data: mssg.image!)
                cell?.setLoadingOff()
            }
        }
    }
    
    
    func addNewMessage()
    {
        if(DAOMessages.sharedInstance.lastMessage.sender == self.contact.username)
        {
            self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
            let mssg = DAOMessages.sharedInstance.lastMessage
            let index = self.messages.indexOf(mssg)!
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Top)
            
            self.playSound()
            
            if(mssg.sender != DAOUser.sharedInstance.getUsername() && mssg.status != "seen" && mssg.imageKey == nil)
            {
                DAOMessages.sharedInstance.deleteMessageAfterTime(mssg)
                mssg.status = "seen"
            }
            
            
            if(mssg.imageKey == nil && mssg.text != nil)
            {
                let h = self.heightForView(mssg.text!, font: textMessageFont!, width: cellTextWidth)
                if((self.tableView.contentSize.height + h) > self.tableView.frame.size.height)
                {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        self.tableView.contentOffset.y += (h + cellBackgroundHeigth + margemVertical*2) + 20 //+20 de margem, superior e inferiro
                        
                        }, completion: { (success: Bool) -> Void in
                            
                    })
                }
            }
            else
            {
                if((self.tableView.contentSize.height + screenWidth) > self.tableView.frame.size.height)
                {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        self.tableView.contentOffset.y += screenWidth + 20 //+20 de margem
                        
                        }, completion: { (success: Bool) -> Void in
                            
                    })
                }
            }
        }
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
                self.backgorundImage.frame.size.height = tableViewHeigth - keyboardSize.height
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
        self.containerView.frame.origin.y = navigationBarHeigth
        self.containerView.frame.size.height = screenHeight - navigationBarHeigth
        self.messageView.frame.origin.y = self.containerView.frame.size.height - 50
        self.tableView.frame.size.height = tableViewHeigth
        self.backgorundImage.frame.size.height = tableViewHeigth
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
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        //IMAGE
        if(self.messages[indexPath.row].text == nil && self.messages[indexPath.row].imageKey != nil)
        {
            return cellBackgroundWidth + 10
        }
            //TEXT
        else
        {
            return self.getPerfectCellHeigth(indexPath.row)
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
        if(self.messages[indexPath.row].text == nil  && self.messages[indexPath.row].imageKey != nil)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! CellImage_TableViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if(self.messages[indexPath.row].image != nil)
            {
                cell.imageCell.image = UIImage(data: self.messages[indexPath.row].image!)
                cell.setLoadingOff()
            }
            else
            {
                cell.imageCell.image = UIImage()
                cell.setLoading()
                DAOParse.sharedInstance.downloadImageForMessage(self.messages[indexPath.row])
            }
            
            //blur
            cell.blur?.removeFromSuperview()
            cell.blur = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
            cell.blur.frame = cell.imageCell.bounds
            cell.imageCell.addSubview(cell.blur)
            cell.bringSubviewToFront(cell.indicator)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .LongStyle
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            //            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            dateFormatter.dateFormat = "HH:mm"
            let date = dateFormatter.stringFromDate(self.messages[indexPath.row].sentDate)
            cell.sentDate.text = date
            
            
            if(self.messages[indexPath.row].sender == DAOUser.sharedInstance.getUsername())
            {
                cell.backgroundLabel.alpha = 0.35
            }
            else
            {
                cell.backgroundLabel.alpha = 0.1
            }
            
            cell.backgroundLabel.layer.shadowColor = UIColor.blackColor().CGColor
            cell.backgroundLabel.layer.shadowOffset = CGSizeMake(5, 5)
            cell.backgroundLabel.layer.shadowRadius = 3
            cell.backgroundLabel.layer.shadowOpacity = 1
            cell.backgroundLabel.layer.masksToBounds = false
            cell.backgroundLabel.layer.shadowPath = UIBezierPath(roundedRect: cell.backgroundLabel.bounds, cornerRadius: cell.backgroundLabel.layer.cornerRadius).CGPath
            
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
            
            cell.backgroundLabel.layer.shadowColor = UIColor.blackColor().CGColor
            cell.backgroundLabel.layer.shadowOffset = CGSizeMake(5, 5)
            cell.backgroundLabel.layer.shadowRadius = 3
            cell.backgroundLabel.layer.shadowOpacity = 1
            cell.backgroundLabel.layer.masksToBounds = false
            cell.backgroundLabel.layer.shadowPath = UIBezierPath(roundedRect: cell.backgroundLabel.bounds, cornerRadius: cell.backgroundLabel.layer.cornerRadius).CGPath
            
            if(self.messages[indexPath.row].sender == DAOUser.sharedInstance.getUsername())
            {
                cell.backgroundLabel.backgroundColor = UIColor.whiteColor()
                cell.backgroundLabel.alpha = 0.3
            }
            else
            {
                cell.backgroundLabel.backgroundColor = oficialDarkGray
                cell.backgroundLabel.alpha = 0.6
            }
            
            //Se for hyperlink
            if((cell.textMessage.text!.lowercaseString.rangeOfString("http://")) != nil)
            {
                cell.textMessage.textColor = oficialGreen
            }
            else
            {
                cell.textMessage.textColor = UIColor.whiteColor()
            }
            
            DAOMessages.sharedInstance.deleteMessageAfterTime(self.messages[indexPath.row])
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let message = self.messages[indexPath.row]
        
        //Imagem
        if(message.image != nil && !self.messageText.isFirstResponder())
        {
            self.messageText.endEditing(true)
            self.imageZoom = ImageZoom_View(image: UIImage(data: message.image!)!)
            self.imageZoom.chatController = self
            self.isViewing = true
            self.view.addSubview(self.imageZoom)
            
            print(message.status)
            if(message.sender != DAOUser.sharedInstance.getUsername() && message.status == "received")
            {
                DAOMessages.sharedInstance.deleteMessageAfterTime(message)
                message.status = "seen"
            }
        }
            //Hiperlynk
        else if(message.text?.lowercaseString.rangeOfString("http://") != nil)
        {
            let text = message.text!.lowercaseString
            var link = String()
            if(text.rangeOfString(" ") != nil)
            {
                link = text.sliceFrom("http://", to: " ")!
                link = "Http://" + link
            }
            else
            {
                link = text
            }
            
            UIApplication.sharedApplication().openURL(NSURL(string: link)!)
        }
        
        self.messageText.endEditing(true)
        
    }
    
    func tableViewScrollToBottom(animated: Bool)
    {
        let numberOfRows = tableView.numberOfRowsInSection(0)
        if numberOfRows > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfRows-1, inSection: 0), atScrollPosition: .Bottom, animated: animated)
        }
    }
    
    //****************************************************//
    //*********** END TABLE VIEW PROPERTIES **************//
    //****************************************************//
    
    func getPerfectCellHeigth(index: Int) -> CGFloat
    {
        let necessaryHeigth = self.heightForView(self.messages[index].text!, font: textMessageFont!, width: cellTextWidth)
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
        
        if(self.messageText.frame.size.height < screenHeight/5)
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.messageView.frame.origin.y -= plus
                self.messageView.frame.size.height += plus
                self.tableView.frame.size.height -= plus
                self.messageText.frame.size.height += plus
                
                }) { (success: Bool) -> Void in
            }
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
        // ******** PARA IMPLEMENTACAO DO GIF ************//
        
        //        let actionsheet = UIAlertController(title: "Choose media", message: nil, preferredStyle: .ActionSheet)
        //        actionsheet.addAction(UIAlertAction(title: "From Camera", style: .Default, handler: { (action: UIAlertAction) -> Void in
        //
        //            self.imagePicker = UIImagePickerController()
        //            self.imagePicker.delegate = self
        //            self.imagePicker.sourceType = .Camera
        //            self.imagePicker.cameraDevice = .Front
        //
        //            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        //
        //        }))
        //
        //        actionsheet.addAction(UIAlertAction(title: "Gif Gallery", style: .Default, handler: { (action: UIAlertAction) -> Void in
        //
        //        }))
        //
        //        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
        //
        //        }))
        //
        //        self.presentViewController(actionsheet, animated: true, completion: nil)
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .Camera
        self.imagePicker.cameraDevice = .Front
        
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        self.imagePicker.dismissViewControllerAnimated(false) { () -> Void in
            
            self.presentViewController(SelectedMidia_ViewController(image: image,contact: self.contact), animated: true, completion: { () -> Void in
                
            })
            
        }
    }
    
    
    func sendImage(image: UIImage, lifetime: Int)
    {
        let message = DAOMessages.sharedInstance.sendMessage(self.contact.username,image: image, lifeTime: lifetime)
        
        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        let index = self.messages.indexOf(message)
        
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Top)
        
        if(self.tableView.contentSize.height > self.tableView.frame.size.height)
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.tableView.contentOffset.y += screenWidth + 20
                
                }, completion: { (success: Bool) -> Void in
                    
            })
        }
        
    }
    
    
    func sendMessage()
    {
        if (self.messageText.text?.characters.count > 0 && self.messageText.text != "Message...")
        {
            let message = DAOMessages.sharedInstance.sendMessage(self.contact.username, text: self.messageText.text!)
            self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
            let index = self.messages.indexOf(message)
            
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Top)
            let h = self.heightForView(self.messageText.text!, font: textMessageFont!, width: cellTextWidth)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.tableView.contentOffset.y += (h + cellBackgroundHeigth + margemVertical*2)
                
                }, completion: { (success: Bool) -> Void in
            })
            
            self.messageText.text = ""
            self.backToOriginal()
        }
        else
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.tableView.contentOffset.y += (40)
                
                }, completion: { (success: Bool) -> Void in
                    
            })
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
    
    
    func playSound()
    {
        let path = NSBundle.mainBundle().pathForResource("messageNotification.mp3", ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            self.messageSound = sound
            sound.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    
    func changeBackground()
    {
        if(!isViewing)
        {
            if(self.fundosIndex == 4)
            {
                self.fundosIndex = 0
            }
            else
            {
                self.fundosIndex++
            }
            
            let imageName = "fundoTeste\(self.fundosIndex)"
            self.backgorundImage.image = UIImage(named: imageName)
        }
    }
    
    
}
