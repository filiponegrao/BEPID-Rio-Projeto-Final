//
//  FTNCollectionWebCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class FTNCollectionWebCell : UICollectionViewCell
{
    var webView : WKWebView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.webView = WKWebView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
//        self.webView.layer.cornerRadius = 5
        self.webView.contentMode = .ScaleAspectFill
        self.webView.clipsToBounds = true
        self.webView.userInteractionEnabled = false
        self.addSubview(self.webView)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
