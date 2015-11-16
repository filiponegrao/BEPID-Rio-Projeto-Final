//
//  LoadScreen_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class LoadScreen_View: UIView
{
    var blackScreen : UIView!
    
    var indicator : NVActivityIndicatorView!
    
    init()
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.backgroundColor = UIColor.clearColor()
        
        self.blackScreen = UIView(frame: CGRectMake(0,0,screenWidth,screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0.7
        self.addSubview(self.blackScreen)
        
        self.indicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, 60, 60), type: NVActivityIndicatorType.BallPulse, color: UIColor.whiteColor())
        self.indicator.center = self.center
        self.indicator.startAnimation()
        self.addSubview(self.indicator)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
