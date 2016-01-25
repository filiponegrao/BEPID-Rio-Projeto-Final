//
//  MessageBar.swift
//  FFVChat
//
//  Created by Filipo Negrao on 03/01/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

@objc public protocol MessageBarDelegate
{
    // MARK: - Delegate functions
    
    func messageBarExpanded(height: CGFloat)
    
    func messageBarReturnedToOriginal(excededHeight: CGFloat)
}

public class MessageBar : UIView, UITextViewDelegate
{
    weak var controller : Chat_ViewController!
    
    let textViewHeigth : CGFloat = 40
    
    var originalPosition : CGPoint!
    
    let originalHeigth : CGFloat = 80
    
    var textView : UITextView!
    
    var sendButton : UIButton!
    
    var cameraButton : UIButton!
    
    var gifButton: UIButton!
    
    var audioButton : UIButton!
    
    var videoButton: UIButton!
    
    var configButton : UIButton!
    
    public weak var delegate : MessageBarDelegate?
    
    var barExpandedGif : Bool = false
    
    var barExpandedAudio : Bool = false
    
    //Keyboards
    
    var gifKeyboard : GifKeyboard!
    
    var audioKeyboard : AudioKeyboard!
    
    init(position: CGPoint, controller: Chat_ViewController)
    {
        self.controller = controller
        self.originalPosition = position
        super.init(frame: CGRectMake(0, self.originalPosition.y, screenWidth, self.originalHeigth))
        
        //Optional
//        self.layer.borderColor = oficialLightGray.CGColor
//        self.layer.borderWidth = 0.3
        
        self.backgroundColor = oficialDarkGray //UIColor.whiteColor()

        self.textView = UITextView(frame: CGRectMake(10, 5, screenWidth-20, self.textViewHeigth))
        self.textView.autocorrectionType = UITextAutocorrectionType.Yes
        self.textView.font = UIFont(name: "Helvetica", size: 16)
        self.textView.textContainer.lineFragmentPadding = 10;
        self.textView.text = "Message..."
        self.textView.textAlignment = .Left
        self.textView.textColor = oficialLightGray
        self.textView.tintColor = oficialGreen
        self.textView.backgroundColor = UIColor.clearColor()
        self.textView.keyboardAppearance = .Dark
        self.textView.keyboardDismissMode = .None
        self.textView.delegate = self
        self.addSubview(self.textView)
        
        
        self.sendButton = UIButton(frame: CGRectMake(screenWidth-80, 40, 70, 40))
        self.sendButton.setTitle("Send", forState: .Normal)
        self.sendButton.setTitleColor(oficialGreen, forState: .Normal)
        self.addSubview(self.sendButton)
        
        
        self.cameraButton = UIButton(frame: CGRectMake(5, self.textView.frame.origin.y + self.textView.frame.size.height, 35, 35))
        self.cameraButton.setImage(UIImage(named: "chatCameraButton"), forState: UIControlState.Normal)
        self.cameraButton.alpha = 0.7
        self.addSubview(cameraButton)

        self.gifButton = UIButton(frame: CGRectMake(self.cameraButton.frame.origin.x + self.cameraButton.frame.size.width + 20, self.cameraButton.frame.origin.y , 35, 35))
        self.gifButton.setImage(UIImage(named: "gifButton"), forState: UIControlState.Normal)
        self.gifButton.addTarget(self, action: "openGifGallery", forControlEvents: .TouchUpInside)
        self.gifButton.alpha = 0.7
        self.addSubview(gifButton)
        
        self.audioButton = UIButton(frame: CGRectMake(self.gifButton.frame.origin.x + self.gifButton.frame.size.width + 20, self.gifButton.frame.origin.y , 35, 35))
        self.audioButton.setImage(UIImage(named: "micButton"), forState: UIControlState.Normal)
        self.audioButton.addTarget(self, action: "openAudioRecorder", forControlEvents: .TouchUpInside)
        self.audioButton.alpha = 0.7
        self.addSubview(audioButton)
        
        self.configButton = UIButton(frame: CGRectMake(self.audioButton.frame.origin.x + self.audioButton.frame.size.width + 20, self.audioButton.frame.origin.y , 35, 35))
        self.configButton.setImage(UIImage(named: "paintButton"), forState: UIControlState.Normal)
        self.configButton.alpha = 0.7
        self.addSubview(configButton)
        
//        self.configButton = UIButton(frame: CGRectMake(self.videoButton.frame.origin.x + self.videoButton.frame.size.width + 20, self.videoButton.frame.origin.y , 35, 35))
//        self.configButton.setImage(UIImage(named: "gifButton"), forState: UIControlState.Normal)
//        self.configButton.addTarget(self, action: "openGifGallery", forControlEvents: .TouchUpInside)
//        self.configButton.alpha = 0.7
//        self.addSubview(configButton)
        
    }
    
    
    //Functions
    func openGifGallery()
    {
        if(!self.barExpandedGif)
        {
            if(self.barExpandedAudio) { self.closeAudioRecorder() }
            self.barExpandedGif = true
            self.textView.endEditing(true)
            self.delegate?.messageBarExpanded(140)
            
            self.gifKeyboard = GifKeyboard(controller: self.controller)
            self.gifKeyboard.frame.origin.y = screenHeight
            self.gifKeyboard.closeButton.addTarget(self, action: "closeGifGallery", forControlEvents: .TouchUpInside)
            self.controller.view.addSubview(self.gifKeyboard)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.gifKeyboard.frame.origin.y = screenHeight - 220
                
                }, completion: { (success: Bool) -> Void in
                    
            })
            
        }
        else
        {
            self.closeGifGallery()
        }
    }
    
    func closeGifGallery()
    {
        self.barExpandedGif = false
        self.textView.endEditing(true)
        self.delegate?.messageBarReturnedToOriginal(140)
        if(self.gifKeyboard != nil)
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.gifKeyboard.frame.origin.y = screenHeight
                
                }) { (success: Bool) -> Void in
                    
                    self.gifKeyboard.collectionView.delegate = nil
                    self.gifKeyboard.collectionView.dataSource = nil
                    self.gifKeyboard.removeFromSuperview()
                    self.gifKeyboard = nil
            }
        }
    }
    
    
    func openAudioRecorder()
    {
        if(!self.barExpandedAudio)
        {
            if(self.barExpandedGif) { self.closeGifGallery() }
            self.barExpandedAudio = true
            self.textView.endEditing(true)
            self.delegate?.messageBarExpanded(140)
            
            self.audioKeyboard = AudioKeyboard(controller: self.controller)
            self.audioKeyboard.frame.origin.y = screenHeight - 40
            self.audioKeyboard.frame.size.height = 1
            self.audioKeyboard.closeButton.addTarget(self, action: "closeAudioRecorder", forControlEvents: .TouchUpInside)
            self.controller.view.addSubview(self.audioKeyboard)
            
            
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                self.audioKeyboard.frame.size.height = 180
                self.audioKeyboard.frame.origin.y = screenHeight - 220
                
                }, completion: { (success: Bool) -> Void in
                    
            })
        }
        else
        {
            self.closeAudioRecorder()
        }
    }
    
    func closeAudioRecorder()
    {
        self.barExpandedAudio = false
        self.textView.endEditing(true)
        self.delegate?.messageBarReturnedToOriginal(140)
        
        if(self.audioKeyboard != nil)
        {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                
                self.audioKeyboard.frame.size.height = 0
                self.audioKeyboard.frame.origin.y = screenHeight - 40
                
                }) { (success: Bool) -> Void in
                    
                    self.audioKeyboard.removeFromSuperview()
                    self.audioKeyboard = nil
            }
        }
    }
    
    //Definicoes visuais
    func changeBackgroundColor(color: UIColor)
    {
        self.backgroundColor = color
    }
    
    
    //Funcoes de acesso e checagem
    override public func endEditing(force: Bool) -> Bool
    {
        return self.textView.endEditing(force)
    }
    
    func isEditing() -> Bool
    {
        return self.textView.isFirstResponder()
    }
    
    func addActionForSenderButton(target: AnyObject?, action: Selector, forControlEvents: UIControlEvents)
    {
        self.sendButton.addTarget(target, action: action, forControlEvents: forControlEvents)
    }
    
    func addActionForCameraButton(target: AnyObject?, action: Selector, forControlEvents: UIControlEvents)
    {
        self.cameraButton.addTarget(target, action: action, forControlEvents: forControlEvents)
    }
    
    func addActionForConfigButton(target: AnyObject?, action: Selector, forControlEvents: UIControlEvents)
    {
        self.configButton.addTarget(target, action: action, forControlEvents: forControlEvents)
    }
    
