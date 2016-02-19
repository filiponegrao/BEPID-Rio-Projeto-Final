//
//  CellFilter_CollectionViewCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 01/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CellFilter_CollectionViewCell: UICollectionViewCell {
    
    var imageView : UIImageView!
    
    var title : UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.title = UILabel(frame: CGRectMake(5, frame.size.height - 22, frame.size.width - 10, 20))
        self.title.adjustsFontSizeToFitWidth = true
        self.title.textColor = oficialLightGray
        self.title.textAlignment = .Center
        self.title.font = UIFont(name: "SukhumvitSet-Light", size: 14)
        self.title.adjustsFontSizeToFitWidth = true
        self.addSubview(self.title)
        
        self.imageView = UIImageView(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - self.title.frame.size.height - 10))
        self.imageView.layer.cornerRadius = 0
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.borderColor = oficialLightGray.CGColor
        self.imageView.clipsToBounds = true
        self.addSubview(self.imageView)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
