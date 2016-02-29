//
//  FTNContentTypes.swift
//  FFVChat
//
//  Created by Filipo Negrao on 05/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


enum MessageType
{
    case Image
    
    case Audio
    
    case Gif
    
    case Text
    
    case Video
}

class ChatTextView : UIView
{
    var textView : ActiveLabel!
    
    var view : UIView!
    
    init(frame: CGRect, text: String, mine: Bool) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
        let height = FTNContentTypes.checkHeightForText(text, font: defaultFont, width: frame.width - (margemCellLateral*2)*2)
        
        view = UIView(frame: CGRectMake(margemCellLateral, margemCellView, frame.width - margemCellLateral*2, height + margemCellText*2))
        view.layer.cornerRadius = 3
        if(mine)
        {
            view.backgroundColor = mineMessagesColor
            view.alpha = mineMessagesAlpha
        }
        else
        {
            view.backgroundColor = otherMessagesColor
            view.alpha = otherMessagesAlpha
        }
        
        textView = ActiveLabel(frame: CGRectMake((margemCellLateral + margemCellLateral/2), self.view.frame.origin.y + margemCellText, frame.width - (margemCellLateral*2) - margemCellLateral, height))
        textView.backgroundColor = UIColor.clearColor()
//        textView.userInteractionEnabled = false
        textView.text = text
        textView.textColor = UIColor.whiteColor()
        textView.font = defaultFont
        textView.numberOfLines = 0
//        textView.layer.borderWidth = 1
        textView.handleURLTap { (url: NSURL) -> () in
            NSNotificationCenter.defaultCenter().postNotificationName(FTNChatNotifications.linkClicked(), object: nil, userInfo: ["url": url])
        }
        
