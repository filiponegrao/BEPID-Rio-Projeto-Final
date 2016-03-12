//
//  Tutorial_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/03/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class Tutorial_ViewController: UIViewController
{
    var iphoneShape : UIImageView!
    
    var logo : UIImageView!
    
    var infoView : UIView!
    
    var background : UIImageView!
    
    var pageView : Tutorial_PageViewController!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = oficialMediumGray
        
        //Imagem de fundo
        self.background = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.background.image = UIImage(named: "ContactBackground")
        self.background.alpha = 0.6
        self.view.addSubview(self.background)
        
        //logo myne
        self.logo = UIImageView(frame: CGRectMake(screenWidth/4, 30, screenWidth/2, screenHeight/15))
        self.logo.image = UIImage(named: "logo")
        self.logo.contentMode = .ScaleAspectFit
        self.view.addSubview(self.logo)
        
        
        //shape iphone
        self.iphoneShape = UIImageView(frame: CGRectMake((screenWidth - screenWidth/5 * 3.5)/2, screenWidth/4.2, screenWidth/5 * 3.5, screenHeight/6 * 4.5))
        self.iphoneShape.image = UIImage(named: "iphone")
        self.view.addSubview(self.iphoneShape)
        
        //PAGE VIEW ONDE SE DÁ A MERDA
        
        let width = screenWidth/1.77
        let height = screenWidth/3 * 3
        
        self.pageView = Tutorial_PageViewController(size: CGSize(width: width, height: height))
        self.pageView.view.frame = CGRectMake(screenWidth/4.65, screenWidth/2.5, width, height)
        self.addChildViewController(self.pageView)
        self.view.addSubview(self.pageView.view)
        self.didMoveToParentViewController(self.pageView)
        
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
