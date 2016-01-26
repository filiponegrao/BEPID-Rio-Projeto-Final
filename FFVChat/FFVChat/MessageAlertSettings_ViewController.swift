//
//  MessageAlertSettings_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 26/01/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class MessageAlertSettings_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var tableView : UITableView!
    
    var section = ["Turn on/off", "Sound"]
    
    var navBar : UIView!
    
    var tittle : UILabel!
    
    var backButton : UIButton!
    
    var mySwitch : UISwitch!
    
    var switchButton : UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        //VIEW NAVBAR//
        self.navBar = UIView(frame: CGRectMake(0, 0, screenWidth, 70))
        self.navBar.backgroundColor = oficialDarkGray
        self.view.addSubview(self.navBar)
        
        //TITULO NAVBAR//
        self.tittle = UILabel(frame: CGRectMake(0, 25, screenWidth, 35))
        self.tittle.text = "Notifications"
        self.tittle.font = UIFont(name: "Sukhumvit Set", size: 22)
        self.tittle.textAlignment = .Center
        self.tittle.textColor = oficialGreen
        self.view.addSubview(self.tittle)
        
        //BOTAO BACK NAVBAR//
        self.backButton = UIButton(frame: CGRectMake(0, 20, 45, 45))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.backButton)
        
        //TABLEVIEW//
        self.tableView = UITableView(frame: CGRectMake(0, self.navBar.frame.size.height, screenWidth, screenHeight - self.navBar.frame.size.height))
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView)
        
        //SWITCH//
        self.mySwitch = UISwitch(frame:CGRectMake(screenWidth - screenWidth/5, 12, 0, 0))
//        self.mySwitch.transform = CGAffineTransformMakeScale(0.75, 0.75)
        self.mySwitch.on = true
        self.mySwitch.setOn(true, animated: true)
        self.mySwitch.addTarget(self, action: "switchValueDidChange", forControlEvents: UIControlEvents.ValueChanged)
        self.mySwitch.tintColor = oficialLightGray
        self.mySwitch.onTintColor = oficialGreen
//        self.mySwitch.thumbTintColor = UIColor.whiteColor()
        
        //BOTAO QUE CONTROLA SWITCH//
        self.switchButton = UIButton(frame:CGRectMake(screenWidth - screenWidth/5, 12, self.mySwitch.frame.size.width, self.mySwitch.frame.size.height))
        self.switchButton.addTarget(self, action: "changeSwitchValue", forControlEvents: UIControlEvents.TouchUpInside)
        self.switchButton.backgroundColor = UIColor.clearColor()


    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()

    }
    
    override func viewDidLayoutSubviews()
    {
        self.tittle.setSizeFont(22)
    }
    
    
    //TABLEVIEW PROPERTIES//
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 15
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRectMake(0,0,screenWidth, 10))
        view.backgroundColor = UIColor.clearColor()
        
        return view

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.backgroundColor = oficialSemiGray
        cell.textLabel?.textColor = oficialLightGray
        cell.selectionStyle = .None
        
        let separatorLineView = UIView(frame: CGRectMake(0, 0, screenWidth, 4))
        separatorLineView.backgroundColor = oficialMediumGray
        cell.addSubview(separatorLineView)
        
        if(indexPath.row == 0)
        {
            cell.textLabel?.text = self.section[indexPath.row]
            cell.contentView.addSubview(self.switchButton)
            cell.contentView.addSubview(self.mySwitch)
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel?.text = self.section[indexPath.row]
            let nextButton = UIButton(frame: CGRectMake(screenWidth - 45, 5, 45, 45))
            nextButton.setImage(UIImage(named: "nextButton"), forState: .Normal)
            cell.contentView.addSubview(nextButton)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    //FIM TABLEVIEW PROPERTIES//
    
    
    //SWITCH FUNC//
    
    func changeSwitchValue()
    {
        if(self.mySwitch.on == true)
        {
            self.mySwitch.setOn(false, animated: true)
        }
        else
        {
            self.mySwitch.setOn(true, animated: true)
        }

    }
    
    func switchValueDidChange()
    {
        if(self.mySwitch.on == true)
        {
            print("on")
        }
        else
        {
            print("off")
        }
    }
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    

}
