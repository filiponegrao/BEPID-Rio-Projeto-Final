//
//  FTNCollectionViewCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 05/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit
import Foundation

class FTNCollectionViewCell: UICollectionViewCell
{
    var labelDate : UILabel!
    
    var labelStatus : UILabel!
    
    var labelErrorSent : UIImageView!
    
    weak var message : Message!
    
    var chattextview : ChatTextView?
    
    var chatimageview : ChatImageView?
    
    var chatgifview : ChatGifView?
    
    var chataudioview : ChatAudioView?
    
    var notificationObserver : NSNotification?

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        print("alocando cell")
        
        self.labelDate = UILabel(frame: CGRectMake(frame.size.width - 35 - margemCellLateral, margemCellView+(self.frame.size.height-margemCellView*2)-20, 30, 15))
        self.labelDate.text = "00:00"
        self.labelDate.font = UIFont(name: "Gill Sans", size: 11)
        self.labelDate.alpha = 0.8
        self.labelDate.adjustsFontSizeToFitWidth = true
        self.labelDate.minimumScaleFactor = 0.1
        self.labelDate.textColor = UIColor.whiteColor()
        self.labelDate.textAlignment = .Right
//        self.labelDate.layer.borderWidth = 1
        self.addSubview(self.labelDate)
        
        self.labelStatus = UILabel(frame: CGRectMake(margemCellLateral, self.frame.size.height - 10, self.frame.size
            .width/2, 10))
        self.labelStatus.text = "🕒 Enviando..."
        self.labelStatus.font = UIFont(name: "Gill Sans", size: 12)
        self.labelStatus.textColor = UIColor.whiteColor()
        self.labelStatus.alpha = 1
//        self.labelStatus.layer.borderWidth = 1
        self.addSubview(self.labelStatus)
    }

    deinit
    {
        self.chataudioview?.removeFromSuperview()
        self.chatimageview?.removeFromSuperview()
        self.chatgifview?.removeFromSuperview()
        self.chattextview?.removeFromSuperview()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
    /**
     * Inevitavelmente necessita de uma dependencia
     * de modelo previamente criado.
     */
    func configCell(message: Message)
    {
        self.labelStatus.textColor = UIColor.whiteColor()

        let status = DAOMessages.sharedInstance.checkMessageStatus(message.id)
        if(status != nil)
        {
            self.labelStatus.text = status!
            if(status == messageStatus.Sent.rawValue)
            {
                self.labelStatus.textColor = oficialGreen
            }
            else
            {
                self.labelStatus.textColor = UIColor.whiteColor()
            }
            
            if(status == messageStatus.Ready.rawValue)
            {
                self.labelStatus.text = "🕒 Enviando..."
                self.labelStatus.textColor = UIColor.whiteColor()
            }
        }
        
        self.labelDate.text = Optimization.getStringDateFromDate(message.sentDate)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setSent", name: FTNChatNotifications.messageSent(message.id), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setSeen", name: FTNChatNotifications.messageSeen(message.id), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageError", name: FTNChatNotifications.messageSendError(message.id), object: nil)
        
        self.chataudioview?.removeFromSuperview()
        self.chatimageview?.removeFromSuperview()
        self.chatgifview?.removeFromSuperview()
        self.chattextview?.removeFromSuperview()

        self.message = message
        
        var mine : Bool
        if(message.sender == DAOUser.sharedInstance.getUsername())
        {
            mine = true
        }
        else
        {
            mine = false
        }
        
        switch self.message.type
        {
            
        case "Text":
            
            self.chattextview = FTNContentTypes.createTextViewForMessageCell(message.text!, cellsize: self.frame.size, mine: mine)
            self.labelStatus.frame.origin.y = self.frame.size.height - 10
            self.labelDate.frame.origin.y = frame.size.height - 30
            self.addSubview(self.chattextview!)
            
        case "Image":
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageLoaded", name: FTNChatNotifications.imageLoaded(message.contentKey!), object: nil)
            
            let image = DAOContents.sharedInstance.getImageFromKey(message.contentKey!)
            self.chatimageview = FTNContentTypes.createImageViewForMessageCell(image, cellsize: self.frame.size, mine: mine)
            self.labelStatus.frame.origin.y = self.frame.size.height - 10
            self.labelDate.frame.origin.y = frame.size.height - 30
            self.addSubview(self.chatimageview!)
            
        case "Gif":
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "gifLoaded", name: FTNChatNotifications.gifLoaded(message.contentKey!), object: nil)

            self.chatgifview = FTNContentTypes.createGifViewForMessageCell(message.contentKey!, cellsize: self.frame.size, mine: mine)
            self.labelStatus.frame.origin.y = self.frame.size.height - 10
            self.labelDate.frame.origin.y = frame.size.height - 30
            self.addSubview(self.chatgifview!)
            
        case "Audio":
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "audioLoaded", name: FTNChatNotifications.audioLoaded(message.contentKey!), object: nil)
            self.chataudioview = FTNContentTypes.createAudioViewForMessageCell(message.contentKey!, cellsize: self.frame.size, mine: mine, cell: self)
            self.labelStatus.frame.origin.y = self.frame.size.height - 10
            self.labelDate.frame.origin.y = frame.size.height - 30
            self.addSubview(self.chataudioview!)
            
        default:
            print("erro ao tentar encontrar o tipo da mensagem")
            
        }
        
        self.bringSubviewToFront(self.labelDate)
    }
    
    func setSent()
    {
        self.labelStatus.text = messageStatus.Sent.rawValue
        self.labelStatus.textColor = oficialGreen
    }
    
    func setSeen()
    {
        self.labelStatus.text = messageStatus.Seen.rawValue
        self.labelStatus.textColor = UIColor.whiteColor()
    }
    
    func messageError()
    {
        self.labelStatus.text = "‼️" + messageStatus.ErrorSent.rawValue
        self.labelStatus.textColor = oficialRed
    }
    
    func imageLoaded()
    {
        self.chatimageview?.loading?.removeFromSuperview()
        let image = DAOContents.sharedInstance.getImageFromKey(self.message!.contentKey!)
        self.chatimageview?.imageView.image = image
        self.chatimageview?.imageView.addSubview(self.chatimageview!.blur)
        
    }
    
    func gifLoaded()
    {
        self.chatgifview?.loading?.removeFromSuperview()
        let gif = DAOContents.sharedInstance.getGifWithName(self.message!.contentKey!)
        self.chatgifview?.gifView.runGif(gif!.data)
        DAOMessages.sharedInstance.deleteMessageAfterTime(self.message)
    }
    
    func audioLoaded()
    {
        self.chataudioview?.loading?.removeFromSuperview()
        let audio = DAOContents.sharedInstance.getAudioFromKey(self.message!.contentKey!)
        self.chataudioview?.initPlayer(audio!)
        self.chataudioview?.addSubview(self.chataudioview!.playButton)
        self.chataudioview?.slider.enabled = true
    }
    
    func deleteMessage()
    {
        DAOMessages.sharedInstance.deleteMessageAfterTime(self.message)
    }
    
}
