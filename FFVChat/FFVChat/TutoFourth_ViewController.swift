//
//  TutoFourth_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 07/03/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class TutoFourth_ViewController: UIViewController
{
    var index = 3
    var iphoneShape : UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        self.iphoneShape = UIImageView(frame: CGRectMake(screenWidth/5, screenHeight/4, screenWidth/5 * 3, screenHeight/6 * 4))
        self.iphoneShape.image = UIImage(named: "iphone")
        self.view.addSubview(self.iphoneShape)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
