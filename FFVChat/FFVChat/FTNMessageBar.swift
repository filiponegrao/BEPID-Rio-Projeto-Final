//
//  FTNMessageBar.swift
//  FFVChat
//
//  Created by Filipo Negrao on 05/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import AudioToolbox


@objc protocol FTNMessageBarDelegate
{
    func messageBarShareButtonClicked(messageBar: FTNMessageBar, option: Int, optionTitle: String)
    
    optional func messageBarGifButtonClicked(messageBar: FTNMessageBar)
    
    func messageBarSendButtonClicked(messageBar: FTNMessageBar, text: String?)
    
    func messageBarEndRecording(messageBar: FTNMessageBar, audio: NSData)
    
    optional func messageBarStartRecording(messageBar: FTNMessageBar)
    
}

class FTNMessageBar : UIView, UITextViewDelegate, AVAudioRecorderDelegate
{
    let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
    
    //Texto
    var textView : UITextView!
    
    var sendButton : UIButton!
    
    //Audio Section
    var audioButton : BubbleButton!
    
    var audioLabel : UILabel!
    
    var recorder : AVAudioRecorder!

    var recordTimer : NSTimer!
    
    var updateRecordTimer : NSTimer!
    
    var audioOk : Bool = false
    
    //Content Section
    var shareButton : UIButton!
    
    var shareOptions : [String]!
    
    //Gif Options
    var gifButton : UIButton!
    
    weak var delegate : FTNMessageBarDelegate?
    
    weak var controller : UIViewController!
    
    var audioDuration : Int!
    
    var cancel : Bool = false
    
    init(origin: CGPoint, shareOptions: [String], controller: UIViewController)
    {
        self.controller = controller
        self.shareOptions = shareOptions
        
        super.init(frame: CGRectMake(origin.x, origin.y, screenWidth, 50))
        self.backgroundColor = oficialDarkGray
        
        self.shareButton = UIButton(frame: CGRectMake(0,0,50,50))
        self.shareButton.setImage(UIImage(named: "contentButton"), forState: .Normal)
        self.shareButton.addTarget(self, action: "shareButtonClicked", forControlEvents: .TouchUpInside)
        self.addSubview(self.shareButton)
        
        self.audioLabel = UILabel(frame: CGRectMake(20, 0, self.frame.size.width - 100, self.frame.size.height))
        self.audioLabel.text = "0:00 << Cancele deslizando"
        self.audioLabel.textColor = oficialGreen
        self.audioLabel.alpha = 0
        self.audioLabel.hidden = true
        self.addSubview(self.audioLabel)
        
        self.textView = UITextView(frame: CGRectMake(self.shareButton.frame.origin.x + self.shareButton.frame.size.width, 10, screenWidth - 160, self.frame.size.height - 20))
        self.textView.text = "Message..."
        self.textView.backgroundColor = UIColor.clearColor()
        self.textView.tintColor = oficialGreen
        self.textView.textColor = oficialLightGray
//        self.textView.layer.borderWidth = 0.5
        self.textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.textView.layer.cornerRadius = 3
        self.textView.font = UIFont(name: "Helvetica", size: 16)
        self.textView.delegate = self
        self.textView.autocorrectionType = .Default
        self.textView.keyboardAppearance = .Dark
        self.textView.keyboardDismissMode = .Interactive
        self.textView.textAlignment = .Left
        self.textView.textContainer.lineFragmentPadding = 10;
        self.addSubview(self.textView)
        
        self.audioButton = BubbleButton(frame: CGRectMake(self.textView.frame.origin.x + self.textView.frame.size.width, 0, 50, 50))
        self.audioButton.setImage(UIImage(named: "micButton"), forState: .Normal)
        self.audioButton.addTargetOnStart("startRecord", target: self)
        self.audioButton.addTargetOnEnd("stopRecord", target: self)
        self.audioButton.addTargetForCancel("cancelRecord", target: self)
        self.audioButton.setLongPressUseModeOn()
        self.addSubview(self.audioButton)
        
        self.gifButton = UIButton(frame: CGRectMake(self.audioButton.frame.origin.x + self.audioButton.frame.size.width, 0, 50, 50))
        self.gifButton.setImage(UIImage(named: "gifButton"), forState: .Normal)
        self.gifButton.addTarget(self, action: "gifButtonClicked", forControlEvents: .TouchUpInside)
        self.addSubview(self.gifButton)
        
        self.sendButton = UIButton(frame: CGRectMake(screenWidth - 80, 0, 80, 50))
        self.sendButton.setTitle("Send", forState: .Normal)
        self.sendButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.sendButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.sendButton.titleLabel?.minimumScaleFactor = 0.1
        self.sendButton.hidden = true
        self.sendButton.setTitleColor(oficialGreen, forState: .Normal)
        self.sendButton.setTitleColor(oficialLightGray, forState: .Disabled)
        self.sendButton.addTarget(self, action: "sendButtonClicked", forControlEvents: .TouchUpInside)
        self.addSubview(self.sendButton)
        
    }

