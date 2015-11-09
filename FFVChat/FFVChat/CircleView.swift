//
//  CircleView.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 08/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CircleView: UIView
{
    var circleLayer: CAShapeLayer!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.clearColor().CGColor
        circleLayer.lineWidth = 5.0;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    func animateCircle(duration: NSTimeInterval, trustLevel: Int)
    {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        let time = CGFloat(trustLevel)
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = time / 100
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = time / 100
        
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }

    func setColor(trust: String!)
    {
        if(trustLevel == 100)
        {
            circleLayer.strokeColor = oficialGreen.CGColor
            circleLayer.fillColor = UIColor.clearColor().CGColor
        }
        else
        {
            circleLayer.strokeColor = oficialRed.CGColor
            circleLayer.fillColor = UIColor.clearColor().CGColor
        }
    }
}
