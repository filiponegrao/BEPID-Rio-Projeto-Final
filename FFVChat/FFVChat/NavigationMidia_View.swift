//
//  NavigationMidia_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class NavigationMidia_View: UIView
{
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    var backButton : UIButton!
    
    var title : UILabel!
    
    init(requester: UIViewController)
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, 80))
        self.backgroundColor = oficialDarkGray
        
        
        self.backButton = UIButton(frame: CGRectMake(0, 25, 44, 44))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(requester, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview((self.backButton))
        
        self.title = UILabel(frame: CGRectMake(0, 25, screenWidth, 44))
        self.title.text = "Lifespan"
        self.title.textAlignment = .Center
        self.title.font = UIFont(name: "SukhumvitSet-Medium", size: 22)
        self.title.setSizeFont(22)
        self.title.textColor = oficialGreen
        self.addSubview(self.title)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
