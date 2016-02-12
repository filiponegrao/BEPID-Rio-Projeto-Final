//
//  AudioKeyboard.swift
//  FFVChat
//
//  Created by Filipo Negrao on 06/01/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit


class AudioKeyboard : UIView
{
    weak var controller : Chat_ViewController!
    
    var closeButton : UIButton!
    
    var recordButton : BubbleButton!
        
    init(controller: Chat_ViewController)
    {
        self.controller = controller
        
        super.init(frame: CGRectMake(0, screenHeight-180, screenWidth, 180))
        
        self.backgroundColor = oficialDarkGray
        
        self.closeButton = UIButton(frame: CGRectMake(0,0,80,45))
//        self.closeButton.setImage(UIImage(named: "close"), forState: .Normal)
        self.closeButton.setTitle("Cancel", forState: .Normal)
        self.closeButton.setTitleColor(oficialLightGray, forState: .Normal)
        self.addSubview(self.closeButton)
        
        self.recordButton = BubbleButton(radius: 80)
        self.recordButton.center = CGPointMake(screenWidth/2, 90)
        self.recordButton.backgroundColor = oficialRed
        self.recordButton.layer.cornerRadius = 40
        self.recordButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.recordButton.layer.borderWidth = 2
        self.recordButton.addTargetOnStart("startRecord", target: self)
        self.recordButton.addTargetOnEnd("stopRecord", target: self)
        self.addSubview(self.recordButton)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func startRecord()
    {
//        self.controller.startRecord()
    }
    
    func stopRecord()
    {
//        self.controller.stopRecord()
    }
}