//    func addActionForAudioButton(target: AnyObject?, action: Selector, forControlEvents: UIControlEvents)
//    {
//        self.audioButton.addTarget(target, action: action, forControlEvents: forControlEvents)
//    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Text View delegates
    public func textViewDidBeginEditing(textView: UITextView) {
        if(textView.text == "Message...")
        {
            textView.text = ""
        }
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        if(textView.text == "")
        {
            textView.text = "Message..."
        }
    }
    
    public func textViewDidChange(textView: UITextView)
    {
        //Vamos estar falando sempre de altura
        
        let frame = self.textView.frame.height

        let content = self.textView.contentSize.height

        if(content > frame && frame < 100 /* Um limite que eu escolhi */)
        {
            self.expandTextField()
        }
        else if(content < frame && frame > self.textViewHeigth)
        {
            self.reduceTextField()
        }
    }
    
    
    func expandTextField()
    {
        //Estamos falando sempre de altura
        
        let frame = self.textView.frame.height

        let content = self.textView.contentSize.height

        let plus = content - frame

        if(self.textView.frame.size.height < 100)
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in

                self.frame.origin.y -= plus
                self.frame.size.height += plus
                self.textView.frame.size.height += plus
                self.cameraButton.frame.origin.y += plus
                self.gifButton.frame.origin.y += plus
                self.audioButton.frame.origin.y += plus
//                self.videoButton.frame.origin.y += plus
                self.configButton.frame.origin.y += plus
                self.sendButton.frame.origin.y += plus
                
                self.delegate?.messageBarExpanded(plus)


                }) { (success: Bool) -> Void in

            }
        }
    }

    func reduceTextField()
    {
        //Estamos falando sempre de altura

        let frame = self.textView.frame.size.height

        let content = self.textView.contentSize.height
        
        var diference : CGFloat!
        
        if(content < 40)
        {
            diference = frame - 40
        }
        else
        {
            diference = frame - content
        }
            
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.frame.origin.y += diference
            self.frame.size.height -= diference
            self.textView.frame.size.height -= diference
            
            self.cameraButton.frame.origin.y -= diference
            self.gifButton.frame.origin.y -= diference
            self.audioButton.frame.origin.y -= diference
//            self.videoButton.frame.origin.y -= diference
            self.configButton.frame.origin.y -= diference
            self.sendButton.frame.origin.y -= diference
            
            self.delegate?.messageBarReturnedToOriginal(diference)
            
            }) { (success: Bool) -> Void in
                
                
            }
        }
    
    
    func returnMessageBarToOriginalSize()
    {
        self.textView.text = ""
        self.reduceTextField()
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
    
}