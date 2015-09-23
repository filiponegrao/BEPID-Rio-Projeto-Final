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

    init()
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.backgroundColor = UIColor.blackColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
