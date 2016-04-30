//
//  TesteColorAlert_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 28/04/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class TesteColorAlert_ViewController: UIViewController
{

    var button : UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = oficialMediumGray
        
        self.button = UIButton(frame: CGRectMake(100, 50, 100, 50))
        self.button.setTitle("Alert", forState: .Normal)
        self.button.setTitleColor(oficialDarkGray, forState: .Normal)
        self.button.backgroundColor = oficialGreen
        self.button.addTarget(self, action: "openAlert", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.button)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openAlert()
    {
            let alert = SweetAlert().showAlert("PrintScreen", subTitle: "x9 took a screenshot of your screen. For more details go to notifications on the main menu!! ", style: AlertStyle.Warning)
    }

}
