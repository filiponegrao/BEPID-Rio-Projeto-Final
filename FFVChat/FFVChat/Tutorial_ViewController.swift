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
    
    var loginButton : UIButton!

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
        self.logo = UIImageView(frame: CGRectMake(screenWidth/5 * 2, 30, screenWidth/5, screenHeight/18))
        self.logo.image = UIImage(named: "logo")
        self.logo.contentMode = .ScaleAspectFit
        self.view.addSubview(self.logo)
        
        
        //shape iphone
        self.iphoneShape = UIImageView(frame: CGRectMake((screenWidth - screenWidth/5 * 3.5)/2, screenWidth/4.8, screenWidth/5 * 3.5, screenWidth/3 * 4.1))
        self.iphoneShape.image = UIImage(named: "iphone2")
        self.view.addSubview(self.iphoneShape)
        
        //barra com textos
        self.infoView = UIView(frame: CGRectMake(0, screenHeight - screenHeight/6 - 10, screenWidth, screenHeight/6 + 10))
        self.infoView.backgroundColor = oficialDarkGray
        self.view.addSubview(self.infoView)
        
        //botão que leva ao login ***PROVISÓRIO***
        self.loginButton = UIButton(frame: CGRectMake(screenWidth/3, screenHeight - self.infoView.frame.size.height/2, screenWidth/3, 40))
        self.loginButton.setTitle("Login", forState: .Normal)
        self.loginButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.loginButton.clipsToBounds = true
        self.loginButton.layer.cornerRadius = 4
        self.loginButton.backgroundColor = oficialGreen
        self.loginButton.addTarget(self, action: "login", forControlEvents: .TouchUpInside)
        self.loginButton.hidden = false
        self.view.addSubview(self.loginButton)
        
        //PAGE VIEW ONDE OCORRE A TRETA
        
        let width = screenWidth/1.76 //largura necessária para o page view encaixar na tela do iphone
        let height = screenWidth + screenWidth/4.37   //altura necessária para o page view encaixar na tela do iphone
        
        let yPageControl = -((screenWidth/10.2)/3)  //pro page control começar abaixo
        
        self.pageView = Tutorial_PageViewController(size: CGSize(width: width, height: height))
        self.pageView.view.frame = CGRectMake(screenWidth/4.64, screenWidth/3.59, width, height)
        self.pageView.pageControl.bounds = CGRectMake(0, yPageControl, width, 100)
        
        self.addChildViewController(self.pageView)
        self.view.addSubview(self.pageView.view)
        self.didMoveToParentViewController(self.pageView)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login()
    {
        let login = Login_ViewController()
        self.presentViewController(login, animated: true, completion: nil)
    }
    
}
