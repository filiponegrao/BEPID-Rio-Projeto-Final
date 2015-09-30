//
//  Search_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Search_View: UIView {

    init()
    {
        super.init(frame: CGRectMake(screenWidth-50, 20, 10, 10))
        self.clipsToBounds = true
        self.layer.cornerRadius = screenWidth/2
        
        let blackScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        blackScreen.backgroundColor = UIColor.blackColor()
        blackScreen.alpha = 0.7
        self.addSubview(blackScreen)
        
        let backButton = UIButton(frame: CGRectMake(screenWidth-50, 20, 30, 30))
        backButton.setImage(UIImage(named: "icon_search"), forState: .Normal)
        backButton.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        self.addSubview(backButton)
        
        
        
    }
    
    
    func animateView()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.frame = CGRectMake(0, 0, screenWidth, screenHeight)
            self.layer.cornerRadius = 0
            
            }) { (success) -> Void in
            
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func back()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.frame = CGRectMake(screenWidth - 50, 20, 1, 1)
    
            }) { (succes) -> Void in
             
            self.removeFromSuperview()
        }
    }
}
