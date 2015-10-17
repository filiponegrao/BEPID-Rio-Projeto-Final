//
//  Notifications_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 07/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Notifications_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    var tableView : UITableView!
    
    var requests = [FriendRequest]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = lightGray
        self.navigationController?.navigationBar.hidden = true
        
        self.tableView = UITableView(frame: CGRectMake(0, 90, screenWidth, screenHeight))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(Notification_TableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.tableView)
 
        self.requests = DAOFriendRequests.sharedInstance.getRequests()

    }

    
    //** CONTROLLER PROPERTIES **//
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadNotifications", name: requestNotification.requestsLoaded.rawValue, object: nil)
        
        self.navigationController?.navigationBar.hidden = false
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = lightGray
        bar.tintColor = lightBlue
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        bar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.title = "Notifications"
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: requestNotification.requestsLoaded.rawValue, object: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //** END CONTROLLER PROPERTIES **//
    
    

    //** TABLE VIEW PROPRIETS *********//
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            return self.requests.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! Notification_TableViewCell
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        cell.notification.text = "\(self.requests[indexPath.row].sender) te adicionou como amigo. Clique para aceitar"
        cell.request = self.requests[indexPath.row]
        
        DAOContacts.getPhotoFromUsername(self.requests[indexPath.row].sender) { (image) -> Void in
            cell.icon.image = image
        }

        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if(section == 0)
        {
            let view = UILabel(frame: CGRectMake(0, 0, screenWidth, 20))
            view.backgroundColor = UIColor.grayColor()
            view.text = " Friend Requests"
            return view
        }
        else
        {
            return nil
        }
    }
    
    //** TABLE VIEW PROPRIETS END ******//


    func reloadNotifications()
    {
        self.requests = DAOFriendRequests.sharedInstance.getRequests()
        self.tableView.reloadData()
    }
}
