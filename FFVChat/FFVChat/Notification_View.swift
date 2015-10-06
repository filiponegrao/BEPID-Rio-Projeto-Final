////
////  Notification_View.swift
////  FFVChat
////
////  Created by Fernanda Carvalho on 17/09/15.
////  Copyright (c) 2015 FilipoNegrao. All rights reserved.
////
//
//import UIKit
//
//class Notification_View: UIView, UITableViewDataSource, UITableViewDelegate
//{
//    var tableView : UITableView!
//    
//    var senderViewController : Contacts_ViewController!
//    
//    var requests : [FriendRequest]!
//    
//    var blackView : UIView!
//    
//    init()
//    {
//        super.init(frame: CGRectMake(screenWidth - 20, 20, 1, 1))
//        self.backgroundColor = UIColor.whiteColor()
//        self.layer.cornerRadius = 10
//        self.clipsToBounds = true
//        
//        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth*0.7, screenHeight*0.7))
//        self.tableView.registerNib(UINib(nibName: "CellAdd_TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.tableView.backgroundColor = lightGray
//        self.addSubview(self.tableView)
//        
//        self.requests = DAOFriendRequests.sharedInstance.getRequests()
//        
//        self.blackView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
//        self.blackView.backgroundColor = UIColor.blackColor()
//        self.blackView.alpha = 0.5
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload", name: requestNotification.requestsLoaded.rawValue, object: nil)
//        
//        requests = DAOFriendRequests.sharedInstance.getRequests()
//        print(requests.count)
//    }
//    
//    
//    func startView()
//    {
//        self.blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "endView"))
//        self.senderViewController.view.addSubview(self.blackView)
//        self.senderViewController.view.bringSubviewToFront(self)
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.frame = CGRectMake(screenWidth - screenWidth*0.7, 20, screenWidth*0.7, screenHeight*0.7)
//            }) { (success) -> Void in
//                
//        }
//        
//    }
//    
//    func reload()
//    {
//        self.requests = DAOFriendRequests.sharedInstance.getRequests()
//        self.tableView.reloadData()
//        if(self.requests.count == 0)
//        {
//            self.senderViewController.navBar.alertOff()
//        }
//    }
//    
//    func endView()
//    {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: requestNotification.requestsLoaded.rawValue, object: nil)
//        self.blackView.removeFromSuperview()
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.frame = CGRectMake(screenWidth - 20, 20, 1, 1)
//            }) { (success) -> Void in
//            self.removeFromSuperview()
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder)
//    {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return requests.count
//    }
//    
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
//    {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellAdd_TableViewCell
//        let username = self.requests[indexPath.row].sender
//        cell.username.text = username
//        DAOContacts.getPhotoFromUsername(username) { (image) -> Void in
//            cell.photo.image = image
//        }
//        cell.backgroundColor = UIColor.clearColor()
//        cell.addButton.hidden = true
//        
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
//    {
//        DAOFriendRequests.sharedInstance.acceptRequest(requests[indexPath.row])
//        DAOFriendRequests.sharedInstance.loadRequests()
//    }
//    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return 70
//    }
//    
//
//}
