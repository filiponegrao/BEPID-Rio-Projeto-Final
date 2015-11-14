//
//  RandomWalk_CollectionViewCell.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/13/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class RandomWalk_CollectionViewCell: UICollectionViewCell
{
    var username:UILabel = UILabel()
    var profileBtn:UIButton = UIButton()
    
    // animate variables
    private var animate = false
    private var paths:[CGPoint] = []
    
    
    // MARK: - Init and Cell Layout Setup
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        labelSetup()
        buttonSetup()
        
        
        self.addSubview(username)
        self.addSubview(profileBtn)
        
        self.sendSubviewToBack(profileBtn)
    }
    
    func labelSetup()
    {
        username.textAlignment = NSTextAlignment.Center
        username.font          = UIFont ( name: (username.font?.fontName)!, size: 12)
        username.textColor     = oficialGreen
    }
    
    func buttonSetup()
    {
        profileBtn.addTarget(self, action: "profileClicked", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func profileClicked()
    {
        print("buttonclicked")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // NAO CONSIDERA NOME COMPOSTO... EXEMPLO: LUIS HAROLDO SOARES
    func setInfo(name:String, profile:UIImage)
    {
        username.text = name
        
        profileBtn.setImage(profile, forState: UIControlState.Normal)
        profileBtn.imageView?.contentMode = .ScaleAspectFill
        
        
        profileBtn.frame = CGRectMake( 0, 0, self.frame.width, self.frame.width )
        profileBtn.layer.cornerRadius = profileBtn.frame.width*0.5
        profileBtn.layer.borderWidth = 2.0
        profileBtn.layer.borderColor = UIColor.grayColor().CGColor
        
        let labelHeight:CGFloat = self.frame.height - self.frame.width
        username.frame = CGRectMake( 0, profileBtn.frame.maxY, self.frame.width, labelHeight )
    }
    
    func startAnimation(withDuration:Double)
    {
        if animate
        {
            return
        }
        srandom(UInt32(time(nil)))
        
        let numberOfSteps = random()%5 + 3
        let numberOfPaths = random()%5 + 3
        let stepDuration:Double = 1 / (2 * Double(numberOfSteps * numberOfPaths))
        
        let xRange = random()%5 + 3
        let yRange = random()%6 + 4
        
        paths = UsefulFunctions.randomWalk(withNumberOfSteps: numberOfSteps, withNumberOfPaths: numberOfPaths, xRange: xRange, yRange: yRange)
        
        
        UIView.animateKeyframesWithDuration(withDuration, delay: 0.0, options: [.Repeat, .BeginFromCurrentState, .CalculationModeCubicPaced, .AllowUserInteraction], animations:
            {
                () -> Void in
                
                for index in 0..<self.paths.count
                {
                    UIView.addKeyframeWithRelativeStartTime(stepDuration * Double(index), relativeDuration: stepDuration, animations:
                        {
                            () -> Void in
                            self.profileBtn.center.x += self.paths[index].x
                            self.profileBtn.center.y += self.paths[index].y
                    })
                }
                
                
            },
            completion: nil)
        
        animate = true
    }
    
    // MARK: - Animation Setup
    
    
    
    
}