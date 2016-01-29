//
//  UIGifView.swift
//  Giffing
//
//  Created by Filipo Negrao on 12/09/15.
//  Copyright (c) 2015 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

class UIGifView : UIImageView
{
    init(frame: CGRect, gifData: NSData)
    {
        super.init(frame: frame)
        
        self.image = UIImage.animatedImageWithData(gifData)
        
        self.contentMode = .ScaleAspectFill
        
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.contentMode = .ScaleAspectFill
        
    }
    
    func runGif(gif: NSData)
    {
        self.image = UIImage.animatedImageWithData(gif)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
