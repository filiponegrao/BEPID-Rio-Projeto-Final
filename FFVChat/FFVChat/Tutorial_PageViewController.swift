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
    
    var tutoFirst : TutoFirst_ViewController!
    
    var tutoSecond : TutoSecond_ViewController!
    
    var tutoThird : TutoThird_ViewController!
    
    var tutoFourth : TutoFourth_ViewController!
    
    var tutoFifth : Login_ViewController!
    
    var pageControl : UIPageControl!
    
    var background : UIImageView!


    init(size: CGSize)
    {
        let pageSize = size
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.frame.size = pageSize
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()

        self.tutoFirst = TutoFirst_ViewController()
        self.tutoFirst.view.frame.size = self.view.bounds.size
        self.tutoSecond = TutoSecond_ViewController()
        self.tutoSecond.view.frame.size = self.view.bounds.size
        self.tutoThird = TutoThird_ViewController()
        self.tutoFourth = TutoFourth_ViewController()
        self.tutoFifth = Login_ViewController()
        
        
        self.pageControl = UIPageControl.appearance()
        self.pageControl.pageIndicatorTintColor = oficialLightGray
        self.pageControl.currentPageIndicatorTintColor = oficialGreen
        self.pageControl.backgroundColor = UIColor.clearColor()
        self.pageControl.alpha = 0.8
//        self.pageControl.hidesForSinglePage = true
        
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.pageViewController.setViewControllers([self.tutoFirst], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.pageViewController.view.backgroundColor = UIColor.clearColor()
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(self.pageViewController.view)

        let pageViewRect = self.view.bounds
        self.pageViewController!.view.frame = pageViewRect
        self.pageViewController!.didMoveToParentViewController(self)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        print("passando before")
        
        if(viewController.isKindOfClass(TutoFirst_ViewController))
        {
            return nil
        }
        else if(viewController.isKindOfClass(TutoSecond_ViewController))
        {
            return viewControllerAtIndex(0)
        }
        
        else if(viewController.isKindOfClass(TutoThird_ViewController))
        {
            return viewControllerAtIndex(1)
        }
        else if(viewController.isKindOfClass(TutoFourth_ViewController))
        {
            return viewControllerAtIndex(2)
        }
        else if(viewController.isKindOfClass(Login_ViewController))
        {
            return viewControllerAtIndex(3)
        }
        
        return nil
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        print("passando after")
        
        if(viewController.isKindOfClass(TutoFirst_ViewController))
        {
            return viewControllerAtIndex(1)
        }
        else if(viewController.isKindOfClass(TutoSecond_ViewController))
        {
            return viewControllerAtIndex(2)
        }
            
        else if(viewController.isKindOfClass(TutoThird_ViewController))
        {
            return viewControllerAtIndex(3)
        }
        else if(viewController.isKindOfClass(TutoFourth_ViewController))
        {
            return viewControllerAtIndex(4)
        }
        else if(viewController.isKindOfClass(Login_ViewController))
        {
            return nil
        }
        
        return nil
    }

    func viewControllerAtIndex(index: Int) -> UIViewController?
    {
        if(index == 0)
        {
            return self.tutoFirst
        }
        else if(index == 1)
        {
            return self.tutoSecond
        }
        else if(index == 2)
        {
            return tutoThird
        }
        else if(index == 3)
        {
            return tutoFourth
        }
        else //if(index == 4)
        {
            return tutoFifth
        }
    }

    func indexOfViewController(viewController: UIViewController) -> Int
    {
        
        if(viewController.isKindOfClass(TutoFirst_ViewController))
        {
            return 0
        }
        else if(viewController.isKindOfClass(TutoSecond_ViewController))
        {
            return 1
        }
            
        else if(viewController.isKindOfClass(TutoThird_ViewController))
        {
            return 2
        }
        else if(viewController.isKindOfClass(TutoFourth_ViewController))
        {
            return 3
        }
        else //(viewController.isKindOfClass(Login_ViewController))
        {
            return 4
        }
        
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 5
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}
