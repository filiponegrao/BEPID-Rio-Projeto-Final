//
//  CustomButton.swift
//  CustomButton
//
//  Created by Filipo Negrao on 30/12/15.
//  Copyright © 2015 Filipo Negrao. All rights reserved.
//

import Foundation
import UIKit

class BubbleButton : UIButton
{
    //Start Click
    var selector1 : Selector?
    
    var target1: AnyObject?
    
    //End Click
    var selector2 : Selector?
    
    var target2: AnyObject?
    
    //Long Click - Desativado temporariamente pela falta de conhecimentos em passar o sender como parametro
    var timer : NSTimer?
    
    var time : Float?
    
    var selector3 : Selector?
    
    var target3 : AnyObject?
    
    var longActionAble : Bool = false
    
    var onAction : Bool = false

    var checkStatus : NSTimer!
    
    init(radius: CGFloat)
    {
        super.init(frame: CGRectMake(0, 0, radius, radius))
        
        self.backgroundColor = UIColor.redColor()
        
        self.layer.cornerRadius = radius/2
        self.clipsToBounds = true
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.redColor()
        
        self.layer.cornerRadius = frame.size.width/2
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.onAction = true
        self.checkStatus = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "checkStatusButton", userInfo: nil, repeats: false)
        
        self.longActionAble = false
        self.runActionStart()
        
        if(self.time != nil && self.target3 != nil && self.selector3 != nil)
        {
            self.timer?.invalidate()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(self.time!), target: self, selector: "turnOnLongAction", userInfo: nil, repeats: false)
        }
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
            
            self.transform = CGAffineTransformMakeScale(0.7, 0.7)
            
            }) { (success: Bool) -> Void in
                
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.timer?.invalidate()
        self.longActionAble = false
        self.expand(nil)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if(self.longActionAble)
        {
            self.longActionAble = false
            self.expand(self.runSelectorLong)
        }
        else if(self.onAction)
        {
            self.timer?.invalidate()
            self.expand(self.runActionEnd)
        }
    }
    
    func expand(function:(()->())?)
    {
        self.onAction = false
        self.checkStatus?.invalidate()
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: .CurveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
            }) { (success: Bool) -> Void in
                
                function?()
        }
    }
    
    override func setImage(image: UIImage?, forState state: UIControlState)
    {
        if(image != nil)
        {
            self.backgroundColor = UIColor.clearColor()
            super.setImage(image, forState: state)
        }
    }
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents)
    {
        if(target != nil)
        {
            self.addTargetOnEnd(action, target: target!)
        }
    }
    
    func addTargetOnStart(selector: Selector, target: AnyObject)
    {
        self.selector1 = selector
        self.target1 = target
    }
    
    func addTargetOnEnd(selector: Selector, target: AnyObject)
    {
        self.selector2 = selector
        self.target2 = target
        
    }
    
    func addLongClickAction(selector: Selector, target: AnyObject, time: Float)
    {
        if(time >= 1)
        {
            self.time = time
            self.selector3 = selector
            self.target3 = target
        }
    }
    
    
    func runActionStart()
    {
        if(selector1 != nil && self.target1 != nil)
        {
            self.target1!.performSelector(self.selector1!, withObject: self)
        }
    }
    
    func runActionEnd()
    {
        if(selector2 != nil && self.target2 != nil)
        {
            self.target2!.performSelector(self.selector2!, withObject: self)
        }
    }
    
    func turnOnLongAction()
    {
        self.longActionAble = true
    }
    
    
    func runSelectorLong()
    {
        if(self.selector3 != nil && self.target3 != nil)
        {
            self.target3!.performSelector(self.selector3!, withObject: self)
        }
    }
    
    func checkStatusButton()
    {
        if(self.onAction)
        {
            self.expand(nil)
        }
    }
    
}