//
//  CellSentMidia_CollectionViewCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 02/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CellSentMidia_CollectionViewCell: UICollectionViewCell
{
    var image : UIImageView!

    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.image = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
//        self.image.layer.cornerRadius = 8
//        self.image.layer.borderWidth = 0.5
//        self.image.layer.borderColor = UIColor.grayColor().CGColor
        self.image.contentMode = .ScaleAspectFill
        self.image.clipsToBounds = true
        self.addSubview(self.image)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
