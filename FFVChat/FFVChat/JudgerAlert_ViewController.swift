//
//  JudgerAlert_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 03/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class JudgerAlert_ViewController: UIViewController
{
    
    var imageView : UIImageView!
    
    var frase : UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialDarkGray

        
//        self.imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth/2, screenWidth/2))
//        self.imageView.image = UIImage(named: "googleDinossaur")
//        self.imageView.center = CGPointMake(screenWidth/2, screenHeight/3)
//        self.view.addSubview(self.imageView)
//        
//        
//        self.frase = UILabel(frame: CGRectMake(0,0, screenWidth, 100))
//        self.frase.text = "Ops!\nNão é permitido printscreens no Myne"
//        self.frase.numberOfLines = 2
//        self.frase.textColor = UIColor.whiteColor()
//        self.frase.center = CGPointMake(screenWidth/2, screenHeight*3/5)
//        self.frase.textAlignment = .Center
//        self.frase.font = UIFont(name: "Helvetica", size: 15)
//        self.view.addSubview(self.frase)
        
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.imageView.image = UIImage(named: "printAlert")
        self.imageView.contentMode = .ScaleAspectFit
        self.view.addSubview(self.imageView)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

}
