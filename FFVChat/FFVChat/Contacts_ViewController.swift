//
//  Contacts_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Contacts_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate
{

    var requests = [FriendRequest]()
    
    var navBar : NavigationContact_View!
    
    var notificationView : Notification_View!
    
    var allButton : UIButton!
    
    var favouritesButton : UIButton!
    
    var addButton : UIButton!
    
    var contacts : [Contact] = [Contact]()
    
    var allView : UIView!
    
    var tableView1 : UITableView!
    
    var favouritesView : UIView!
    
    var tableView2 : UITableView!
    
    var addView : UIView!
    
    var tableView3 : UITableView!
    
    var sb : UISearchBar!
    
    var result : [metaContact] = [metaContact]()
    
    var containerView : UIView!
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //navigationBar
        self.navBar = NavigationContact_View(requester: self)
        self.view.addSubview(self.navBar)
        
        //BOTOTES
        self.allButton = UIButton(frame: CGRectMake(0, self.navBar.frame.size.height, screenWidth/3, 30))
        self.allButton.backgroundColor = UIColor.clearColor()
        self.allButton.setTitle("All", forState: .Normal)
        self.allButton.layer.borderWidth = 1
        self.allButton.layer.borderColor = lightBlue.CGColor
        self.allButton.addTarget(self, action: "clickAll", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.allButton)
        
        self.favouritesButton = UIButton(frame: CGRectMake(screenWidth/3, self.navBar.frame.size.height, screenWidth/3, 30))
        self.favouritesButton.backgroundColor = UIColor.clearColor()
        self.favouritesButton.setTitle("Favourites", forState: .Normal)
        self.favouritesButton.layer.borderWidth = 1
        self.favouritesButton.layer.borderColor = lightBlue.CGColor
        self.favouritesButton.addTarget(self, action: "clickFavourites", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.favouritesButton)
        
        self.addButton = UIButton(frame: CGRectMake(screenWidth*2/3, self.navBar.frame.size.height, screenWidth/3, 30))
        self.addButton.backgroundColor = UIColor.clearColor()
        self.addButton.layer.borderWidth = 1
        self.addButton.layer.borderColor = lightBlue.CGColor
        self.addButton.setTitle("Add", forState: .Normal)
        self.addButton.addTarget(self, action: "clickAdd", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.addButton)
        
        
        //Container view (geral)
        self.containerView = UIView(frame: CGRectMake(-screenWidth, self.navBar.frame.size.height + 30, screenWidth*3, screenHeight - self.navBar.frame.size.height - 30))
        self.containerView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.containerView)
        
        
        //All view
        self.allView = UIView(frame: CGRectMake(0, 0, screenWidth, self.containerView.frame.size.height))
        //Tableview do all view
        self.tableView1 = UITableView(frame: CGRectMake(0, 10, screenWidth, self.allView.frame.size.height-10))
        self.tableView1.registerNib(UINib(nibName: "CellAll_TableViewCell", bundle: nil), forCellReuseIdentifier: "CellAll")
        self.tableView1.delegate = self
        self.tableView1.dataSource = self
        self.tableView1.backgroundColor = UIColor.clearColor()
        self.allView.addSubview(self.tableView1)
        
        
        //AddView
        self.addView = UIView(frame: CGRectMake(screenWidth*2, 0, screenWidth, self.containerView.frame.size.height))
        //Searchbar
        self.sb = UISearchBar(frame: CGRectMake(0, 10, screenWidth, 40))
        self.sb.barTintColor = lightGray
        self.sb.tintColor = UIColor.clearColor()
        self.sb.delegate = self
        self.sb.autocapitalizationType = UITextAutocapitalizationType.None
        self.sb.tintColor = UIColor.clearColor()
        self.addView.addSubview(sb)
        //Table view do add view
        self.tableView3 = UITableView(frame: CGRectMake(0, 10 + sb.frame.size.height, screenWidth, self.addView.frame.size.height - sb.frame.size.height - 10))
        self.tableView3.registerNib(UINib(nibName: "CellAdd_TableViewCell", bundle: nil), forCellReuseIdentifier: "CellAdd")
        self.tableView3.delegate = self
        self.tableView3.dataSource = self
        self.tableView3.backgroundColor = UIColor.clearColor()
        self.addView.addSubview(self.tableView3)
        
        self.tableView2 = UITableView(frame: CGRectMake(0, 0, 10, 10))
        
        
        self.containerView.addSubview(self.allView)
        self.containerView.addSubview(self.addView)
        
        
    }

    override func viewWillAppear(animated: Bool)
    {
        self.contacts = DAOContacts.getAllContacts()
        self.tableView1.reloadData()
        DAOFriendRequests.sharedInstance.loadRequests()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadNotifications", name: requestNotification.requestsLoaded.rawValue, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: requestNotification.requestsLoaded.rawValue, object: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func reloadNotifications()
    {
        self.requests = DAOFriendRequests.sharedInstance.getRequests()
        if(self.requests.count > 0)
        {
            self.navBar.alertOn()
            print("tem convite")
        }
        else
        {
            self.navBar.alertOff()
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        DAOContacts.getUsersWithString(searchText) { (content) -> Void in
            self.result = content
            self.tableView3.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        self.sb.endEditing(true)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == self.tableView1)
        {
            return self.contacts.count
        }
        else if(tableView == self.tableView2)
        {
            return 0
        }
        else
        {
            return self.result.count
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if(tableView == self.tableView1)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CellAll", forIndexPath: indexPath) as! CellAll_TableViewCell
            cell.username.text = contacts[indexPath.row].username
            cell.photo.image = contacts[indexPath.row].thumb
            cell.backgroundColor = UIColor.clearColor()
            cell.trustLevel.text = "Confiavel"
            
            return cell
        }
        else if(tableView == self.tableView2)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CellFavourites", forIndexPath: indexPath) as UITableViewCell
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CellAdd", forIndexPath: indexPath) as! CellAdd_TableViewCell
            let username = result[indexPath.row].username
            cell.username.text = username
            cell.trustLevel.text = "Mais ou menos"
            cell.backgroundColor = UIColor.clearColor()
            DAOContacts.getPhotoFromUsername(username, callback: { (image) -> Void in
                cell.photo.image = image
            })
            
            
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if(tableView == self.tableView1)
        {
            
        }
        else if(tableView == self.tableView2)
        {
            
        }
        else
        {
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70
    }
    
    
    func clickAll()
    {
        DAOFriendRequests.sharedInstance.loadRequests()
        self.sb.endEditing(true)
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.containerView.frame.origin.x = 0
            
            }) { (success) -> Void in
             
                
        }
    }
    
    
    func clickFavourites()
    {
        DAOFriendRequests.sharedInstance.loadRequests()

        self.sb.endEditing(true)
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.containerView.frame.origin.x = -screenWidth
            
            }) { (success) -> Void in
                
                
        }
    }
    
    
    func clickAdd()
    {
        DAOFriendRequests.sharedInstance.loadRequests()

        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.containerView.frame.origin.x = -screenWidth*2
            
            }) { (success) -> Void in
                
                
        }
    }

}
