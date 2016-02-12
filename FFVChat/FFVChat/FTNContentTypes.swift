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
    
}

class ChatGifView : UIView
{
    
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
    
}