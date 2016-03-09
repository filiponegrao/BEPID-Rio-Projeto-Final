//
//  TutoFirst_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 07/03/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class TutoFirst_ViewController: UIViewController
{
    var index = 0
    
    var iphoneShape : UIImageView!
    
    var logo : UIImageView!
    
    var infoView : UIView!
    
    var background : UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        //logo myne
        self.logo = UIImageView(frame: CGRectMake(screenWidth/4, 30, screenWidth/2, screenHeight/15))
        self.logo.image = UIImage(named: "logo")
        self.logo.contentMode = .ScaleAspectFit
        self.view.addSubview(self.logo)
        
        //shape iphone
        self.iphoneShape = UIImageView(frame: CGRectMake((screenWidth - screenWidth/5 * 3.5)/2, screenHeight/7, screenWidth/5 * 3.5, screenHeight/6 * 4.5))
        self.iphoneShape.image = UIImage(named: "iphone")
        self.view.addSubview(self.iphoneShape)
        
        //view com textos
        self.infoView = UIView(frame: CGRectMake(0, screenHeight - screenHeight/6 - 10, screenWidth, screenHeight/6 + 10))
        self.infoView.backgroundColor = oficialDarkGray
        self.view.addSubview(self.infoView)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
