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
    
    var tutoFirst : TutoFirst_ViewController!
    
    var tutoSecond : TutoSecond_ViewController!
    
    var privacy : Privacy_ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tutoFirst = TutoFirst_ViewController(nibName: "TutoFirst_ViewController", bundle: nil)
        self.tutoSecond = TutoSecond_ViewController(nibName: "TutoSecond_ViewController", bundle: nil)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
