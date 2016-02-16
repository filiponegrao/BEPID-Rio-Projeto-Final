//
//  Filters_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 01/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Filters_ViewController: UIViewController, FNChoiceBarDelegate
{
    var topBar : UIView!
    
    var backButton : UIButton!
    
    var imageView : UIImageView!
    
    var choiceBar : FNChoiceBar!
    
    var selectionBar : UIView!
    
    var doneButton : MKButton!
    
    var details : UILabel!
    
    //Dados a enviar
    
    var contact: Contact!
    
    var lifeTime : Int!
    
    var image : UIImage!
    
    //Dados
    
    var filtros = ["No Filter", "Circle", "Spark", "Half"]
    
    var imageFilters = [UIImage(named: "NoFilter")!, UIImage(named: "CircleFilter")!, UIImage(named: "NoFilter")!, UIImage(named: "NoFilter")!]
    
    var selectedFilter : ImageFilter = ImageFilter.None
    
    //Efeitos
    
    var circleBlur : UIVisualEffectView!
    
    var circleUnblur : UIImageView!
    
    var sparkBlur : UIVisualEffectView!
    
    var halfBlur : UIVisualEffectView!
    
    var contador : NSTimer!
    
    var warning : NSTimer!
    
    var halfTimer : NSTimer!
    
    var lifespan : SelectedMidia_ViewController!
    
    init(image: UIImage, lifeTime: Int, contact: Contact)
    {
        self.image = image
        self.lifeTime = lifeTime
        self.contact = contact
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        let heightdetails : CGFloat = 44
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight*2/3))
        self.imageView.image = image
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.backgroundColor = oficialDarkGray
        self.view.addSubview(self.imageView)
        
        self.topBar = UIView(frame: CGRectMake(0, 0, screenWidth, 70))
        self.topBar.backgroundColor = UIColor.blackColor()
        self.topBar.alpha = 0.5
        self.view.addSubview(self.topBar)
        
        self.backButton = UIButton(frame: CGRectMake(0,20, 50,50))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.backButton)
        
        self.doneButton = MKButton(frame: CGRectMake(0, screenHeight - 50, screenWidth, 50))
        self.doneButton.backgroundColor = oficialGreen
        self.doneButton.setTitle("Done", forState: .Normal)
        self.doneButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.doneButton.setTitleColor(oficialMediumGray, forState: .Highlighted)
        self.doneButton.addTarget(self, action: "done", forControlEvents: .TouchUpInside)
        self.doneButton.backgroundLayerCornerRadius = 900
        self.doneButton.rippleLocation = .Center
        self.doneButton.ripplePercent = 4
        self.doneButton.rippleLayerColor = oficialDarkGray
        self.view.addSubview(self.doneButton)
        
        self.details = UILabel(frame: CGRectMake(20, self.imageView.frame.origin.y + self.imageView.frame.size.height, self.view.frame.size.width - 40, heightdetails))
        self.details.text = "0% Seguro (ATENÇÃO)"
        self.details.textColor = GMColor.red500Color()
        self.details.font = UIFont(name: "SukhumvitSet-Light", size: 16)
