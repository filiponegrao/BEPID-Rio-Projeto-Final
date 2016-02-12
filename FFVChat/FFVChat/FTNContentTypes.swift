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
    
}