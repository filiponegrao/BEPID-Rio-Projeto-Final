//
//  FTNCollectionGifCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class FTNCollectionGifCell : UICollectionViewCell
{
    var gifView : UIGifView!
    
    var confirmView : UIView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let messageColor = oficialDarkGray
        
        self.gifView = UIGifView(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10))
//        self.gifView.layer.cornerRadius = 5
        self.gifView.contentMode = .ScaleAspectFill
        self.gifView.clipsToBounds = true
        
        self.confirmView = UIView(frame: self.gifView.frame)

        let whiteView = UIView(frame: self.confirmView.bounds)
        whiteView.backgroundColor = UIColor.whiteColor()
        whiteView.alpha = 0.2
        
        let label = UILabel(frame: CGRectMake(0, 0, self.confirmView.frame.size.width*2/3, self.confirmView.frame.size.height*2/3))
        label.center = CGPointMake(self.confirmView.frame.size.width/2, self.confirmView.frame.size.height/2)
        label.text = "Enviar"
        label.textColor = UIColor.whiteColor()
        label.layer.cornerRadius = label.frame.size.width/2
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.whiteColor().CGColor
        label.textAlignment = .Center
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 16)
        
        self.confirmView.addSubview(whiteView)
        self.confirmView.addSubview(label)
        
        self.confirmView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self.confirmView.hidden = true
        
        self.addSubview(self.gifView)
        
        self.addSubview(self.confirmView)


    }

    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func insertConfirm()
    {
        self.confirmView.hidden = false
        self.confirmView.layer.cornerRadius = self.confirmView.frame.size.width/2
        
        self.gifView.alpha = 0.5
        
        self.gifView.layer.borderColor = oficialGreen.CGColor
        self.gifView.layer.borderWidth = 1

        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
            
            self.confirmView.transform = CGAffineTransformMakeScale(1, 1)
            self.confirmView.layer.cornerRadius = 0
            
            }) { (success: Bool) -> Void in
                
        }
    }
    
    
    func removeConfirm()
    {
        self.gifView.layer.borderWidth = 0
        
        self.gifView.alpha = 1

        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
            
            self.confirmView.transform = CGAffineTransformMakeScale(0.01, 0.01)
            self.confirmView.layer.cornerRadius = self.confirmView.frame.size.width/2
            
            }) { (success: Bool) -> Void in
                
                self.confirmView.hidden = true
        }
    }
}

