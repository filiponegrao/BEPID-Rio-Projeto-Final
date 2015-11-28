//
//  Tutorial_PageViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 27/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Tutorial_PageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    var pageViewController : UIPageViewController!
    
    var pageIndex = 0
    
    weak var tutoFirst : TutoFirst_ViewController!
    
    weak var tutoSecond : TutoSecond_ViewController!
    
    var pageControl : UIPageControl!

    
//    var privacy : Privacy_ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tutoFirst = TutoFirst_ViewController(nibName: "TutoFirst_ViewController", bundle: nil)
        self.tutoSecond = TutoSecond_ViewController(nibName: "TutoSecond_ViewController", bundle: nil)
//        self.privacy = Privacy_ViewController(nibName: "Privacy_ViewController", bundle: nil)
        
        self.pageControl = UIPageControl.appearance()
        self.pageControl.pageIndicatorTintColor = oficialLightGray
        self.pageControl.currentPageIndicatorTintColor = oficialGreen
        self.pageControl.backgroundColor = UIColor.clearColor()
//        self.pageControl.hidesForSinglePage = true
        
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.pageViewController.setViewControllers([self.tutoFirst], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        self.pageViewController.view.backgroundColor = oficialDarkGray
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(self.pageViewController.view)

        let pageViewRect = self.view.bounds
        self.pageViewController!.view.frame = pageViewRect
        self.pageViewController!.didMoveToParentViewController(self)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let nome = viewController.nibName
        
        if(nome == "TutoFirst_ViewController")
        {
            return nil
        }
        
        else if(nome == "TutoSecond_ViewController")
        {
            return viewControllerAtIndex(0)
        }
        
//        else if(nome == "Privacy_ViewController")
//        {
//            return viewControllerAtIndex(1)
//        }
        
        return nil
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let nome = viewController.nibName
        
        if(nome == "TutoFirst_ViewController")
        {
            return viewControllerAtIndex(1)
        }
            
        else if(nome == "TutoSecond_ViewController")
        {
            return nil
        }
            
//        else if(nome == "Privacy_ViewController")
//        {
//            return nil
//        }
  
        return nil
    }

    func viewControllerAtIndex(index: Int) -> UIViewController?
    {
        if(index == 0)
        {
            return self.tutoFirst
        }
        else //if(index == 1)
        {
            return self.tutoSecond
        }
    }

    func indexOfViewController(viewController: UIViewController) -> Int
    {
        let nome = viewController.nibName
        
        if(nome == "TutoFirst_ViewController")
        {
            return 0
        }
        else //(nome == "TutoSecond_ViewController")
        {
            return 1
        }
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 2
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}
