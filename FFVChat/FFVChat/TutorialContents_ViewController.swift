//
//  TutorialContents_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 17/03/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class TutorialContents_ViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{

    private var frame : CGRect!
    
    private var controllers : [UIViewController]
    
    private var index : Int = 0
    
    private var count : Int!
    
    init(frame: CGRect, controllers: [UIViewController])
    {
        self.frame = frame
        self.controllers = controllers
        self.count = self.controllers.count
        
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: .Horizontal, options: nil)
        
        self.view.frame = frame
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setViewControllers([self.controllers[self.index]], direction: UIPageViewControllerNavigationDirection.Forward, animated: true) { (success: Bool) -> Void in
            
            print("Controller trocado com sucesso!")
        }
        
        self.view.frame = frame

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**************************************/
    /************* DELEGATES  *************/
    /**************************************/
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if(self.index < self.count)
        {
            return self.controllers[self.index+1]
        }
        else
        {
            return nil
        }
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if(self.index > 0)
        {
            return self.controllers[self.index-1]
        }
        else
        {
            return nil
        }
    }

}