//        self.view.addSubview(self.details)
        
        let altura = screenHeight - self.imageView.frame.size.height - self.doneButton.frame.size.height - 10// - heightdetails/2
        
        self.choiceBar = FNChoiceBar(altura: altura, opcoes: self.filtros, imagens: self.imageFilters)
        self.choiceBar.delegate = self
        self.choiceBar.frame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + 10
        self.view.addSubview(self.choiceBar)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func fnChoiceBar(itemSelecionado index: Int)
    {
        switch index
        {
            
        case 0:
            self.selectedFilter = ImageFilter.None
            self.removePreVisualizacaoCircle()
            self.removePrevisualizacaoHalf()
            self.removePreVisualizacaoSpark()
            
        case 1:
            self.selectedFilter = ImageFilter.Circle
            self.removePreVisualizacaoSpark()
            self.removePrevisualizacaoHalf()
            self.preVisualizacaoCircle()
            
        case 2:
            self.selectedFilter = ImageFilter.Spark
            self.removePreVisualizacaoCircle()
            self.removePrevisualizacaoHalf()
            self.preVisualizacaoSpark()
            
        case 3:
            self.selectedFilter = ImageFilter.Half
            self.removePreVisualizacaoCircle()
            self.removePreVisualizacaoSpark()
            self.preVisualizacaoHalf()
            
        default:
            print("indicie incorreto")
            
        }
    }
    
    func preVisualizacaoCircle()
    {
        self.circleBlur?.removeFromSuperview()
        self.circleBlur = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.circleBlur.frame = self.imageView.bounds
        self.circleBlur.alpha = 0
        self.imageView.addSubview(self.circleBlur)
        
        self.circleUnblur?.removeFromSuperview()
        self.circleUnblur = UIImageView(frame: CGRectMake(0, 0, diametro, diametro))
        self.circleUnblur.center = self.imageView.center
        self.circleUnblur.layer.cornerRadius = raio
        self.circleUnblur.contentMode = .ScaleToFill
        self.circleUnblur.clipsToBounds = true
        self.circleUnblur.image = Editor.circleUnblur(self.image, x: self.circleUnblur.frame.origin.x, y: self.circleUnblur.frame.origin.y, imageFrame: self.imageView.frame)
        self.circleUnblur.alpha = 0
        self.imageView.addSubview(self.circleUnblur)
        
        UIView.animateWithDuration(0.3) { () -> Void in
            
            self.circleUnblur.alpha = 1
            self.circleBlur.alpha = 1
        }
    }
    
    func removePreVisualizacaoCircle()
    {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.circleUnblur?.alpha = 0
            self.circleBlur?.alpha = 0
            }) { (success: Bool) -> Void in
                self.circleBlur?.removeFromSuperview()
                self.circleUnblur?.removeFromSuperview()
        }
    }
    
    func preVisualizacaoSpark()
    {
        self.sparkBlur?.removeFromSuperview()
        self.sparkBlur = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.sparkBlur.frame = self.imageView.bounds
        self.sparkBlur.alpha = 0
        self.imageView.addSubview(self.sparkBlur)
        
        self.contador?.invalidate()
        self.contador = nil
        self.contador = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "changeAlpha", userInfo: nil, repeats: true)
        
        self.warning?.invalidate()
        self.warning = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "sparkWarning", userInfo: nil, repeats: false)

    }
    
    func removePreVisualizacaoSpark()
    {
        self.warning?.invalidate()
        self.contador?.invalidate()
        self.contador = nil
        self.sparkBlur?.removeFromSuperview()
    }
    
    func preVisualizacaoHalf()
    {
        self.halfBlur?.removeFromSuperview()
        self.halfBlur = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.halfBlur.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height/2)
        self.halfBlur.alpha = 1
        self.imageView.addSubview(self.halfBlur)
        
        self.halfTimer?.invalidate()
        self.halfTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "changePosition", userInfo: nil, repeats: true)

    }
    
    func removePrevisualizacaoHalf()
    {
        self.halfTimer?.invalidate()
        self.halfBlur?.removeFromSuperview()
    }
    
    func changeAlpha()
    {
        if(self.sparkBlur.alpha == 0)
        {
            self.sparkBlur.alpha = 1
        }
        else
        {
            self.sparkBlur.alpha = 0
        }
    }
    
    func changePosition()
    {
        if(self.halfBlur.frame.origin.y == 0)
        {
            self.halfBlur.frame.origin.y = self.imageView.frame.size.height/2
        }
        else
        {
            self.halfBlur.frame.origin.y = 0
        }
    }
    

    func sparkWarning()
    {
        self.removePreVisualizacaoSpark()
        let alert = UIAlertController(title: "Warning!", message: "Spark filter when used for a long time can be harmful for your health. Avoid stay looking for the image for a long and continuos time!", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func cancel()
    {
        
        let nav = self.presentingViewController as! AppNavigationController
        let controller = nav.viewControllers.last
        
        if controller!.isKindOfClass(Chat_ViewController)
        {
            self.dismissViewControllerAnimated(true) { () -> Void in
                
                let lifespan = SelectedMidia_ViewController(image: self.image, contact: self.contact)
                
                controller?.presentViewController(lifespan, animated: true, completion: { () -> Void in
                    
                })
                
            }
        }
        else if controller!.isKindOfClass(SentMidiaGallery_ViewController)
        {
            self.dismissViewControllerAnimated(true) { () -> Void in
                
                let lifespan = SelectedMidia_ViewController(image: self.image, contact: self.contact)
                
                controller?.presentViewController(lifespan, animated: true, completion: { () -> Void in
                    
                })
                
            }

        }

    }
    
    func done()
    {
        let nav = self.presentingViewController as! AppNavigationController
        let controller = nav.viewControllers.last
        
        if controller!.isKindOfClass(Chat_ViewController)
        {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                (controller as! Chat_ViewController).sendImage(self.image, lifetime: self.lifeTime, filter: self.selectedFilter)
                
            })
        }
        else if controller!.isKindOfClass(SentMidiaGallery_ViewController)
        {
            let chat = nav.viewControllers[1] as! Chat_ViewController
            
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                controller!.navigationController?.popViewControllerAnimated(true)
                
                chat.sendImage(self.image, lifetime: self.lifeTime, filter: self.selectedFilter)
            })
        }

    }
    
}




