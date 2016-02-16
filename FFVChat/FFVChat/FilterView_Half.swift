//
//  FilterView_Half.swift
//  FFVChat
//
//  Created by Filipo Negrao on 02/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit


class FilterView_Half : UIView
{
    var image : Image!
    
    var imageView : UIImageView!
    
    var blurFilter : UIVisualEffectView!
    
    var timer : NSTimer!
    
    init(image: Image)
    {
        self.image = image
        
        super.init(frame: CGRectMake(0, 70, screenWidth, screenHeight - 70))
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.blackColor()
        self.layer.zPosition = 10
        self.alpha = 1
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.image = UIImage(data: self.image.data)!
        self.imageView.layer.zPosition = 0
        self.addSubview(self.imageView)
        
        //Blur
        self.blurFilter = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.blurFilter.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height/2)
        self.blurFilter.alpha = 1
        self.addSubview(self.blurFilter)
        
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "changePosition", userInfo: nil, repeats: true)
        
    }
    
    func changePosition()
    {
        if(self.blurFilter.frame.origin.y == 0)
        {
            self.blurFilter.frame.origin.y = self.imageView.frame.size.height/2
        }
        else
        {
            self.blurFilter.frame.origin.y = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}