        self.addSubview(view)
        self.addSubview(textView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatImageView : UIView
{
    var view : UIView!
    
    var imageView : UIImageView!
    
    var loading : NVActivityIndicatorView!
    
    var blur : UIVisualEffectView!
    
    init(frame: CGRect, mine: Bool, image: UIImage?)
    {
        super.init(frame: frame)
        
        self.view = UIView(frame: CGRectMake(margemCellLateral, margemCellView, frame.width - margemCellLateral*2, frame.height - margemCellView*2))
        view.layer.cornerRadius = 3
        if(mine)
        {
            view.backgroundColor = mineMessagesColor
            view.alpha = mineMessagesAlpha
        }
        else
        {
            view.backgroundColor = otherMessagesColor
            view.alpha = otherMessagesAlpha
        }
        
        self.imageView = UIImageView(frame: CGRectMake( self.view.frame.origin.x + margemCellView, self.view.frame.origin.y + margemCellView, self.view.frame.size.width - (margemCellView)*2, self.view.frame.size.height - (margemCellView)*2 - heightForStatus))
        self.imageView.layer.cornerRadius = 3
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .ScaleAspectFill
        
        self.loading = NVActivityIndicatorView(frame: self.imageView.frame, type: NVActivityIndicatorType.BallClipRotate, color: oficialGreen, size: CGSizeMake(80, 80))
        self.loading.startAnimation()
        
        self.blur = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        blur.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)
        blur.alpha = 1
        
        self.addSubview(view)
        self.addSubview(self.imageView)
        self.imageView.addSubview(blur)
        self.addSubview(self.loading)
        
        if(image == nil)
        {
            self.imageView.hidden = true
            self.loading.hidden = false
        }
        else
        {
            self.imageView.image = ImageEdition.blurImage(image!)
            self.loading?.removeFromSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        self.imageView?.image = nil
        self.imageView?.removeFromSuperview()
        self.loading?.removeFromSuperview()
        self.blur?.removeFromSuperview()
    }
}

class ChatGifView : UIView
{
    var view : UIView!
    
    var gifView : UIGifView!
    
    var loading : NVActivityIndicatorView!

    init(frame: CGRect, mine: Bool, gifname: String)
    {
        super.init(frame: frame)
        
        self.view = UIView(frame: CGRectMake(margemCellLateral, margemCellView, frame.width - margemCellLateral*2, frame.height - margemCellView*2))
        view.layer.cornerRadius = 3
        if(mine)
        {
            view.backgroundColor = mineMessagesColor
            view.alpha = mineMessagesAlpha
        }
        else
        {
            view.backgroundColor = otherMessagesColor
            view.alpha = otherMessagesAlpha
        }
        
        self.gifView = UIGifView(frame: CGRectMake( self.view.frame.origin.x + margemCellView, self.view.frame.origin.y + margemCellView, self.view.frame.size.width - (margemCellView)*2, self.view.frame.size.height - (margemCellView)*2 - heightForStatus))
        self.gifView.layer.cornerRadius = 3
        self.gifView.clipsToBounds = true
        
        self.loading = NVActivityIndicatorView(frame: self.gifView.frame, type: NVActivityIndicatorType.BallClipRotate, color: oficialGreen, size: CGSizeMake(80, 80))
        self.loading.startAnimation()
        
        self.addSubview(view)
        self.addSubview(self.gifView)
        self.addSubview(self.loading)

        
        let gif = DAOContents.sharedInstance.getGifWithName(gifname)
        if(gif == nil)
        {
            self.loading.hidden = false
            self.gifView.hidden = true
        }
        else
        {
            self.gifView.runGif(gif!.data)
            self.loading?.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        print("desalocando celula de gif")
        self.gifView.image = nil
        self.gifView?.removeFromSuperview()
        self.loading?.removeFromSuperview()
        self.view?.removeFromSuperview()
    }
}

class ChatAudioView : UIView, AVAudioPlayerDelegate
{
    var audioPlayer : AVAudioPlayer!
    
    var view : UIView!
    
    var playButton : UIButton!
    
    var slider : UISlider!
    
    var loading : NVActivityIndicatorView!
    
    var timer : NSTimer!
    
    var seconds: CGFloat = 0
    
    var max : CGFloat = 0
    
    weak var cell : FTNCollectionViewCell!
    
    init(frame: CGRect, audiokey: String, mine: Bool, cell: FTNCollectionViewCell)
    {
        self.cell = cell
        super.init(frame: frame)
        
        self.view = UIView(frame: CGRectMake(margemCellLateral, margemCellView, frame.width - margemCellLateral*2, self.frame.height - margemCellView*2))
        view.layer.cornerRadius = 3
        
        if(mine)
        {
            view.backgroundColor = mineMessagesColor
            view.alpha = mineMessagesAlpha
        }
        else
        {
            view.backgroundColor = otherMessagesColor
            view.alpha = otherMessagesAlpha
        }
        
        self.loading = NVActivityIndicatorView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.height), type: NVActivityIndicatorType.BallClipRotate, color: oficialGreen)
        self.loading.startAnimation()
        
        self.playButton = UIButton(frame: self.loading.frame)
        self.playButton.setImage(UIImage(named: "playButton"), forState: .Normal)
        self.playButton.addTarget(self, action: "clickPlay", forControlEvents: .TouchUpInside)
        
        self.slider = UISlider(frame: CGRectMake(self.playButton.frame.origin.x + self.playButton.frame.size.width, self.playButton.frame.origin.y, self.view.frame.size.width - self.playButton.frame.size.width - margemCellView - 20, self.playButton.frame.size.height))
        self.slider.setThumbImage(UIImage(named: "indicator"), forState: .Normal)
        self.slider.minimumValue = 0
        self.slider.maximumValue = 100
        self.slider.enabled = false
        
        if(mine)
        {
            self.slider.maximumTrackTintColor = oficialSemiGray
            self.slider.minimumTrackTintColor = oficialDarkGreen
        }
        else
        {
            self.slider.maximumTrackTintColor = oficialLightGray
            self.slider.minimumTrackTintColor = oficialDarkGreen
        }
        
        self.addSubview(self.view)
        self.addSubview(self.slider)
        self.addSubview(self.loading)
        self.addSubview(self.playButton)

        
        let audio = DAOContents.sharedInstance.getAudioFromKey(audiokey)
        if(audio == nil)
        {
            self.playButton.hidden = true
            self.loading.hidden = false
        }
        else
        {
            self.slider.enabled = true
            self.loading?.removeFromSuperview()
            self.playButton.hidden = false
            self.initPlayer(audio!)
        }
    }
    
    func initPlayer(audio: NSData)
    {
        self.audioPlayer = try! AVAudioPlayer(data: audio)
        self.audioPlayer.delegate = self
    }
    
    func clickPlay()
    {
        if(self.audioPlayer != nil)
        {
            if(self.audioPlayer!.playing)
            {
                self.stopAudio()
            }
            else
            {
                self.playAudio()
            }
        }
    }
    
    func playAudio()
    {
        self.timer?.invalidate()
        
        self.cell.deleteMessage()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        if(audioSession.category == AVAudioSessionCategoryAmbient)
        {
            do { try audioSession.setCategory(AVAudioSessionCategoryPlayback) }
            catch { print("audioSession error)") }
            
            self.audioPlayer?.play()
            self.playButton.setImage(UIImage(named: "pauseButton"), forState: .Normal)
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateTimeLabel", userInfo: nil, repeats: true)
        }
    }
    
    func updateTimeLabel()
    {
        self.slider.value = Float((self.audioPlayer.currentTime * 100.0) / self.audioPlayer.duration)
    }
    
    func stopAudio()
    {
        let audioSession = AVAudioSession.sharedInstance()
        
        do { try audioSession.setCategory(AVAudioSessionCategoryAmbient) }
        catch { print("audioSession error)") }
        
        self.audioPlayer?.stop()
        self.timer?.invalidate()
        self.playButton.setImage(UIImage(named: "playButton"), forState: .Normal)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
    {
        self.playButton.setImage(UIImage(named: "playButton"), forState: .Normal)
        self.timer?.invalidate()
        self.slider.value = 0
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do { try audioSession.setCategory(AVAudioSessionCategoryAmbient) }
        catch { print("audioSession error)") }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        print("Desalocando view de audio")
        self.audioPlayer?.delegate = nil
    }
}

class FTNContentTypes
{
    class func createTextViewForMessageCell(text: String, cellsize: CGSize, mine: Bool) -> ChatTextView
    {
        let textView = ChatTextView(frame: CGRectMake(0, 0, cellsize.width, cellsize.height), text: text, mine: mine)
        
        return textView
    }
    
    class func createImageViewForMessageCell(image: UIImage?, cellsize: CGSize, mine: Bool) -> ChatImageView
    {
        let imageView = ChatImageView(frame: CGRectMake(0, 0, cellsize.width, cellsize.height), mine: mine, image: image)
        
        return imageView
    }

    class func createGifViewForMessageCell(gifname: String, cellsize: CGSize, mine: Bool) -> ChatGifView
    {
        let gifview = ChatGifView(frame: CGRectMake(0, 0, cellsize.width, cellsize.height), mine: mine, gifname: gifname)
        
        return gifview
    }
    
    class func createAudioViewForMessageCell(audioKey: String, cellsize: CGSize, mine: Bool, cell: FTNCollectionViewCell) -> ChatAudioView
    {
        let audioview = ChatAudioView(frame: CGRectMake(0, 0, cellsize.width, cellsize.height), audiokey: audioKey, mine: mine, cell: cell)
        
        return audioview
    }
    
    //Auxiliares
    class func checkHeightForText(text: String, font: UIFont, width: CGFloat) -> CGFloat
    {
        let textView = UITextView(frame: CGRectMake(0, 0, width, 10))
        textView.font = font
        textView.text = text
        
        return textView.contentSize.height
    }
    
    class func checkHeigthForView(text: String, font: UIFont, width: CGFloat) -> CGFloat
    {
        let th = self.checkHeightForText(text, font: font, width: width - (margemCellLateral*2)*2)
        
        return th + margemCellText*2 + margemCellView*2 //+ heightForStatus
    }
    
    class func checkHeightForImageView() -> CGFloat
    {
        return screenWidth*2/3
    }
    
    class func checkHeightForAudioView() -> CGFloat
    {
        return collectionCellHeight + margemCellView*2 + heightForStatus
    }
    
}