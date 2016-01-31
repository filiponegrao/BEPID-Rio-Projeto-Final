//
//  CellWebGifView.swift
//  FFVChat
//
//  Created by Filipo Negrao on 06/01/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class CellWebGifView : UICollectionViewCell
{
    var webView : WKWebView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.webView = WKWebView(frame: CGRectMake(0,0,frame.size.width, frame.size.height))
        self.webView.userInteractionEnabled = false
        self.webView.contentMode = .ScaleAspectFill
        self.webView.backgroundColor = oficialDarkGray
        self.addSubview(self.webView)
    }
    
    
    deinit
    {
//        self.webView.delegate = nil
        self.webView = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
}


