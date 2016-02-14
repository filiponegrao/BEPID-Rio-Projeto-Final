//
//  FTNCollectionViewHeader.swift
//  FFVChat
//
//  Created by Filipo Negrao on 14/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class FTNCollectionViewHeader : UICollectionReusableView
{
    var title : UILabel!
    
    var image : UIImageView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.title = UILabel(frame: CGRectMake(20,0,self.frame.size.width/2 - 20, self.frame.size.height))
        self.title.text = "Section"
        self.title.textColor = oficialLightGray
        self.title.font = UIFont(name: "Arial Rounded MT Bold", size: 16)
        self.addSubview(self.title)
        
        self.image = UIImageView(frame: CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height))
        self.image.contentMode = .ScaleAspectFit
        self.addSubview(self.image)
        
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}