//
//  NavigationGallery_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/26/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class NavigationGallery_View: UIView
{
    weak var viewController : SentMidiaGallery_ViewController!
    
    var backButton : UIButton!
    
    var deleteAll : UIButton!

    init(requester: SentMidiaGallery_ViewController)
    {
        self.viewController = requester
        super.init(frame: CGRectMake(0, 0, screenWidth, 70))
        
        self.backgroundColor = oficialDarkGray
        
        self.backButton = UIButton(frame: CGRectMake(0, 25, 44, 44))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        self.addSubview(self.backButton)
        
        self.deleteAll = UIButton(frame: CGRectMake(screenWidth/3 * 2, 25, screenWidth/3, 44))
        self.deleteAll.setTitle("Delete All", forState: .Normal)
        self.deleteAll.setTitleColor(oficialGreen, forState: .Normal)
        self.deleteAll.addTarget(self, action: "deleteAllPictures", forControlEvents: .TouchUpInside)
        self.addSubview(self.deleteAll)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        self.viewController.navigationController?.popViewControllerAnimated(true)
    }
    
    func deleteAllPictures()
    {
        
    }
}
