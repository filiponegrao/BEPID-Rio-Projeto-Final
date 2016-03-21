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
    
    var width : CGFloat!
    
    var height: CGFloat!
    
    var xPageController : CGFloat!
    
    var yPageController : CGFloat!

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
        self.iphoneShape.image = UIImage(named: "iphone")
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
        
        //função que atualiza frame de acordo com dispositivo
        self.setFrameByCurrentDevice()
        
        self.pageView = Tutorial_PageViewController(frame: CGRectMake(self.xPageController, self.yPageController, self.width, self.height))
        
        let yPageControl : CGFloat = -((screenWidth/10.2)/3)  //pro page control começar abaixo
        self.pageView.pageControl.bounds = CGRectMake(0, yPageControl, 180, 100)
        
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
    
    func setFrameByCurrentDevice()
    {
        //pegando current device como string
        let modelName = UIDevice.currentDevice().modelName
        print(modelName)
        
        switch modelName {
            
        case "iPhone 5", "iPhone 5c", "iPhone 5s" :
            //OK
            self.width = CGFloat(Int(screenWidth/1.75))  //largura necessária para o page view encaixar na tela do iphone 5
            self.height = CGFloat(Int(screenWidth + screenWidth/4.3))   //altura necessária para o page view encaixar na tela do iphone 5c
            self.xPageController = CGFloat(Int(screenWidth/4.61))
            self.yPageController = CGFloat(Int(screenWidth/3.59))
            
            break
        
        case "iPhone 6" :
            //OK
            self.width = CGFloat(Int(screenWidth/1.76))  //largura necessária para o page view encaixar na tela do iphone 6
            self.height = CGFloat(Int(screenWidth + screenWidth/4.95))   //altura necessária para o page view encaixar na tela do iphone 6
            self.xPageController = CGFloat(Int(screenWidth/4.64))
            self.yPageController = CGFloat(Int(screenWidth/3.42))
            
            break
            
        case "iPhone 6 Plus" :
            //OK
            self.width = CGFloat(Int(screenWidth/1.76))  //largura necessária para o page view encaixar na tela do iphone 6 Plus
            self.height = CGFloat(Int(screenWidth + screenWidth/5.59))   //altura necessária para o page view encaixar na tela do iphone 6 Plus
            self.xPageController = CGFloat(Int(screenWidth/4.64))
            self.yPageController = CGFloat(Int(screenWidth/3.28))
            break
            
        case "iPhone 6s" :
            //OK
            self.width = CGFloat(Int(screenWidth/1.76))  //largura necessária para o page view encaixar na tela do iphone 6s
            self.height = CGFloat(Int(screenWidth + screenWidth/5.0))   //altura necessária para o page view encaixar na tela do iphone 6s
            self.xPageController = CGFloat(Int(screenWidth/4.59))
            self.yPageController = CGFloat(Int(screenWidth/3.402))
            
            break
            
        case "iPhone 6s Plus" :
            //a definir
            self.width = CGFloat(Int(screenWidth/1.76))  //largura necessária para o page view encaixar na tela do iphone 6s Plus
            self.height = CGFloat(Int(screenWidth + screenWidth/5.32))   //altura necessária para o page view encaixar na tela do iphone 6s Plus
            self.xPageController = CGFloat(Int(screenWidth/4.61))
            self.yPageController = CGFloat(Int(screenWidth/3.36))
            
            break
            
        case "Simulator" :
            //temporario como teste para outros devices
            self.width = CGFloat(Int(screenWidth/1.76))  //largura necessária para o page view encaixar na tela do iphone
            self.height = CGFloat(Int(screenWidth + screenWidth/5.32))   //altura necessária para o page view encaixar na tela do iphone
            self.xPageController = CGFloat(Int(screenWidth/4.61))
            self.yPageController = CGFloat(Int(screenWidth/3.36))
            
            break
            
        default :
            //definindo 5/5c/5s como padrão por enquanto
            self.width = CGFloat(Int(screenWidth/1.75))  //largura necessária para o page view encaixar na tela do iphone 5
            self.height = CGFloat(Int(screenWidth + screenWidth/4.3))   //altura necessária para o page view encaixar na tela do iphone 5c
            self.xPageController = CGFloat(Int(screenWidth/4.61))
            self.yPageController = CGFloat(Int(screenWidth/3.59))

        }
        
        
        //        //LOG VALORES LARGURA E ALTURA
        //        print("Classe: Tutorial_ViewController")
        //        print("Largura Tutorial_PageViewController: \(width)")
        //        print("Altura Tutorial_PageViewController: \(height)")
        //        print("--------")
    }
    
}
