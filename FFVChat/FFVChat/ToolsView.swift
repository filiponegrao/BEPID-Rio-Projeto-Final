//
//  ToolsView.swift
//  FFVChat
//
//  Created by Filipo Negrao on 06/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class ToolsView : UIView
{
    var blackScreen : UIView!
    
    var endTools : UIButton!
    
    init()
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.blackScreen = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0.5
        
        self.endTools = UIButton(frame: CGRectMake(screenWidth - 50, 20, 40, 40))
        self.endTools.setTitle("X", forState: .Normal)
        self.endTools.addTarget(self, action: "", forControlEvents: .TouchUpInside)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}