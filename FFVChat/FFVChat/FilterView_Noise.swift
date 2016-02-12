//
//  FilterView_Noise.swift
//  FFVChat
//
//  Created by Filipo Negrao on 02/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class FilterView_Noise : UIView
{
    var image : Image!
    
    init(image: Image)
    {
        self.image = image
        
        super.init(frame: CGRectMake(0, 70, screenWidth, screenHeight - 70))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}