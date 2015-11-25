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
        
        self.image = UIImageView(frame: CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20))
        self.image.layer.cornerRadius = 8
        self.image.layer.borderWidth = 0.5
        self.image.layer.borderColor = UIColor.grayColor().CGColor
        self.image.contentMode = .ScaleAspectFill
        self.image.clipsToBounds = true
        self.addSubview(self.image)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
