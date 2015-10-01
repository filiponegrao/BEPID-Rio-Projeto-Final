//
//  BlurEffect_.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 30/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class BlurEffect_: UIImageView
{
    var blur : UIBlurEffect!
    var effectView : UIVisualEffectView!
    
    init()
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.effectView = UIVisualEffectView(effect: self.blur)
        self.effectView.frame = self.bounds
        self.addSubview(effectView)

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
