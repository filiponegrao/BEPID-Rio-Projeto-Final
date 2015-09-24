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

    var activityIndicator : UIActivityIndicatorView!
    var boxView : UIView!
    
    init()
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.8
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        self.activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.center = self.center
        self.activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        
        self.boxView = UIView()
        self.boxView.frame = CGRect(x: self.frame.midX - 90, y: self.frame.midY - 25, width: 59, height: 50)
        self.boxView.backgroundColor = UIColor.blackColor()
        self.boxView.alpha = 1
        self.boxView.layer.cornerRadius = 10
        self.addSubview(boxView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
