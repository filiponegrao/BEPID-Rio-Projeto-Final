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
    
    var screenDescription : UITextView!
    
    var descriptionLabel : UILabel!
    
    var attributes : NSMutableDictionary!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = oficialMediumGray
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = -5
        
        let alignment = NSMutableParagraphStyle()
        alignment.alignment = NSTextAlignment.Center
        
        self.attributes = NSMutableDictionary()
        self.attributes.setValue(oficialLightGray, forKey: NSForegroundColorAttributeName)
        self.attributes.setValue(style, forKey: NSParagraphStyleAttributeName)
        self.attributes.setValue(UIFont(name: "SukhumvitSet-Text", size: 15)!, forKey: NSFontAttributeName)
//        self.attributes.setValue(alignment, forKey: NSParagraphStyleAttributeName)
        
        //Imagem de fundo
        self.background = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.background.image = UIImage(named: "ContactBackground")
        self.background.alpha = 0.6
        self.view.addSubview(self.background)
        
        //logo myne
        self.logo = UIImageView(frame: CGRectMake(screenWidth/5 * 2, 30, screenWidth/5, screenHeight/18))
        self.logo.image = UIImage(named: "logo2")
        self.logo.contentMode = .ScaleAspectFit
        self.view.addSubview(self.logo)
        
        
        //shape iphone
        self.iphoneShape = UIImageView(frame: CGRectMake((screenWidth - screenWidth/5 * 3.5)/2, screenWidth/4.8, screenWidth/5 * 3.5, screenWidth/3 * 4.1))
        self.iphoneShape.image = UIImage(named: "iphone")
        self.view.addSubview(self.iphoneShape)
        
        //barra com textos
        self.infoView = UIView(frame: CGRectMake(0, screenHeight - screenHeight/6 - 15, screenWidth, screenHeight/6 + 15))
        self.infoView.backgroundColor = oficialDarkGray
        self.view.addSubview(self.infoView)
        
        //textos com descricoes
        self.screenDescription = UITextView(frame: CGRectMake(screenWidth/12, self.infoView.frame.size.height/6, screenWidth/12 * 10, self.infoView.frame.size.height/2))
        self.screenDescription.backgroundColor = UIColor.clearColor()
        self.screenDescription.userInteractionEnabled = false

        self.screenDescription.attributedText = NSAttributedString(string: "First things first: see what friends are using Myne and add them automatically.", attributes: self.attributes as! [String : AnyObject])
    
        self.screenDescription.textContainer.lineFragmentPadding = 0
        self.screenDescription.alpha = 0
        self.screenDescription.textAlignment = NSTextAlignment.Center

        self.infoView.addSubview(self.screenDescription)
        
        //texto facebook
        self.descriptionLabel = UILabel(frame: CGRectMake(screenWidth/14, self.infoView.frame.size.height/6 + self.screenDescription.frame.size.height, screenWidth/14 * 12, self.infoView.frame.size.height/4))
        self.descriptionLabel.backgroundColor = UIColor.clearColor()
        self.descriptionLabel.userInteractionEnabled = false
        self.descriptionLabel.text = "Don't worry: we will NEVER share on Facebook."
        self.descriptionLabel.textColor = oficialLightGray
        self.descriptionLabel.font = UIFont(name: "SukhumvitSet-Text", size: 12)
        self.descriptionLabel.textAlignment = .Center
        self.descriptionLabel.alpha = 0
        self.infoView.addSubview(self.descriptionLabel)
        
        //botão que leva ao login ***PROVISÓRIO***
        self.loginButton = UIButton(frame: CGRectMake(screenWidth - screenWidth/6, 25, 45, 45))
