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
    
    var navBar : NavigationNotification_View!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = oficialMediumGray
        self.navigationController?.navigationBar.hidden = true
        
        self.navBar = NavigationNotification_View(requester: self)
        self.navBar.tittle.font = UIFont(name: "Sukhumvit Set", size: 22)
        self.navBar.layer.zPosition = 5
        self.view.addSubview(self.navBar)

        
        self.tableView = UITableView(frame: CGRectMake(0, 70, screenWidth, screenHeight))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.zPosition = 0
        self.tableView.separatorStyle = .None
        self.tableView.registerClass(Notification_TableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CellPrints")
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.tableView)
 
    }

    
    //** CONTROLLER PROPERTIES **//
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadNotifications", name: requestNotification.requestsLoaded.rawValue, object: nil)
        
        self.navigationController?.navigationBar.hidden = true
//        let bar : UINavigationBar! =  self.navigationController?.navigationBar
//        
//        bar.barTintColor = oficialDarkGray
//        bar.tintColor = oficialGreen
//        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        bar.titleTextAttributes = titleDict as? [String : AnyObject]
//        self.title = "Notifications"
//        bar.titleTextAttributes = [NSForegroundColorAttributeName : oficialGreen]
        
        self.requests = DAOFriendRequests.sharedInstance.getRequests()

    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: requestNotification.requestsLoaded.rawValue, object: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLayoutSubviews()
    {
        self.navBar.tittle.font = self.navBar.tittle.font.fontWithSize(22)
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
        let cellPrints : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CellPrints", forIndexPath: indexPath)
        cellPrints.backgroundColor = oficialSemiGray
        cellPrints.selectionStyle = .Default
        
        if(indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! Notification_TableViewCell
            cell.selectionStyle = .None
            cell.backgroundColor = oficialSemiGray
            cell.notification.text = "\(self.requests[indexPath.row].sender) te adicionou."
            cell.notification.textColor = oficialLightGray
            cell.request = self.requests[indexPath.row]
            
            DAOParse.getPhotoFromUsername(self.requests[indexPath.row].sender) { (image) -> Void in
                cell.icon.image = image
            }

        }
        else if(indexPath.section == 1)
        {
            cellPrints.selectionStyle = .None
            cellPrints.backgroundColor = oficialSemiGray
            cellPrints.textLabel?.text = "A screenshot was detected"
            cellPrints.textLabel?.textColor = oficialGreen
        }
        
        return cellPrints
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //aqui que contece a treta 
        indexPath.section == 0
        
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
        return 45
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footer = UIView(frame: CGRectMake(0, 0, screenWidth, 5))
        footer.backgroundColor = oficialSemiGray
        
        return footer
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if(section == 0)
        {
            let section = UILabel(frame: CGRectMake(0, 0, screenWidth, 20))
            section.backgroundColor = oficialMediumGray
            section.text = "    Friend Requests"
            section.textColor = oficialGreen
//            section.font = UIFont(name: "Sukhumvit Set", size: 40)
            return section
        }
        else if(section == 1)
        {
            let section = UILabel(frame: CGRectMake(0, 0, screenWidth, 20))
            section.backgroundColor = oficialMediumGray
            section.text = "    Screenshots"
            section.textColor = oficialGreen
            //            section.font = UIFont(name: "Sukhumvit Set", size: 40)
            return section
        }
        
        return nil
    }
    
    //** TABLE VIEW PROPRIETS END ******//


    func reloadNotifications()
    {
        self.requests = DAOFriendRequests.sharedInstance.getRequests()
        self.tableView.reloadData()
    }
}
