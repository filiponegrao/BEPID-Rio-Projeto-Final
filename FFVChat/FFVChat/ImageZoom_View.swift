//
//  ImageZoom_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

let diametro = screenWidth/2

let raio = diametro/2

class ImageZoom_View: UIView {
    
    var message : Message!
    
    var image : Image!
    
    var imageView : UIImageView!
    
    var blurFilter : UIVisualEffectView!
    
    var backButton : UIButton!
    
    var unblurVision : UIImageView!
    
    var sparkTimer : NSTimer!
    
    var warningTimer : NSTimer!
    
    weak var chatController : Chat_ViewController!
    
    var origin : CGRect!
    
    init(image: Image, message: Message, origin: CGRect)
    {
        self.message = message
        self.origin = origin
        self.image = image
        
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.blackColor()
        self.layer.zPosition = 10
        self.alpha = 0
        
        self.backButton = UIButton(frame: CGRectMake(0, 20, 50, 50))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "fadeOut", forControlEvents: .TouchUpInside)
        self.addSubview(self.backButton)
        
        self.imageView = UIImageView(frame: CGRectMake(0, 70, screenWidth, screenHeight - 70))
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.backgroundColor = UIColor.clearColor()
        
        
        /**
         * Controla qual interface de visualização deve ser utilizada
         * de acordo com o tipo de filtro da imagem
         */
        let filter = self.image.filter
        
        print("Imagem com filtro \(filter)")
        switch filter
        {
        case ImageFilter.None.rawValue:
            
            self.imageView.image = UIImage(data: self.image.data)!
            self.addSubview(self.imageView)
            
        case ImageFilter.Circle.rawValue:
            
            let circle = FilterView_Circle(image: self.image)
            self.addSubview(circle)
            
        case ImageFilter.Spark.rawValue:
            
            let spark = FilterView_Spark(image: self.image)
            self.addSubview(spark)
            
        case ImageFilter.Half.rawValue:
            
            let half = FilterView_Half(image: self.image)
            self.addSubview(half)
            
        case ImageFilter.Noise.rawValue:
            
            let noise = FilterView_Noise(image: self.image)
            self.addSubview(noise)
            
        default:
            print("deu merda")
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fadeIn()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.alpha = 1
            self.frame = CGRectMake(0, 0, screenWidth, screenHeight)
            
            }) { (success: Bool) -> Void in
        }
    }
    
    func fadeOut()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.alpha = 0
            
            }) { (success: Bool) -> Void in
                self.chatController.isViewing = false
                
                self.removeFromSuperview()
        }
    }
    
}