    deinit
    {
        self.textView.delegate = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shareButtonClicked()
    {
        let alert = UIAlertController(title: "Contents sharing", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        for option in self.shareOptions
        {
            alert.addAction(UIAlertAction(title: option, style: .Default, handler: { (action: UIAlertAction) -> Void in
                
                self.delegate?.messageBarShareButtonClicked(self, option: self.shareOptions.indexOf(option)!, optionTitle: option)
                
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
            
        }))
        
        self.controller.presentViewController(alert, animated: true) { () -> Void in
            
        }
        
    }
    
    func gifButtonClicked()
    {
        self.delegate?.messageBarGifButtonClicked!(self)
    }
    
    func startRecord()
    {
        if(self.recorder == nil) { self.initAudioRecorder() }

        if(!self.recorder.recording)
        {
            self.cancel = false
            
            self.audioDuration = 0
            self.audioLabel.text = "0:00 << Cancele deslizando"
            
            let audioSession = AVAudioSession.sharedInstance()
            
            do { try audioSession.setCategory(AVAudioSessionCategoryRecord) }
            catch { print("audioSession error)") }
            
            try! AVAudioSession.sharedInstance().setActive(true)
            
            self.recorder?.prepareToRecord()
            if self.recorder?.recording == false {
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.recorder?.record()
                self.recordingModeOn()
                self.recordTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "enableAudio", userInfo: nil, repeats: false)
                self.updateRecordTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "recordingUpdates", userInfo: nil, repeats: true)
            }
        }
    }
    
    func stopRecord()
    {
        self.updateRecordTimer?.invalidate()
        self.recorder?.stop()
        self.recordingModeOff()
        self.recordTimer?.invalidate()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do { try audioSession.setCategory(AVAudioSessionCategoryAmbient) }
        catch { print("audioSession error)") }
        try! AVAudioSession.sharedInstance().setActive(false)
    }
    
    func cancelRecord()
    {
        self.cancel = true
        self.stopRecord()
    }

    
    func sendButtonClicked()
    {
        if(self.textView.text != "Message..." && self.textView.text != "")
        {
            self.delegate?.messageBarSendButtonClicked(self, text: self.textView.text)
            self.textView.text = ""
            self.textModeOff()
            self.reduceBar()
        }
    }
    
    func textModeOn()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.gifButton.alpha = 0
            self.audioButton.alpha = 0
            self.gifButton.frame.origin.x = self.screenWidth
            self.audioButton.frame.origin.x = self.screenWidth
            
            
            self.sendButton.alpha = 1
            self.textView.frame.size.width = self.screenWidth - 80 - 50
            
            }) { (success: Bool) -> Void in
                
                self.gifButton.hidden = true
                self.audioButton.hidden = true
                self.sendButton.hidden = false
        }
    }
    
    func textModeOff()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.textView.frame.size.width = self.screenWidth - 150
            
            self.gifButton.alpha = 1
            self.audioButton.alpha = 1
            self.audioButton.frame.origin.x = self.textView.frame.origin.x + self.textView.frame.size.width
            self.gifButton.frame.origin.x = self.audioButton.frame.origin.x + self.audioButton.frame.size.width
            
            self.sendButton.alpha = 0
            
            }) { (success: Bool) -> Void in
                
                self.gifButton.hidden = false
                self.audioButton.hidden = false
                self.sendButton.hidden = true
        }

    }
    
    func recordingModeOn()
    {
        self.audioLabel.hidden = false
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.audioLabel.alpha = 1
            self.shareButton.alpha = 0
            self.textView.alpha = 0
            self.gifButton.alpha = 0
            
            
            }) { (success: Bool) -> Void in
                
                self.shareButton.hidden = true
                self.gifButton.hidden = true
                self.textView.hidden = true
        }
    }
    
    func recordingUpdates()
    {
        self.audioDuration = self.audioDuration + 1
        if(self.audioDuration < 60)
        {
            if(self.audioDuration < 10)
            {
                self.audioLabel.text = "0:0\(self.audioDuration) << Cancele deslizando"
            }
            else
            {
                self.audioLabel.text = "0:\(self.audioDuration) << Cancele deslizando"
            }
        }
        else
        {
            self.stopRecord()
        }
    }
    
    func recordingModeOff()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.audioLabel.alpha = 0
            self.shareButton.alpha = 1
            self.textView.alpha = 1
            self.gifButton.alpha = 1
            
            
            }) { (success: Bool) -> Void in
                
                self.shareButton.hidden = false
                self.gifButton.hidden = false
                self.textView.hidden = false
                self.audioLabel.hidden = true
        }

    }
    
    /** ################ TEXT VIEW PROPERTIES ################# **/
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if(textView.text == "Message...")
        {
            textView.text = ""
            self.textModeOn()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        if(textView.text == "" || textView.text == nil)
        {
            textView.text = "Message..."
            self.textModeOff()
            self.reduceBar()
        }
    }
    
    func textViewDidChange(textView: UITextView)
    {
        //Verifica tamanho
        if((textView.contentSize.height > textView.frame.size.height) && (textView.frame.size.height < 90))
        {
            self.expandBar()
        }
        else if((textView.contentSize.height < textView.frame.size.height) && (textView.frame.size.height > 30))
        {
            self.reduceBar()
        }
        
        //Verifica tipo
        if(textView.text == "")
        {
            self.textModeOff()
        }
        else
        {
            self.textModeOn()
        }
    }
    
    func expandBar()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            let plus = self.textView.contentSize.height - self.textView.frame.size.height
            
            self.textView.frame.size.height += plus
            
            self.frame.size.height += plus
            
            self.frame.origin.y -= plus
            
            }) { (success: Bool) -> Void in
        }
    }
    
    func reduceBar()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            let plus = self.textView.frame.size.height - self.textView.contentSize.height
            
            self.textView.frame.size.height -= plus
            
            self.frame.size.height -= plus
            
            self.frame.origin.y += plus
            
            }) { (success: Bool) -> Void in
        }
    }
    
    /** ################ AUDIO RECORDER PROPERTIES ################# **/
    func initAudioRecorder()
    {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0]
        let soundFilePath = docsDir.stringByAppendingPathComponent("sound.caf")
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey: 20000.0]
        
        let audioSession = AVAudioSession.sharedInstance()
        
//        do { try audioSession.setCategory(AVAudioSessionCategoryRecord) }
//        catch { print("audioSession error)") }
        
        do { self.recorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings as! [String : AnyObject])
            
            self.recorder?.delegate = self
        }
        catch
        {
            print("audioSession error")
        }
    }
    
    func audioRecorderBeginInterruption(recorder: AVAudioRecorder)
    {
        let alert = UIAlertController(title: "Ops!", message: "O audio nao pode ser gravador por algum erro. Feche o aplicativo e abra o novamente", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) -> Void in
            
            
        }))
        
        self.controller.presentViewController(alert, animated: true) { () -> Void in
            
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if(self.audioOk && !self.cancel)
        {
            print("Audio gravado com sucesso!")
            self.audioOk = false
            let audio = NSData(contentsOfURL: (self.recorder?.url)!)
            if(audio != nil)
            {
                self.delegate?.messageBarEndRecording(self, audio: audio!)
            }
        }
    }
    
    func enableAudio()
    {
        self.audioOk = true
    }

}