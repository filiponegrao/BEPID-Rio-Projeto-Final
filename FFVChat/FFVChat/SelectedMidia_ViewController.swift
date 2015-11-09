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
    
    var pickerView : UIPickerView!
    
    var clockImage : UIImageView!
    
    let minutes = Array(0...9)
    let seconds = Array(0...59)
    
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
        

        self.imageView = UIImageView(frame: CGRectMake(20, self.navigationBar.frame.size.height + 10, screenWidth - 40, screenWidth - 40))
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = image
        self.imageView.backgroundColor = UIColor.blackColor()
        self.imageView.layer.cornerRadius = 4
        self.imageView.layer.borderColor = UIColor.grayColor().CGColor
        self.imageView.layer.borderWidth = 1
        self.view.addSubview(self.imageView)
        
        
        self.pickerView = UIPickerView(frame: CGRectMake(0,self.imageView.frame.origin.y + self.imageView.frame.size.height + 20, screenWidth, screenHeight - self.navigationBar.frame.size.height - self.imageView.frame.size.height - 44 - 20))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = oficialDarkGray
        self.view.addSubview(self.pickerView)
        
        
        self.sendButton = UIButton(frame: CGRectMake(0,screenHeight - 44,screenWidth,44))
        self.sendButton.backgroundColor = oficialGreen
        self.sendButton.setTitle("Send", forState: .Normal)
        self.sendButton.addTarget(self, action: "sendPhoto", forControlEvents: .TouchUpInside)
        self.sendButton.titleLabel!.tintColor = oficialDarkGray
        self.view.addSubview(self.sendButton)
    
        
        self.clockImage = UIImageView(frame: CGRectMake(0, 0, screenWidth/8, screenWidth/8))
        self.clockImage.image = UIImage(named: "clockButton")
        self.clockImage.center = CGPointMake(screenWidth/2, self.imageView.frame.origin.y + self.imageView.frame.size.height + self.clockImage.frame.size.width/2)
        self.view.addSubview(self.clockImage)

        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func sendPhoto()
    {
        let min = self.pickerView.selectedRowInComponent(0)
        let sec = self.pickerView.selectedRowInComponent(1)
        
        if(min != 0 || sec != 0)
        {
            let time = (min * 60) + sec
            
            let nav = presentingViewController as! AppNavigationController
            let controller = nav.viewControllers.last
            
            if controller!.isKindOfClass(Chat_ViewController)
            {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    (controller as! Chat_ViewController).sendImage(self.image, lifetime: time)
                    
                })
            }
        }
        else
        {
            let alert = UIAlertController(title: "Ops!", message: "It's not possible send an image for been visible for 0 minutes and 0 seconds", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                
            }))
            
            self.presentViewController(alert, animated: true, completion: { () -> Void in
                
            })
        }
    }
    
    //** Picker View **//
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
//        let row = pickerView.selectedRowInComponent(0)
        
        if component == 0 {
            return minutes.count
        }
            
        else {
            return seconds.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        
        if component == 0 {
            return String(minutes[row])
        } else {
            
            return String(seconds[row])
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let view = UIView(frame: CGRectMake(0,0,pickerView.frame.size.height, 20))
        view.backgroundColor = UIColor.clearColor()
        
        if component == 0
        {
            let number = UILabel(frame: view.frame)
            number.text = "\(self.minutes[row]) Minutes and"
            number.textColor = UIColor.whiteColor()
            view.addSubview(number)
        }
        else
        {
            let number = UILabel(frame: view.frame)
            number.text = "\(self.seconds[row]) Seconds"
            number.textColor = UIColor.whiteColor()
            view.addSubview(number)
        }
        
        return view
        
    }
    
    
    func back()
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    

}
