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
    
    var printscreens = [PrintscreenNotification]()
    
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
        self.tableView.registerClass(CellPrintscreen_TableViewCell.self, forCellReuseIdentifier: "CellPrints")
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.tableView)
 
    }

    
    //** CONTROLLER PROPERTIES **//
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadNotifications", name: requestNotification.requestsLoaded.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadNotifications", name: NotificationController.center.printScreenReceived.name, object: nil)
        
        self.navigationController?.navigationBar.hidden = true
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.requests = DAOFriendRequests.sharedInstance.getRequests()
        self.printscreens = DAOPrints.sharedInstance.getPrintscreenNotficiations()
        self.tableView.reloadData()

    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: requestNotification.requestsLoaded.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationController.center.printScreenReceived.name, object: nil)
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
            return self.printscreens.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
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
            
            return cell

        }
        else //if(indexPath.section == 1)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CellPrints") as! CellPrintscreen_TableViewCell
            
            
            cell.selectionStyle = .None
            cell.backgroundColor = oficialSemiGray
            
            let printer = self.printscreens[indexPath.row].printer
            let cont = printer.characters.count
            var myMutableString = NSMutableAttributedString(string: "\(printer) tirou um screenshot de uma imagem sua")
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location:0,length:cont))
            
            cell.title.attributedText = myMutableString
            
            let date = self.printscreens[indexPath.row].printDate
            
            let horas = NSDateFormatter()
            horas.dateFormat = "HH:mm"
            horas.timeZone = NSTimeZone.localTimeZone()
            
            let meses = NSDateFormatter()
            meses.dateFormat = "MMMM"
            meses.timeZone = NSTimeZone.localTimeZone()
            
            let anos = NSDateFormatter()
            anos.dateFormat = "y"
            anos.timeZone = NSTimeZone.localTimeZone()
            
            let hora = horas.stringFromDate(date)
            
            let mes = meses.stringFromDate(date)
            
            let ano = anos.stringFromDate(date)
            
            cell.details.text = "O print foi feito às \(hora) em \(mes) de \(ano)"
            
            let image = DAOSentMidia.sharedInstance.sentMidiaImageForKey(self.printscreens[indexPath.row].imageKey)
            if(image == nil)
            {
                cell.photo.image = UIImage(named: "robber.png")
            }
            else
            {
                cell.photo.image = image
            }
            
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //aqui que contece a treta 
        indexPath.section == 0
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if(indexPath.section == 0)
        {
            return 70
        }
        else
        {
            return 100
        }
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
        return 3
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footer = UIView(frame: CGRectMake(0, 0, screenWidth, 3))
        footer.backgroundColor = oficialDarkGray
        
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
