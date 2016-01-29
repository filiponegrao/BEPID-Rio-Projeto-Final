//
//  ChatSettings_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 28/01/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class ChatSettings_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var navBar : UIView!
    
    var tittle : UILabel!
    
    var backButton : UIButton!
    
    var tableView : UITableView!
    
    let section = ["Lifespan for messages", "Background", "Clean all conversations", "Clean all galleries"]
    
    
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
        self.tittle.text = "Chat"
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
        self.tableView = UITableView(frame: CGRectMake(0, self.navBar.frame.size.height - 40, screenWidth, screenHeight - self.navBar.frame.size.height + 40), style: .Grouped)
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews()
    {
        self.tittle.setSizeFont(22)
    }
    
    //TABLEVIEW PROPERTIES//
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            return screenWidth/2 - 20
        }
        else if(indexPath.section == 0 && indexPath.row == 1)
        {
            return 50
        }
        else if(indexPath.section == 0 && indexPath.row == 2)
        {
            return screenWidth/4 + 50
        }
        else if(indexPath.section == 0 && indexPath.row == 3)
        {
            return screenWidth/4 + 50
        }
        
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.backgroundColor = oficialSemiGray
        cell.textLabel?.textColor = oficialLightGray
        
        let separatorLineView = UIView(frame: CGRectMake(0, 0, screenWidth, 4))
        separatorLineView.backgroundColor = oficialMediumGray
        cell.addSubview(separatorLineView)
        cell.selectionStyle = .None
        
        
        if(indexPath.row == 0)
        {
            let tittle = UILabel(frame: CGRectMake(15, 25, screenWidth, 30))
            tittle.text = self.section[indexPath.row]
            tittle.textColor = oficialLightGray
            cell.addSubview(tittle)
            cell.backgroundColor = UIColor.clearColor()
            separatorLineView.backgroundColor = UIColor.clearColor()
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel?.text = self.section[indexPath.row]
        }
        else if(indexPath.row == 2)
        {
            let viewCell = UIView(frame: CGRectMake(0, 10, screenWidth, 50))
            viewCell.backgroundColor = oficialSemiGray
            cell.addSubview(viewCell)
            
            let tittleButton = MKButton(frame: CGRectMake(0, 0, screenWidth, 50))
            tittleButton.setTitleColor(oficialGreen, forState: .Normal)
            tittleButton.addTarget(self, action: "cleanConversations", forControlEvents: .TouchUpInside)
            tittleButton.contentHorizontalAlignment = .Left
            tittleButton.rippleLocation = .Center
            tittleButton.rippleLayerColor = oficialDarkGray
            tittleButton.ripplePercent = 200
            viewCell.addSubview(tittleButton)
            
            let tittleLabel = UILabel(frame: CGRectMake(15,10, screenWidth, 30))
            tittleLabel.text = self.section[indexPath.row]
            tittleLabel.textColor = oficialGreen
            tittleButton.addSubview(tittleLabel)
            
            let description = UITextView(frame: CGRectMake(10, 60, screenWidth - 20, screenWidth/5))
            description.text = "It clears immediately all current conversations (even if the messages' lifespan has not finished yet)."
            description.textColor = oficialLightGray
            description.textAlignment = .Left
            description.font = UIFont(name: "Helvetica", size: 13)
            description.alpha = 0.6
            description.backgroundColor = UIColor.clearColor()
            description.userInteractionEnabled = false
            cell.addSubview(description)
            
            cell.backgroundColor = UIColor.clearColor()
        }
        else if(indexPath.row == 3)
        {
            
            let viewCell = UIView(frame: CGRectMake(0, 10, screenWidth, 50))
            viewCell.backgroundColor = oficialSemiGray
            cell.addSubview(viewCell)
            
            let tittleButton = MKButton(frame: CGRectMake(0, 0, screenWidth, 50))
            tittleButton.setTitleColor(oficialGreen, forState: .Normal)
            tittleButton.addTarget(self, action: "cleanGalleries", forControlEvents: .TouchUpInside)
            tittleButton.contentHorizontalAlignment = .Left
            tittleButton.rippleLocation = .Center
            tittleButton.rippleLayerColor = oficialDarkGray
            tittleButton.ripplePercent = 200
            viewCell.addSubview(tittleButton)
            
            let tittleLabel = UILabel(frame: CGRectMake(15,10, screenWidth, 30))
            tittleLabel.text = self.section[indexPath.row]
            tittleLabel.textColor = oficialGreen
            tittleButton.addSubview(tittleLabel)
            
            let description = UITextView(frame: CGRectMake(10, 60, screenWidth - 20, screenWidth/5))
            description.text = "it clears all chat galleries by removing all medias you’ve sent for any contact."
            description.textColor = oficialLightGray
            description.textAlignment = .Left
            description.font = UIFont(name: "Helvetica", size: 13)
            description.alpha = 0.6
            description.backgroundColor = UIColor.clearColor()
            description.userInteractionEnabled = false
            cell.addSubview(description)
            
            cell.backgroundColor = UIColor.clearColor()

        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    //FIM TABLWVIEW PROPERTIES//
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func cleanConversations()
    {
        let alert = UIAlertController(title: "Are you sure?", message: "You cannot undo this action.", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (UIAlertAction) -> Void in
        }
        
        let acceptAction = UIAlertAction(title: "Ok", style: .Default) { (UIAlertAction) -> Void in
            //limpar todas as conversas//
        }
        
        alert.addAction(cancelAction)
        alert.addAction(acceptAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func cleanGalleries()
    {
        let alert = UIAlertController(title: "Are you sure?", message: "You cannot undo this action.", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (UIAlertAction) -> Void in
        }
        
        let acceptAction = UIAlertAction(title: "Ok", style: .Default) { (UIAlertAction) -> Void in
            //limpar todas as galerias//
        }
        
        alert.addAction(cancelAction)
        alert.addAction(acceptAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
