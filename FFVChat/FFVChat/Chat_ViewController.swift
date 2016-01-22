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

let messageViewHeigth : CGFloat = 80

let tableViewHeigth : CGFloat = screenHeight - navigationBarHeigth - messageViewHeigth

class Chat_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MessageBarDelegate
{
    var messageBar: MessageBar!
    
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
    
    var backgroundPicker : UIImagePickerController!
    
    var redScreen : UIView!
    
    var messageSound: AVAudioPlayer!
    
    let fundos = ["fundoTeste0","fundoTeste1","fundoTeste2","fundoTeste3","fundoTeste4"]
    
    var fundosIndex = 0
    
    var isViewing : Bool = false
    
    var passwordView : UIView!
    
    var gifButton : UIButton!
    
    init(contact: Contact)
    {
        self.contact = contact
        super.init(nibName: "Chat_ViewController", bundle: nil)
        print("alocando chat...")
    }
    
    deinit{ print("Desalocando chat...") }
    
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
        
        self.backgorundImage = UIImageView(frame: CGRectMake(0, 0, screenWidth, tableViewHeigth))
        self.backgorundImage.image = UIImage(named: self.fundos[self.fundosIndex])
        self.backgorundImage.contentMode = .ScaleAspectFill
        self.backgorundImage.alpha = 0.4
        self.backgorundImage.clipsToBounds = true
        self.containerView.addSubview(self.backgorundImage)
        
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, tableViewHeigth))
        self.tableView.registerClass(CellChat_TableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(CellImage_TableViewCell.self, forCellReuseIdentifier: "ImageCell")
        self.tableView.registerClass(CellGif_TableViewCell.self, forCellReuseIdentifier: "CellGif")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.zPosition = 0
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.keyboardDismissMode = .Interactive
        
        let gesture = UISwipeGestureRecognizer(target: self, action: "changeToNextBackground")
        gesture.direction = .Right
        self.view.addGestureRecognizer(gesture)
        
        self.redScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.redScreen.backgroundColor = badTrust
        self.redScreen.alpha = 0
        self.containerView.addSubview(self.redScreen)
        self.containerView.addSubview(tableView)
        
        
        self.messageBar = MessageBar(position: CGPointMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height), controller: self)
        self.messageBar.addActionForSenderButton(self, action: "sendMessage", forControlEvents: .TouchUpInside)
        self.messageBar.addActionForCameraButton(self, action: "takePhoto", forControlEvents: .TouchUpInside)
        self.messageBar.addActionForConfigButton(self, action: "layoutOptions", forControlEvents: .TouchUpInside)
        self.messageBar.delegate = self
        self.containerView.addSubview(messageBar)
