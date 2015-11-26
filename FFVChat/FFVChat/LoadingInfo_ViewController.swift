//
//  LoadingInfo_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 05/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class LoadingInfo_ViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "nextScreen", name: UserCondition.userLogged.rawValue, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UserCondition.userLogged.rawValue, object: nil)
    }
    
    
    func nextScreen()
    {
        let contacts = AppNavigationController()
        self.presentViewController(contacts, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}
