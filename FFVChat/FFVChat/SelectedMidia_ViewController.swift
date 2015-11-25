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
    
    var clockLabel : UILabel!
    
    var sentDate : NSDate!
    
    var sentDateLabel : UILabel!
    
    var screenshots : Int!
    
    var screenshotsLabel : UILabel!
    
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
    
    override func viewDidLayoutSubviews() {
        self.navigationBar.title.setSizeFont(22)
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        self.navigationBar = NavigationMidia_View(requester: self)
        self.view.addSubview(self.navigationBar)
        

        self.imageView = UIImageView(frame: CGRectMake(screenWidth/8, self.navigationBar.frame.size.height + 10, screenWidth/8 * 6, screenHeight/2 - self.navigationBar.frame.size.height - 10))
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = image
        self.imageView.backgroundColor = oficialDarkGray
        self.imageView.layer.cornerRadius = 4
//        self.imageView.layer.borderColor = UIColor.grayColor().CGColor
//        self.imageView.layer.borderWidth = 1
        self.view.addSubview(self.imageView)
        
        
        self.pickerView = UIPickerView(frame: CGRectMake(0, screenHeight - (screenHeight/3 - 70) - 44, screenWidth, screenHeight/3 - 70))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = oficialDarkGray
        self.view.addSubview(self.pickerView)
        
        
        self.sendButton = UIButton(frame: CGRectMake(0,screenHeight - 44,screenWidth,44))
        self.sendButton.backgroundColor = oficialGreen
        self.sendButton.setTitle("Send", forState: .Normal)
        self.sendButton.addTarget(self, action: "sendPhoto", forControlEvents: .TouchUpInside)
        self.sendButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.sendButton.titleLabel!.tintColor = oficialDarkGray
        self.view.addSubview(self.sendButton)
    
        
        self.clockImage = UIImageView(frame: CGRectMake(0, 0, screenWidth/8, screenWidth/8))
        self.clockImage.image = UIImage(named: "clockButton")
        self.clockImage.center = CGPointMake(screenWidth/2, self.pickerView.frame.origin.y - screenWidth/8 - 10)
        self.view.addSubview(self.clockImage)
        
        self.clockLabel = UILabel(frame: CGRectMake(0, 0,screenWidth/3, screenWidth/8))
        self.clockLabel.text = "Choose time:"
        self.clockLabel.textAlignment = .Center
        self.clockLabel.setSizeFont(15)
        self.clockLabel.textColor = oficialLightGray
        self.clockLabel.center = CGPointMake(screenWidth/2, self.pickerView.frame.origin.y - 20)
        self.view.addSubview(self.clockLabel)

        self.sentDateLabel = UILabel(frame: CGRectMake(screenWidth/8, self.navigationBar.frame.size.height + 10 + self.imageView.frame.size.height + 5, screenWidth/8 * 6, 20))
        self.sentDateLabel.text = "Sent: "
        self.sentDateLabel.font = UIFont(name: "Sukhumvit Set", size: 15)
        self.sentDateLabel.setSizeFont(15)
        self.sentDateLabel.textColor = UIColor.whiteColor()
        self.sentDateLabel.textAlignment = .Left
        self.view.addSubview(self.sentDateLabel)
        
        self.screenshotsLabel = UILabel(frame: CGRectMake(screenWidth/8, self.navigationBar.frame.size.height + self.imageView.frame.size.height + self.sentDateLabel.frame.size.height + 10, screenWidth/8 * 6, 20))
        self.screenshotsLabel.text = "Screenshots: "
        self.screenshotsLabel.font = UIFont(name: "Sukhumvit Set", size: 15)
        self.screenshotsLabel.setSizeFont(15)
        self.screenshotsLabel.textColor = UIColor.whiteColor()
        self.screenshotsLabel.textAlignment = .Left
        self.view.addSubview(self.screenshotsLabel)
        
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
            else if controller!.isKindOfClass(SentMidiaGallery_ViewController)
            {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    let presenter = controller!.presentingViewController as! Chat_ViewController
                    
                    controller!.navigationController?.popViewControllerAnimated(true)
//                    presenter.sendImage(self.image, lifetime: time)
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
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
            number.text = "\(self.minutes[row]) Minutes"
            number.textAlignment = .Center
            number.textColor = UIColor.whiteColor()
            view.addSubview(number)
        }
        else
        {
            let number = UILabel(frame: view.frame)
            number.text = "\(self.seconds[row]) Seconds"
            number.textColor = UIColor.whiteColor()
            number.textAlignment = .Center
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
