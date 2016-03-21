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
    
    var tutoFifth : TutoFifth_ViewController!
    
    var controllers : [UIViewController]!
    
    var pageControl : UIPageControl!
    
    var background : UIImageView!
    
    weak var tutorialController : Tutorial_ViewController!
    
    var index : Int! = 0
    
    var frame : CGRect!

    init(frame: CGRect, controller: Tutorial_ViewController)
    {
        self.frame = frame
        self.tutorialController = controller
        
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
//        self.view.layer.borderWidth = 2
        self.view.frame = frame
        
        //primeiro indice do page view
        self.tutoFirst = TutoFirst_ViewController(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), controller: self)
        self.tutoFirst.view.frame.size = self.frame.size
        
        //segundo indice do page view
        self.tutoSecond = TutoSecond_ViewController(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), controller: self)
        self.tutoSecond.view.frame.size = self.frame.size
        
        //terceiro indice do page view
        self.tutoThird = TutoThird_ViewController(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        self.tutoThird.view.frame.size = self.frame.size
        
        //quarto indice do page view
        self.tutoFourth = TutoFourth_ViewController(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        
        //quinto indice do page view
        self.tutoFifth = TutoFifth_ViewController(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))

        
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        self.pageViewController.setViewControllers([self.tutoFirst], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.pageViewController.view.backgroundColor = UIColor.clearColor()
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.controllers = [self.tutoFirst, self.tutoSecond, self.tutoThird, self.tutoFourth, self.tutoFifth]
        
        self.pageControl = UIPageControl.appearance()
        self.pageControl.frame = CGRectMake(0, 0, 200, 50)
        self.pageControl.pageIndicatorTintColor = oficialLightGray
        self.pageControl.currentPageIndicatorTintColor = oficialGreen
        self.pageControl.backgroundColor = UIColor.clearColor()
        self.pageControl.alpha = 0.8
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(self.pageViewController.view)
        
        self.pageViewController!.didMoveToParentViewController(self)

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {

        
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        //função que retorna view controller anterior ao view controller atual
                
        let index = self.indexOfViewController(viewController)
        
        if(index == 0)
        {
            return nil
        }
        else
        {
            return self.viewControllerAtIndex(index-1)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        //função que retorna view controller seguinte ao view controller atual
        
//        print("Todos os controllers: \(pageViewController.viewControllers)")
        
        
        let index = self.indexOfViewController(viewController)
        
        if(index == 4)
        {
            return nil
        }
        else
        {
            return self.viewControllerAtIndex(index+1)
        }
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
        else //if(viewController.isKindOfClass(TutoFifth_ViewController))
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
        let controllers = pageViewController.viewControllers
        
        if(controllers != nil)
        {
            return self.indexOfViewController(controllers!.last!)
        }
        else
        {
            return 0
        }
    }
}


