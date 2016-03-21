//
//  TutoSecond_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 07/03/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class TutoSecond_ViewController: UIViewController
{
    var index = 1
    
    var image : UIImageView!
    
    var frame : CGRect!
    
    weak var tutorialPageController : Tutorial_PageViewController!
    
    init(frame: CGRect, controller: Tutorial_PageViewController)
    {
        self.frame = frame
        self.tutorialPageController = controller
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.frame = frame

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        self.view.frame = frame

        self.image = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        self.image.image = UIImage(named: "ImgTutorial10")
        self.image.contentMode = .ScaleAspectFit
        self.view.addSubview(self.image)

    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.view.frame = self.frame
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.tutorialPageController.tutorialController.updateDescriptions(self.index)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
