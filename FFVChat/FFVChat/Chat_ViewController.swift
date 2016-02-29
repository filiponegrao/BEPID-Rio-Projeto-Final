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

class Chat_ViewController: UIViewController, AVAudioPlayerDelegate, FTNChatControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    var imageZoom : ImageZoom_View!
    
    var messages = [Message]()
    
    var contact : Contact!
    
    var navBar : NavigationChat_View!
    
    var backgroundPicker : UIImagePickerController!
    
    var redScreen : UIView!
    
    var messageSound: AVAudioPlayer!
    
    let fundos = UserLayoutSettings.sharedInstance.getBackgroundNames()
    
    var fundosIndex = 0
    
    var isViewing : Bool = false
    
    var gifButton : UIButton!
    
    var chatController : FTNChatController!
    
    weak var homeController : Home_ViewController!
    
    //Audio player and recordr
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    init(contact: Contact, homeController : Home_ViewController)
    {
        self.homeController = homeController
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
        self.view.clipsToBounds = true
        
        self.navBar = NavigationChat_View(requester: self)
        self.navBar.layer.zPosition = 5
        self.view.addSubview(self.navBar)
        
        self.redScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.redScreen.backgroundColor = badTrust
        self.redScreen.alpha = 0

        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        self.chatController = FTNChatController(frame: CGRectMake(0, 80, screenWidth, screenHeight - 80), initialMessages: self.messages, controller: self)
        self.chatController.delegate = self
        self.view.addSubview(self.chatController)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didTakeScreenShot", name: UIApplicationUserDidTakeScreenshotNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "printScreenReceived:", name: NotificationController.center.printScreenReceived.name, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openLink:", name: FTNChatNotifications.linkClicked(), object: nil)
  
    }
    
    //** FUNCOES DE APARICAO DA TELA E DESAPARECIMENTO DA MESMA **//
    
    override func viewWillAppear(animated: Bool)
    {
        DAOPostgres.sharedInstance.startRefreshing()

        self.navBar.contactImage.setImage(UIImage(data: self.contact.profileImage!), forState: UIControlState.Normal)
        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        
        self.chatController.messages = self.messages
        self.chatController.background.image = UserLayoutSettings.sharedInstance.getCurrentBackground()
        self.chatController.collectionView.reloadData()
//        self.chatController.scrollToBottom()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newMessage", name: FTNChatNotifications.newMessage(), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageErased:", name: FTNChatNotifications.messageErased(), object: nil)
        
        self.chatController.messageBar.textView.resignFirstResponder()

        
    }
    override func viewDidAppear(animated: Bool)
    {
        self.redAlertScreen()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        self.homeController.contactsController.checkUnreadMessages()
        self.homeController.favouritesController.checkUnreadMessages()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: FTNChatNotifications.newMessage(), object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: FTNChatNotifications.messageErased(), object: nil)
        
        self.chatController.endEditions()
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
    
    /**#################### CHAT BEHAVIORS ##################### */
    
    func messageErased(notification: NSNotification)
    {
        let info : [NSObject : AnyObject] = notification.userInfo!
        let index = info["index"] as! Int
        let contact = info["contact"] as! String
        
        if(contact == self.contact.username)
        {
            self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
            
            if(index > self.messages.count)
            {
                self.chatController.collectionView.reloadData()
                return
            }
            
            self.chatController.messages = self.messages
            self.chatController.messageErased(index)
            
            if( self.imageZoom != nil )
            {
                if( self.messages.indexOf(self.imageZoom!.message) == nil )
                {
                    self.imageZoom?.fadeOut()
                }
            }
        }
    }
    
    func newMessage()
    {
        if(DAOMessages.sharedInstance.lastMessage.sender == self.contact.username)
        {
            self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
            let mssg = DAOMessages.sharedInstance.lastMessage
            let index = self.messages.indexOf(mssg)!
            
            self.chatController.messages = self.messages
            self.chatController.newMessage(index)
        
            //Verifica se a mensagem é minha
            if(mssg.sender != DAOUser.sharedInstance.getUsername() && (mssg.type == ContentType.Text.rawValue || mssg.type == ContentType.Gif.rawValue))
            {
                if(mssg.type == ContentType.Gif.rawValue)
                {
                    let gif = DAOContents.sharedInstance.getGifWithName(mssg.contentKey!)
                    if(gif != nil)
                    {
                        DAOMessages.sharedInstance.deleteMessageAfterTime(mssg)
                    }
                }
                else
                {
                    DAOMessages.sharedInstance.deleteMessageAfterTime(mssg)
                }
            }
            
            self.playSound()
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    /**####################### SEND FUNCTIONS AND BEHAVIORS ################ */
    
    /** SEND IMAGE MESSAGE */
    func sendImage(image: UIImage, lifetime: Int, filter: ImageFilter)
    {
        let message = DAOMessages.sharedInstance.sendMessage(self.contact.username, image: image, lifeTime: lifetime, filter: filter)
        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        
        let index = self.messages.indexOf(message)
        
        self.chatController.messages = self.messages
        self.chatController.newMessage(index!)
    }
    
    /** SEND AUDIO MESSAGE*/
    func sendAudio(audio: NSData, lifetime: Int, filter: AudioFilter)
    {
        let message = DAOMessages.sharedInstance.sendMessage(self.contact.username, audio: audio, lifeTime: lifetime, filter: filter)
        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        
        let index = self.messages.indexOf(message)
        
        self.chatController.messages = self.messages
        self.chatController.newMessage(index!)
    }
    
    /** SEND GIF MESSAGE */
    func sendGif(gifName: String)
    {
        let message = DAOMessages.sharedInstance.sendMessage(self.contact.username, gifName: gifName)
        
        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        let index = self.messages.indexOf(message)
        print("index da mensagem nova: \(index)")
        self.chatController.messages = self.messages
        self.chatController.newMessage(index!)
    }
    
    /** SEND TEXT MESSAGE */
    func sendMessage(text: String)
    {
        print("enviando mensagem...")
        let message = DAOMessages.sharedInstance.sendMessage(self.contact.username, text: text)
        
        self.messages = DAOMessages.sharedInstance.conversationWithContact(self.contact.username)
        let index = self.messages.indexOf(message)
        
        self.chatController.messages = self.messages
        self.chatController.newMessage(index!)
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
                
                DAOMessages.sharedInstance.deleteMessage(self.imageZoom.message.id, atualizaNoBanco: true)
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
        //COMING SOON:
        
//        alert.addAction(UIAlertAction(title: "Choose style", style: .Default, handler: { (action: UIAlertAction) -> Void in
//            
//        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func printScreenReceived(notification: NSNotification)
    {
        let userinfo = notification.userInfo!
        let printscreen = userinfo["printScreen"] as! PrintscreenNotification
        
        let alert = SweetAlert().showAlert("PrintScreen!", subTitle: "\(printscreen.printer) took a screenshot of your screen. For more details go to notifications on the main menu!!", style: AlertStyle.Warning)
    }
    
    /** #################### CHAT DELEGATES ###################*/
    
    func FTNChatSendMessageImage(chat: FTNChatController, image: UIImage)
    {
        self.presentViewController(SelectedMidia_ViewController(image: image,contact: self.contact), animated: true, completion: { () -> Void in
        })
    }
    
    func FTNChatSendMessageAudio(chat: FTNChatController, audio: NSData)
    {
        self.sendAudio(audio, lifetime: UserLayoutSettings.sharedInstance.getCurrentSecondsTextLifespan(), filter: .None)
    }
    
    func FTNChatSendMessageText(chat: FTNChatController, message: String)
    {
        self.sendMessage(message)
    }
    
    func FTNChatMessageClicked(chat: FTNChatController, message: Message, indexPath: NSIndexPath)
    {
        let image = DAOContents.sharedInstance.getImageInfoFromKey(message.contentKey!)
        if(image != nil)
        {
            let attributes : UICollectionViewLayoutAttributes = self.chatController.collectionView.layoutAttributesForItemAtIndexPath(indexPath)!
            let frame = attributes.frame
            
            let origin = self.chatController.collectionView.convertRect(frame, toView: self.chatController.collectionView.superview)
            DAOMessages.sharedInstance.deleteMessageAfterTime(message)
            
            self.imageZoom = ImageZoom_View(image: image!, message: message, origin: origin, controller: self)
            self.view.addSubview(self.imageZoom)
            self.imageZoom.fadeIn()
        }
    }
    
    func FTNChatSendGifName(chat: FTNChatController, gifName: String)
    {
        self.sendGif(gifName)
    }
    
    func FTNChatMoreGifsRequeste(chat: FTNChatController) {
        
        let gallery = GifGallery_UIViewController(controller: self)
        self.presentViewController(gallery, animated: true) { () -> Void in
            
        }
    }
    
    
    func openLink(notification: NSNotification)
    {
        let info : [NSObject : AnyObject] = notification.userInfo!
        let url = info["url"] as! NSURL
        
        let web = Web_ViewController(url: url)
        
        self.navigationController?.pushViewController(web, animated: true)
        
    }

}