//        self.loginButton.setTitle("Login", forState: .Normal)
//        self.loginButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.loginButton.clipsToBounds = true
        self.loginButton.layer.cornerRadius = 4
        self.loginButton.addTarget(self, action: "login", forControlEvents: .TouchUpInside)
        self.loginButton.setImage(UIImage(named: "goButton"), forState: .Normal)
        self.loginButton.alpha = 0
        self.view.addSubview(self.loginButton)
        
        //PAGE VIEW ONDE OCORRE A TRETA
        
        //função que atualiza frame de acordo com dispositivo
        let yPageControl : CGFloat = -((screenWidth/10.2)/3)  //pro page control começar abaixo
        let heightPageControl = CGFloat(100)
        
        self.setFrameByCurrentDevice()
        
        self.pageView = Tutorial_PageViewController(frame: CGRectMake(self.xPageController, self.yPageController, self.width, self.height), controller: self)
        
        
        self.pageView.pageControl.bounds = CGRectMake(0, yPageControl, 180, heightPageControl)
        
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
            
        case "iPhone 6" :
            //OK
            self.width = CGFloat(Int(screenWidth/1.76))  //largura necessária para o page view encaixar na tela do iphone 6
            self.height = CGFloat(Int(screenWidth + screenWidth/4.95))   //altura necessária para o page view encaixar na tela do iphone 6
            self.xPageController = CGFloat(Int(screenWidth/4.64))
            self.yPageController = CGFloat(Int(screenWidth/3.42))
            
        case "iPhone 6 Plus" :
            //OK
            self.width = CGFloat(Int(screenWidth/1.76))  //largura necessária para o page view encaixar na tela do iphone 6 Plus
            self.height = CGFloat(Int(screenWidth + screenWidth/5.59))   //altura necessária para o page view encaixar na tela do iphone 6 Plus
            self.xPageController = CGFloat(Int(screenWidth/4.64))
            self.yPageController = CGFloat(Int(screenWidth/3.28))
            
        case "iPhone 6s" :
            //OK
            self.width = CGFloat(Int(screenWidth/1.76))  //largura necessária para o page view encaixar na tela do iphone 6s
            self.height = CGFloat(Int(screenWidth + screenWidth/5.0))   //altura necessária para o page view encaixar na tela do iphone 6s
            self.xPageController = CGFloat(Int(screenWidth/4.59))
            self.yPageController = CGFloat(Int(screenWidth/3.402))
            
        case "iPhone 6s Plus" :
            //OK
            self.width = CGFloat(Int(screenWidth/1.76))  //largura necessária para o page view encaixar na tela do iphone 6s Plus
            self.height = CGFloat(Int(screenWidth + screenWidth/5.32))   //altura necessária para o page view encaixar na tela do iphone 6s Plus
            self.xPageController = CGFloat(Int(screenWidth/4.61))
            self.yPageController = CGFloat(Int(screenWidth/3.36))
            
        case "Simulator" :
            //temporario como teste para outros devices
            self.width = CGFloat(Int(screenWidth/1.75))  //largura necessária para o page view encaixar na tela do iphone 5
            self.height = CGFloat(Int(screenWidth + screenWidth/4.3))   //altura necessária para o page view encaixar na tela do iphone 5c
            self.xPageController = CGFloat(Int(screenWidth/4.61))
            self.yPageController = CGFloat(Int(screenWidth/3.59))
            
        default :
            //definindo 5/5c/5s como padrão por enquanto
            self.width = CGFloat(Int(screenWidth/1.75))  //largura necessária para o page view encaixar na tela do iphone 5
            self.height = CGFloat(Int(screenWidth + screenWidth/4.3))   //altura necessária para o page view encaixar na tela do iphone 5c
            self.xPageController = CGFloat(Int(screenWidth/4.61))
            self.yPageController = CGFloat(Int(screenWidth/3.59))


        }
    }
    
    
    func updateDescriptions(index: Int)
    {
        if(index == 0)
        {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.screenDescription.alpha = 0
                self.descriptionLabel.alpha = 0
                self.loginButton.alpha = 0

                }, completion: { (sucess: Bool) -> Void in
                    
                    self.screenDescription.attributedText = NSAttributedString(string: "First things first: see what friends are using Myne and add them automatically.", attributes: self.attributes as! [String : AnyObject])
                    self.screenDescription.textAlignment = NSTextAlignment.Center
                    self.descriptionLabel.text = "Don't worry: we will NEVER share stuff on Facebook."
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.screenDescription.alpha = 1.0
                        self.descriptionLabel.alpha = 1.0
                    })
            })
        }
        else if(index == 1)
        {
            self.loginButton.hidden = true
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.screenDescription.alpha = 0
                self.descriptionLabel.alpha = 0
                self.loginButton.alpha = 0
                
                }, completion: { (sucess: Bool) -> Void in
                    
                    self.screenDescription.attributedText = NSAttributedString(string: "Press your contact's pictures for a full second to quickly access their profiles.", attributes: self.attributes as! [String : AnyObject])
                    self.screenDescription.textAlignment = NSTextAlignment.Center
                    self.descriptionLabel.text = "Tip: you can favorite friends to access them faster."
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.screenDescription.alpha = 1.0
                        self.descriptionLabel.alpha = 1.0
                    })
            })
        }
        else if(index == 2)
        {
            self.loginButton.hidden = true
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.screenDescription.alpha = 0
                self.descriptionLabel.alpha = 0
                self.loginButton.alpha = 0
                
                }, completion: { (sucess: Bool) -> Void in
                    
                    self.screenDescription.attributedText = NSAttributedString(string: "Sent images appear blurred: press and move your finger to see the content.", attributes: self.attributes as! [String : AnyObject])
                    self.screenDescription.textAlignment = NSTextAlignment.Center
                    self.descriptionLabel.text = "Tip: taking screenshots can affect your trust level!"
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.screenDescription.alpha = 1.0
                        self.descriptionLabel.alpha = 1.0
                    })
            })
        }
        else if(index == 3)
        {
            self.loginButton.hidden = true
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.screenDescription.alpha = 0
                self.descriptionLabel.alpha = 0
                self.loginButton.alpha = 0
                
                }, completion: { (sucess: Bool) -> Void in
                    
                    self.screenDescription.attributedText = NSAttributedString(string: "Choose one of these masks and make your images even more confidential.", attributes: self.attributes as! [String : AnyObject])
                    self.screenDescription.textAlignment = NSTextAlignment.Center
                    self.descriptionLabel.text = "Warning: use Spark filter with caution."
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.screenDescription.alpha = 1.0
                        self.descriptionLabel.alpha = 1.0
                    })
            })
        }
        else if(index == 4)
        {
            self.loginButton.hidden = false
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.screenDescription.alpha = 0
                self.descriptionLabel.alpha = 0
                self.loginButton.alpha = 1
                
                }, completion: { (sucess: Bool) -> Void in
                    
                    self.screenDescription.attributedText = NSAttributedString(string: "And define the lifespan - you can, however, resend the content to that user.", attributes: self.attributes as! [String : AnyObject])
                    self.screenDescription.textAlignment = NSTextAlignment.Center
                    self.descriptionLabel.text = "Tip: only you know for how long it will be available."
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.screenDescription.alpha = 1.0
                        self.descriptionLabel.alpha = 1.0
                    })
            })
        }
    }
    
}
