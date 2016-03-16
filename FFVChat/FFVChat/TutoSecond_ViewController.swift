//
//  TutoSecond_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 07/03/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class TutoSecond_ViewController: TutoModel
{
    var index = 1
    
    var image : UIImageView!
    
    var pageSize : CGSize!
    
    init(size: CGSize)
    {
        self.pageSize = size
        
        super.init(nibName: nil, bundle: nil)
        
        self.tag = 1
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
//        self.view.frame = CGRectMake(0, 0, self.pageSize.width, self.pageSize.height)
        
        self.image = UIImageView(frame: CGRectMake(0, 0, self.pageSize.width, self.pageSize.height))
        self.image.image = UIImage(named: "ImgTutorial10")
        self.image.contentMode = .ScaleAspectFit
        self.view.addSubview(self.image)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