//        self.messageBar.frame.origin.y = self.tableView.frame.origin.y + self.tableView.frame.size.height
        
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "printScreenReceived", name: NotificationController.center.printScreenReceived.name, object: nil)
        
        self.navBar.contactImage.setImage(UIImage(data: self.contact.profileImage!), forState: UIControlState.Normal)
        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        self.tableView.reloadData()
                
    }
    
    override func viewDidAppear(animated: Bool)
    {
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
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationController.center.printScreenReceived.name, object: nil)
        
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
        let contact = info["contact"] as! String
        
        if(contact == self.contact.username)
        {
            print("Meu indicie é \(index) e minha abela tem \(self.messages.count)")
            
            self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
            
            print("agora minha tabela tem \(self.messages.count) linhas e eu vou apagar a linha \(index)")
            
            if(index > self.messages.count)
            {
                self.tableView.reloadData()
                return
            }
            
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Top)
            
            if( self.imageZoom != nil )
            {
                if( self.messages.indexOf(self.imageZoom!.message) == nil )
                {
                    self.imageZoom?.fadeOut()
                }
            }
        }
    }
    
    func reloadImageCell(notification: NSNotification)
    {
        print("loading image")
        let info : [NSObject : AnyObject] = notification.userInfo!
        let key = info["imageKey"] as! String
        
        for mssg in self.messages
        {
            if(mssg.contentKey == key)
            {
                let index = self.messages.indexOf(mssg)!
                print("Atualizando")
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? CellImage_TableViewCell
                let img = DAOContents.sharedInstance.getImageFromKey(key)
                if(img != nil)
                {
                    cell?.imageCell.image = img
                    cell?.setLoadingOff()
                }
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
            
            //Verifica se a mensagem é minha
            if(mssg.sender != DAOUser.sharedInstance.getUsername() && mssg.type != ContentType.Image.rawValue)
            {
                DAOMessages.sharedInstance.deleteMessageAfterTime(mssg)
            }
            
            //Texto
            if(mssg.type == ContentType.Text.rawValue)
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
            //Imagem
            else if(mssg.type == ContentType.Image.rawValue || mssg.type == ContentType.Gif.rawValue)
            {
                if((self.tableView.contentSize.height + screenWidth) > self.tableView.frame.size.height)
                {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        self.tableView.contentOffset.y += screenWidth + 20 //+20 de margem
                        
                        }, completion: { (success: Bool) -> Void in
                            
                    })
                }
            }
            self.playSound()
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
                self.messageBar.frame.origin.y =  screenHeight - self.messageBar.frame.size.height - navigationBarHeigth - (keyboardSize.height)
                self.backgorundImage.frame.size.height = tableViewHeigth - (keyboardSize.height)
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
        self.messageBar.frame.origin.y = self.containerView.frame.size.height - self.messageBar.frame.size.height
        self.tableView.frame.size.height = tableViewHeigth
        self.backgorundImage.frame.size.height = tableViewHeigth
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.messageBar.endEditing(true)
        self.messageBar.closeAudioRecorder()
        self.messageBar.closeGifGallery()
    }
    
    
    //*** Message Bar properties ***/
    func messageBarExpanded(height: CGFloat)
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
//            self.containerView.frame.size.height = screenHeight - navigationBarHeigth - height
//            self.messageBar.frame.origin.y =  screenHeight - self.messageBar.frame.size.height - navigationBarHeigth - (height)
            self.backgorundImage.frame.size.height = self.backgorundImage.frame.size.height - (height)
            self.tableView.frame.size.height = self.tableView.frame.size.height - height
            
            if(self.tableView.contentSize.height > self.tableView.frame.size.height)
            {
                self.tableView.contentOffset.y += height
            }
            
            }) { (success: Bool) -> Void in
                
        }
    }
    
    func messageBarReturnedToOriginal(excededHeight: CGFloat)
    {
        if(self.tableView.frame.size.height < tableViewHeigth && self.backgorundImage.frame.size.height < tableViewHeigth)
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                //            self.containerView.frame.origin.y = navigationBarHeigth
                //            self.containerView.frame.size.height = screenHeight - navigationBarHeigth
                //            self.messageBar.frame.origin.y = self.containerView.frame.size.height - self.messageBar.frame.size.height
                self.tableView.frame.size.height += excededHeight
                self.backgorundImage.frame.size.height += excededHeight
                
                }) { (success: Bool) -> Void in
                    
            }
        }
    }
    
    //*** End Message Bar properties ***/

    
    
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
        if(self.messages[indexPath.row].text == nil && self.messages[indexPath.row].contentKey != nil)
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
        let mssg = self.messages[indexPath.row]
        let type = ContentType(rawValue: mssg.type)!
        
        switch type
        {
            
        case .Text:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellChat_TableViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            //adiciona mensagens do array
            
            cell.textMessage.text = self.messages[indexPath.row].text
            cell.sentDate.text = Optimization.getStringDateFromDate(self.messages[indexPath.row].sentDate)
            
            //Verificando o tamanho
            let necessaryHeigth = self.heightForView(self.messages[indexPath.row].text!, font: textMessageFont!, width: cellTextWidth)
            if(necessaryHeigth > cellTextHeigth)
            {
                let increase = necessaryHeigth - cellTextHeigth
                cell.backgroundLabel.frame.size.height = cellBackgroundHeigth + increase
                cell.textMessage.frame.size.height = cellTextHeigth + increase
                cell.sentDate.frame.origin.y = cell.textMessage.frame.origin.y + cell.textMessage.frame.size.height
            }
            
            
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
            
            cell.backgroundLabel.layer.shadowColor = UIColor.blackColor().CGColor
            cell.backgroundLabel.layer.shadowOffset = CGSizeMake(5, 5)
            cell.backgroundLabel.layer.shadowRadius = 3
            cell.backgroundLabel.layer.shadowOpacity = 1
            cell.backgroundLabel.layer.masksToBounds = false
            cell.backgroundLabel.layer.shadowPath = UIBezierPath(roundedRect: cell.backgroundLabel.bounds, cornerRadius: cell.backgroundLabel.layer.cornerRadius).CGPath
            
            if(mssg.sender != DAOUser.sharedInstance.getUsername())
            {
                DAOMessages.sharedInstance.deleteMessageAfterTime(mssg)
            }
            
            return cell
            
            
        case .Image:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! CellImage_TableViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.sentDate.text = Optimization.getStringDateFromDate(self.messages[indexPath.row].sentDate)
            //blur
            cell.blur?.removeFromSuperview()
            cell.blur = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
            cell.blur.frame = cell.imageCell.bounds
            cell.imageCell.addSubview(cell.blur)
            cell.bringSubviewToFront(cell.indicator)
            
            let key = mssg.contentKey!
            
            let img = DAOContents.sharedInstance.getImageFromKey(key)
            if(img != nil)
            {
                let img = DAOContents.sharedInstance.getImageFromKey(self.messages[indexPath.row].contentKey!)
                cell.imageCell.image = img
                cell.setLoadingOff()
            }
            else
            {
                cell.imageCell.image = UIImage()
                cell.setLoading()
                DAOParse.sharedInstance.downloadImageForMessage(mssg.contentKey!, id: mssg.id)
            }
            

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
            
            cell.backgroundLabel.layer.shadowColor = UIColor.blackColor().CGColor
            cell.backgroundLabel.layer.shadowOffset = CGSizeMake(5, 5)
            cell.backgroundLabel.layer.shadowRadius = 3
            cell.backgroundLabel.layer.shadowOpacity = 1
            cell.backgroundLabel.layer.masksToBounds = false
            cell.backgroundLabel.layer.shadowPath = UIBezierPath(roundedRect: cell.backgroundLabel.bounds, cornerRadius: cell.backgroundLabel.layer.cornerRadius).CGPath

            return cell
            
        case .Gif:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("CellGif", forIndexPath: indexPath) as! CellGif_TableViewCell
            cell.selectionStyle = .None
            
            cell.sentDate.text = Optimization.getStringDateFromDate(self.messages[indexPath.row].sentDate)
            cell.backgroundColor = UIColor.clearColor()
            
            let gifname = mssg.contentKey!
            let url = DAOContents.sharedInstance.urlFromGifName(gifname)
            let request = NSURLRequest(URL: NSURL(string: url!)!)
            cell.webView.loadRequest(request)
            
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
            
            cell.backgroundLabel.layer.shadowColor = UIColor.blackColor().CGColor
            cell.backgroundLabel.layer.shadowOffset = CGSizeMake(5, 5)
            cell.backgroundLabel.layer.shadowRadius = 3
            cell.backgroundLabel.layer.shadowOpacity = 1
            cell.backgroundLabel.layer.masksToBounds = false
            cell.backgroundLabel.layer.shadowPath = UIBezierPath(roundedRect: cell.backgroundLabel.bounds, cornerRadius: cell.backgroundLabel.layer.cornerRadius).CGPath
            
            let mssg = self.messages[indexPath.item]
            if(mssg.sender != DAOUser.sharedInstance.getUsername())
            {
                DAOMessages.sharedInstance.deleteMessageAfterTime(mssg)
            }
            
            return cell
            
        default:
            
            print("modo ainda nao suportado")
            
            let cell = tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let message = self.messages[indexPath.row]
        
        //Imagem
        let type = ContentType(rawValue: message.type)!

        switch type
        {
        case .Image:
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! CellImage_TableViewCell
            let frameOnTable = cell.imageCell.frame
            
            let frame = self.tableView.convertRect(frameOnTable, toView: self.tableView.superview)
            
            let img = DAOContents.sharedInstance.getImageInfoFromKey(message.contentKey!)
            if(img != nil && !self.messageBar.isEditing())
            {
                self.imageZoom = ImageZoom_View(image: img!, message: message, origin: frame)
                self.imageZoom.chatController = self
                self.imageZoom.message = self.messages[indexPath.row]
                self.isViewing = true
                self.view.addSubview(self.imageZoom)
                self.imageZoom.fadeIn()
                
                if(message.sender != DAOUser.sharedInstance.getUsername())
                {
                    DAOMessages.sharedInstance.deleteMessageAfterTime(message)
                }
            }
            self.messageBar.endEditing(true)
            
        case .Text:
            
            if(message.text?.lowercaseString.rangeOfString("http://") != nil)
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
            
        case .Gif:
            print("gif")
            
        default:
            
            print("nothing")
        }

        self.messageBar.endEditing(true)
        
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
        
        let actionsheet = UIAlertController(title: "Choose media", message: nil, preferredStyle: .ActionSheet)
        actionsheet.addAction(UIAlertAction(title: "From Camera", style: .Default, handler: { (action: UIAlertAction) -> Void in

            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .Camera
            self.imagePicker.cameraDevice = .Front

            self.presentViewController(self.imagePicker, animated: true, completion: nil)

        }))

        actionsheet.addAction(UIAlertAction(title: "Gif Gallery", style: .Default, handler: { (action: UIAlertAction) -> Void in
            
            let gifGallery = GifGallery_UIViewController(chatViewController: self)
            self.presentViewController(gifGallery, animated: true, completion: nil)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "From Photo Album", style: .Default, handler: { (action: UIAlertAction) -> Void in
            
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        }))

        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in

        }))

        self.messageBar.closeGifGallery()
        self.messageBar.closeAudioRecorder()
        self.presentViewController(actionsheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        if(self.imagePicker != nil)
        {
            if(picker == self.imagePicker)
            {
                self.imagePicker.dismissViewControllerAnimated(false) { () -> Void in
                    
                    self.presentViewController(SelectedMidia_ViewController(image: image,contact: self.contact), animated: true, completion: { () -> Void in
                        
                    })
                }
            }
        }
        if(self.backgroundPicker != nil)
        {
            if (picker == self.backgroundPicker)
            {
                self.backgroundPicker.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    self.backgorundImage.image = image
                    
                })
            }
        }
    }
    
    
    func sendImage(image: UIImage, lifetime: Int, filter: ImageFilter)
    {
        let message = DAOMessages.sharedInstance.sendMessage(self.contact.username, image: image, lifeTime: lifetime, filter: filter)
        
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
    
    
    func sendGif(gifName: String)
    {
        
        let message = DAOMessages.sharedInstance.sendMessage(self.contact.username, gifName: gifName)
        
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
        if (self.messageBar.textView.text?.characters.count > 0 && self.messageBar.textView.text != "Message...")
        {
            let message = DAOMessages.sharedInstance.sendMessage(self.contact.username, text: self.messageBar.textView.text!)
            self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
            if(self.messageBar.textView.isFirstResponder())
            {
                self.messageBar.textView.text = ""
            }
            else
            {
                self.messageBar.textView.text = "Message..."
            }
            self.messageBar.returnMessageBarToOriginalSize()
            self.playSound()

            let index = self.messages.indexOf(message)
            
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Top)
            let h = self.heightForView(self.messageBar.textView.text!, font: textMessageFont!, width: cellTextWidth)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.tableView.contentOffset.y += (h + cellBackgroundHeigth + margemVertical*2)
                
                }, completion: { (success: Bool) -> Void in
                    
            })
        }
        else
        {
//            UIView.animateWithDuration(0.3, animations: { () -> Void in
//                
//                self.tableView.contentOffset.y += (40)
//                
//                }, completion: { (success: Bool) -> Void in
//                    
//            })
        }
    }
    
    
    //****************************************************//
    //******* END MESSAGE FUNCTIONS AND HANDLES  *********//
    //****************************************************//
    
    func didTakeScreenShot()
    {
        if(self.imageZoom != nil)
        {
            if(self.imageZoom.message.sender != DAOUser.sharedInstance.getUsername())
            {
                DAOPrints.sharedInstance.sendPrintscreenNotification(self.imageZoom.message.contentKey!, sender: self.contact.username)
                self.imageZoom?.removeFromSuperview()
                self.imageZoom = nil
            }
        }
        
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
    
    
    func layoutOptions()
    {
        let alert = UIAlertController(title: "Layout Options", message: nil, preferredStyle: .ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Choose background image", style: .Default, handler: { (action: UIAlertAction) -> Void in
            
            self.backgroundPicker = UIImagePickerController()
            self.backgroundPicker.sourceType = .PhotoLibrary
            self.backgroundPicker.delegate = self
            
            self.presentViewController(self.backgroundPicker, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Choose style", style: .Default, handler: { (action: UIAlertAction) -> Void in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
            
            
        }))
        
        self.messageBar.closeGifGallery()
        self.messageBar.closeAudioRecorder()
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func changeToNextBackground()
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
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.backgorundImage.alpha = 0
                
                }, completion: { (success: Bool) -> Void in
                    
                    self.backgorundImage.image = UIImage(named: imageName)
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        self.backgorundImage.alpha = 0.4
                        
                        }, completion: { (success: Bool) -> Void in
                            
                    })
            })
        }
    }
    
    
    func printScreenReceived()
    {
        let alert = SweetAlert().showAlert("PrintScreen!", subTitle: "Someone took a screenshot of your screen", style: AlertStyle.Warning)
        
    }
    
    
}
