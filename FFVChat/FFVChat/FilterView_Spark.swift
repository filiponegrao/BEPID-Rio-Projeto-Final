//
//  FilterView_Spark.swift
//  FFVChat
//
//  Created by Filipo Negrao on 02/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit


class FilterView_Spark : UIView
{
    var image : Image!
    
    var sparkTimer : NSTimer!
    
    var imageView : UIImageView!
    
    var blurFilter : UIVisualEffectView!
    
    init(image: Image)
    {
        self.image = image
        
        super.init(frame: CGRectMake(0, 70, screenWidth, screenHeight - 70))
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = UIImage(data: self.image.data)!
        self.addSubview(self.imageView)
        
        self.sparkTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "alphaHandler", userInfo: nil, repeats: true)
        
        //Blur
        self.blurFilter = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.blurFilter.frame = self.imageView.frame
        self.blurFilter.alpha = 1
        self.addSubview(self.blurFilter)
        
    }
    
    
    func alphaHandler()
    {
        if(self.blurFilter.alpha == 0)
        {
            self.alphaOn()
        }
        else
        {
            self.alphaOff()
        }
    }
    
    
    func alphaOn()
    {
        self.blurFilter.alpha = 1
    }
    
    
    func alphaOff()
    {
        self.blurFilter.alpha = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}