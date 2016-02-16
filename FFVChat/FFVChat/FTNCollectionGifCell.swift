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
        
        let messageColor = oficialGreen
        
        self.gifView = UIGifView(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10))
//        self.gifView.layer.cornerRadius = 5
        self.gifView.contentMode = .ScaleAspectFill
        self.gifView.clipsToBounds = true
        
        self.confirmView = UIView(frame: self.gifView.frame)

        let whiteView = UIView(frame: self.confirmView.frame)
        whiteView.backgroundColor = UIColor.whiteColor()
        whiteView.alpha = 0.5
        
        let label = UILabel(frame: CGRectMake(self.confirmView.frame.size.width/4, self.confirmView.frame.size.height/4, self.confirmView.frame.size.width/2, self.confirmView.frame.size.height/2))
        label.text = "Enviar"
        label.textColor = messageColor
        label.layer.cornerRadius = label.frame.size.width/2
        label.layer.borderWidth = 1
        label.layer.borderColor = messageColor.CGColor
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 14)
        
        self.confirmView.addSubview(whiteView)
        self.confirmView.addSubview(label)
        
        self.confirmView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self.confirmView.hidden = true
        
        self.gifView.addSubview(self.confirmView)
        
        self.addSubview(self.gifView)

    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func insertConfirm()
    {
        self.confirmView.hidden = false
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
            
            self.confirmView.transform = CGAffineTransformMakeScale(1, 1)
            
            }) { (success: Bool) -> Void in
                
        }
    }
    
    func removeConfirm()
    {
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
            
            self.confirmView.transform = CGAffineTransformMakeScale(0.1, 0.1)
            
            }) { (success: Bool) -> Void in
                
                self.confirmView.hidden = true
        }
    }
}
