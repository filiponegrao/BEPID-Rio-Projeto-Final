//
//  FTNChatController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 05/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

@objc protocol FTNChatControllerDelegate
{
    func FTNChatSendMessageText(chat: FTNChatController, message: String)
    
    func FTNChatSendMessageImage(chat: FTNChatController, image: UIImage)
    
    func FTNChatSendMessageAudio(chat: FTNChatController, audio: NSData)
}

class FTNChatController : UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, FTNMessageBarDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var background : UIImageView!
    
    //Collection
    var collectionView : UICollectionView!
    
    //Messages
    var messages : [Message]!
    
    //Message Bar
    var messageBar : FTNMessageBar!
    
    //Essencials
    weak var controller : UIViewController!
    
    var imagePicker : UIImagePickerController!
    
    var delegate : FTNChatControllerDelegate?
    
    init(frame: CGRect, initialMessages: [Message]?, controller: UIViewController)
    {
        self.controller = controller
        
        if(initialMessages == nil) { self.messages = [Message]() }
        else
        {
            self.messages = initialMessages
        }
        super.init(frame: frame)
        
        self.background = UIImageView(frame: self.bounds)
        self.background.image = UIImage(named: "blueSky")
        self.background.alpha = 0.5
        self.addSubview(self.background)
        
        self.messageBar = FTNMessageBar(origin: CGPointMake(0, self.frame.size.height - 50), shareOptions: contentOptions, controller: self.controller)
        self.messageBar.delegate = self
        self.addSubview(self.messageBar)
        
        self.collectionView = FTNChatView.collectionChat(viewFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.messageBar.frame.size.height))
        self.collectionView.registerClass(FTNCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.keyboardDismissMode = .Interactive
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.collectionView)
        
        self.bringSubviewToFront(self.messageBar)
        
        
        self.registerChatNotificatons()
        
    }
    
    func registerChatNotificatons()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.messageBar.frame.origin.y = self.frame.height - keyboardSize.height - self.messageBar.frame.size.height
            self.collectionView.frame.size.height = self.frame.size.height - self.messageBar.frame.size.height - keyboardSize.height
            self.collectionView.contentOffset.y += keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.messageBar.frame.origin.y = self.frame.height - self.messageBar.frame.size.height
            self.collectionView.frame.size.height = self.frame.size.height - self.messageBar.frame.size.height
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** ################ COLECTION VIEW PROPERTIES ################# **/
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch self.messages[indexPath.item].type
        {
        case "Text":
            return CGSizeMake(screenWidth, FTNContentTypes.checkHeigthForView(self.messages[indexPath.item].text!, font: defaultFont, width: screenWidth))
            
        case "Image":
            return CGSizeMake(screenWidth, FTNContentTypes.checkHeightForImageView())
            
            case "Gif":
                return CGSizeMake(screenWidth, FTNContentTypes.checkHeightForImageView())
            
            case "Audio":
                return CGSizeMake(screenWidth, FTNContentTypes.checkHeightForAudioView())
            
        default:
            return CGSizeMake(screenWidth, 80)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.messages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let message = self.messages[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FTNCollectionViewCell
        cell.configCell(message)
        cell.backgroundColor = UIColor.clearColor()
        
        //Verifica um possivel reenvio de mensagem
        if(message.type == ContentType.Text.rawValue)
        {
            if(message.status == messageStatus.Ready.rawValue)
            {
                DAOPostgres.sharedInstance.sendTextMessage(message.id, username: message.target, lifeTime: Int(message.lifeTime), text: message.text!, sentDate: message.sentDate)
            }
        }
        else if(message.type == ContentType.Image.rawValue)
        {
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.messageBar.textView.endEditing(true)
        let message = self.messages[indexPath.item]
        
        if(message.type == ContentType.Text.rawValue)
        {
            if( DAOMessages.sharedInstance.checkMessageStatus(message.id) == messageStatus.ErrorSent.rawValue)
            {
                let alert = UIAlertController(title: "Erro no envio", message: nil, preferredStyle: .ActionSheet)
                alert.addAction(UIAlertAction(title: "Reenviar", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    
                    DAOPostgres.sharedInstance.sendTextMessage(message.id, username: message.target, lifeTime: Int(message.lifeTime), text: message.text!, sentDate: message.sentDate)
                }))
                
                alert.addAction(UIAlertAction(title: "Apagar", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    
                    DAOMessages.sharedInstance.deleteMessage(message.id)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
                    
                }))
                self.controller.presentViewController(alert, animated: true, completion: { () -> Void in
                    
                })
            }
        }
    }
    
    
    /** ################ SCROLL VIEW PROPERTIES ################# **/
    
    
    
    /** ################ MESSAGE BAR PROPERTIES ################# **/
    
    func messageBarSendButtonClicked(messageBar: FTNMessageBar, text: String?)
    {
        if(text != nil)
        {
            self.delegate?.FTNChatSendMessageText(self, message: text!)
        }
    }
    
    func messageBarShareButtonClicked(messageBar: FTNMessageBar, option: Int, optionTitle: String)
    {
        if(option == 0 || option == 1)
        {
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            
            if(option == 0)
            {
                self.imagePicker.sourceType = .Camera
                self.imagePicker.cameraDevice = .Front
                self.imagePicker.cameraCaptureMode = .Photo
            }
            else
            {
                self.imagePicker.sourceType = .PhotoLibrary
            }
            
            self.controller.presentViewController(self.imagePicker, animated: true, completion: { () -> Void in
                
            })
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        self.imagePicker.dismissViewControllerAnimated(true) { () -> Void in
            self.delegate?.FTNChatSendMessageImage(self, image: image)
        }
    }
    
    func messageBarGifButtonClicked(messageBar: FTNMessageBar)
    {
        
    }
    
    func messageBarEndRecording(messageBar: FTNMessageBar, audio: NSData)
    {
        
    }
    
    func messageBarStartRecording(messageBar: FTNMessageBar)
    {
        
    }
    
    
    /** ################ CHAT  BEHAVIORS ################# **/

    func newMessage(index: Int)
    {
        let path = NSIndexPath(forItem: index, inSection: 0)
        self.collectionView.insertItemsAtIndexPaths([path])
        self.scrollToBottom()
    }
    
    func messageErased(index: Int)
    {
        let path = NSIndexPath(forItem: index, inSection: 0)
        self.collectionView.deleteItemsAtIndexPaths([path])
        self.scrollToBottom()
    }
    
    func scrollToBottom()
    {
        if(self.messages.count != 0)
        {
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: self.messages.count-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
        }
    }

    
}

