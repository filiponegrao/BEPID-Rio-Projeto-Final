//
//  FTNContentTypes.swift
//  FFVChat
//
//  Created by Filipo Negrao on 05/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit


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
    var textView : UITextView!
    
    var view : UIView!
    
    init(frame: CGRect, text: String, mine: Bool) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
        let height = FTNContentTypes.checkHeightForText(text, font: defaultFont, width: frame.width - (margemCellLateral*2)*2)
        
        view = UIView(frame: CGRectMake(margemCellLateral, margemCellView, frame.width - margemCellLateral*2, height + margemCellView*2))
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
        
        textView = UITextView(frame: CGRectMake((margemCellLateral*2), margemCellText, frame.width - (margemCellLateral*2)*2, height))
        textView.backgroundColor = UIColor.clearColor()
        textView.userInteractionEnabled = false
        textView.text = text
        textView.textColor = UIColor.whiteColor()
        textView.font = defaultFont
        
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
    
    init(frame: CGRect, mine: Bool, image: UIImage?)
    {
        super.init(frame: frame)
        
        self.view = UIView(frame: CGRectMake(margemCellLateral, margemCellView, frame.width - margemCellLateral*2, frame.height - margemCellView*2 - heightForStatus))
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
        
        self.addSubview(view)
        self.addSubview(self.imageView)
        
        if(image == nil)
        {
            self.addSubview(self.loading)
            DAOContents.sharedInstance
        }
        else
        {
            self.imageView.image = ImageEdition.blurImage(image!)
            
            let blur = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
            blur.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)
            blur.alpha = 1
            self.imageView.addSubview(blur)
        }
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
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
        
        self.view = UIView(frame: CGRectMake(margemCellLateral, margemCellView, frame.width - margemCellLateral*2, frame.height - margemCellView*2 - heightForStatus))
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
        
        let gif = DAOContents.sharedInstance.getGifWithName(gifname)
        if(gif == nil)
        {
            self.addSubview(self.loading)
        }
        else
        {
            self.gifView.runGif(gif!.data)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatAudioView : UIView
{
    var view : UIView!
    
    var playButton : UIButton!
    
    var slider : UISlider!
    
    var loading : NVActivityIndicatorView!
    
    init(frame: CGRect, audiokey: String, mine: Bool) {
        
        super.init(frame: frame)
        
        self.view = UIView(frame: CGRectMake(margemCellLateral, margemCellView, frame.width - margemCellLateral*2, frame.height - margemCellView*2 - heightForStatus))
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
        
        self.loading = NVActivityIndicatorView(frame: CGRectMake(margemCellLateral + 10, margemCellView + 10, collectionCellHeight - 20 , collectionCellHeight - 20), type: NVActivityIndicatorType.BallClipRotate, color: oficialGreen)
        self.loading.startAnimation()
        
        self.playButton = UIButton(frame: self.loading.frame)
        self.playButton.setImage(UIImage(named: "playButtonBlack"), forState: .Normal)
        self.playButton.hidden = true
        self.playButton.addTarget(self, action: "play", forControlEvents: .TouchUpInside)
        
        self.slider = UISlider(frame: CGRectMake(self.playButton.frame.origin.x + self.playButton.frame.size.width, self.playButton.frame.origin.y, self.view.frame.size.width - self.playButton.frame.size.width - margemCellView - 20, self.playButton.frame.size.height))
        self.slider.setThumbImage(UIImage(named: "indicatorRed"), forState: .Normal)
        self.slider.minimumTrackTintColor = oficialDarkGray
        
        self.addSubview(self.view)
        self.addSubview(self.loading)
        self.addSubview(self.playButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    class func createAudioViewForMessageCell(audioKey: String, cellsize: CGSize, mine: Bool) -> ChatAudioView
    {
        let audioview = ChatAudioView(frame: CGRectMake(0, 0, cellsize.width, cellsize.height), audiokey: audioKey, mine: mine)
        
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
        
        return th + margemCellText*2 + heightForStatus
    }
    
    class func checkHeightForImageView() -> CGFloat
    {
        return screenWidth - margemCellLateral*2 + heightForStatus
    }
    
    class func checkHeightForAudioView() -> CGFloat
    {
        return collectionCellHeight + margemCellView*2 + heightForStatus
    }
    
}