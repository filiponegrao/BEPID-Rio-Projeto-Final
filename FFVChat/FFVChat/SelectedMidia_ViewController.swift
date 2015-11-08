//
//  SelectedMidia_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class SelectedMidia_ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{

    var navigationBar : NavigationMidia_View!
    
    var imageView : UIImageView!
    
    var image : UIImage!
    
    var sendButton : UIButton!
    
    var lifeTime : Int!
    
    var contact: Contact!
    
    var pickerView : UIPickerView
    
    init(image: UIImage, contact: Contact)
    {
        self.contact = contact
        self.image = image
        super.init(nibName: "SelectedMidia_ViewController", bundle: nil)
        
        self.lifeTime = 60
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        self.navigationBar = NavigationMidia_View(requester: self)
        self.navigationBar.contactImage.setImage(UIImage(data: self.contact.profileImage!), forState: .Normal)
        self.view.addSubview(self.navigationBar)
        

        self.imageView = UIImageView(frame: CGRectMake(10, self.navigationBar.frame.size.height + 10, screenWidth - 20, screenWidth - 20))
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = image
        self.imageView.backgroundColor = UIColor.blackColor()
        self.imageView.layer.cornerRadius = 4
//        self.imageView.layer.borderColor = UIColor.grayColor().CGColor
//        self.imageView.layer.borderWidth = 1
        self.view.addSubview(self.imageView)
        
        self.sendButton = UIButton(frame: CGRectMake(0,screenHeight - 60,screenWidth,60))
        self.sendButton.backgroundColor = oficialGreen
        self.sendButton.setTitle("Send", forState: .Normal)
        self.sendButton.addTarget(self, action: "sendPhoto", forControlEvents: .TouchUpInside)
        self.sendButton.titleLabel?.textColor = oficialDarkGray
        self.view.addSubview(self.sendButton)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func sendPhoto()
    {
        let nav = presentingViewController as! AppNavigationController
        let controller = nav.viewControllers.last
        
        if controller!.isKindOfClass(Chat_ViewController)
        {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                (controller as! Chat_ViewController).sendImage(self.image, lifetime: self.lifeTime)
                
            })
        }

    }
    
    //** Picker View **//
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
    }func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        
    }
    
    

}
