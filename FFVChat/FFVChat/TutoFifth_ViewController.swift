//
//  TutoFifth_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 15/03/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class TutoFifth_ViewController: UIViewController
{
    var index = 4
    
    var image : UIImageView!
    
    var pageSize : CGSize!

    init(size: CGSize)
    {
        self.pageSize = size
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        self.view.frame.size = self.pageSize
//        self.view.frame = CGRectMake(0, 0, self.pageSize.width, self.pageSize.height)
        
        self.image = UIImageView(frame: CGRectMake(0, 0, self.pageSize.width, self.pageSize.height))
        self.image.image = UIImage(named: "ImgTutorial31")
        self.image.contentMode = .ScaleAspectFit
        self.view.addSubview(self.image)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
