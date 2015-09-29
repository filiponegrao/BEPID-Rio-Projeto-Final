//
//  AppNavigationController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 29/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit


class AppNavigationController : UINavigationController
{
    init()
    {
        super.init(nibName: "AppNavigationController", bundle: nil)
        let contacts = Contacts_ViewController(nibName: "Contacts_ViewController", bundle: nil)
        self.viewControllers = [contacts]
        self.navigationBar.hidden = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}