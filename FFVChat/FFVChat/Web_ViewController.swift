//
//  Web_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 17/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class Web_ViewController : UIViewController
{
    var webView : WKWebView!
    
    var navBar : UIView!
    
    var back : UIButton!
    
    var url : NSURL!
    
    init(url: NSURL)
    {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = oficialMediumGray
        
        self.back = UIButton(frame: CGRectMake(10, 20, 44, 44))
        self.back.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.back.addTarget(self, action: "voltar", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.back)
        
        self.webView = WKWebView(frame: CGRectMake(0,70,screenWidth, screenHeight - 70))
        self.webView.backgroundColor = UIColor.clearColor()
        self.webView.loadRequest(NSURLRequest(URL: self.url))
        self.view.addSubview(self.webView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func voltar()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}