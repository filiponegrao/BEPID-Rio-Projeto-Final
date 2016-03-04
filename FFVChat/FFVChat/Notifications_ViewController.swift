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
        
    var midiaViewer : MidiaViewer_View!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = oficialMediumGray
        self.navigationController?.navigationBar.hidden = true
        
        self.navBar = NavigationNotification_View(requester: self)
        self.navBar.tittle.font = UIFont(name: "SukhumvitSet-Medium", size: 22)
//        self.navBar.layer.zPosition = 5
        self.view.addSubview(self.navBar)

        self.requests = DAOFriendRequests.sharedInstance.getRequests()
        self.printscreens = DAOPrints.sharedInstance.getPrintscreenNotficiations()
        
        self.tableView = UITableView(frame: CGRectMake(0, 70, screenWidth, screenHeight))
        self.tableView.delegate = self
        self.tableView.dataSource = self
//        self.tableView.layer.zPosition = 0
        self.tableView.separatorStyle = .None
        self.tableView.registerClass(Notification_TableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(CellPrintscreen_TableViewCell.self, forCellReuseIdentifier: "CellPrints")
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.tableView)
 
    }

    deinit
    {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    
    //** CONTROLLER PROPERTIES **//
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadNotifications", name: requestNotification.requestsLoaded.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadNotifications", name: NotificationController.center.printScreenReceived.name, object: nil)
        
        self.navigationController?.navigationBar.hidden = true
        
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
            
            let separatorLineView = UIView(frame: CGRectMake(0, 0, screenWidth, 1))
            separatorLineView.backgroundColor = oficialMediumGray

            
            cell.notification.text = "\(self.requests[indexPath.row].sender) te adicionou."
            cell.notification.textColor = oficialLightGray
            cell.request = self.requests[indexPath.row]
            
            DAOParse.getPhotoFromUsername(self.requests[indexPath.row].sender) { (image) -> Void in
                cell.icon.image = image
            }
            
            cell.contentView.addSubview(separatorLineView)

            return cell

        }
        else //if(indexPath.section == 1)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CellPrints") as! CellPrintscreen_TableViewCell
            
            cell.selectionStyle = .None
            cell.backgroundColor = oficialSemiGray
            
            let separatorLineView = UIView(frame: CGRectMake(0, 0, screenWidth, 1))
            separatorLineView.backgroundColor = oficialMediumGray
            
            let printer = self.printscreens[indexPath.row].printer
            let cont = printer.characters.count
            let myMutableString = NSMutableAttributedString(string: "\(printer) has taken a screenshot of your picture")
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: oficialGreen, range: NSRange(location:0,length:cont))
            
            cell.title.attributedText = myMutableString
            
            let date = self.printscreens[indexPath.row].printDate
            
            let horas = NSDateFormatter()
            horas.dateFormat = "HH:mm"
            horas.timeZone = NSTimeZone.localTimeZone()
            
            let meses = NSDateFormatter()
            meses.dateFormat = "MM"
            meses.timeZone = NSTimeZone.localTimeZone()
            
            let anos = NSDateFormatter()
            anos.dateFormat = "y"
            anos.timeZone = NSTimeZone.localTimeZone()
            
            let dias = NSDateFormatter()
            dias.dateFormat = "dd"
            dias.timeZone = NSTimeZone.localTimeZone()
            
            let hora = horas.stringFromDate(date)
            
            let mes = meses.stringFromDate(date)
            
            let ano = anos.stringFromDate(date)
            
            let dia = dias.stringFromDate(date)
//            
//            cell.details.text = "The screenshot was taken at \(hora) on \(mes)/\(ano)"
            
             cell.details.text = "The screenshot was taken at \(hora) on \(mes)/\(dia)/\(ano)"
            
            let image = DAOSentMidia.sharedInstance.sentMidiaImageForKey(self.printscreens[indexPath.row].imageKey)
            if(image == nil)
            {
                cell.photo.image = UIImage(named: "spy")
            }
            else
            {
                cell.photo.image = image
                cell.blur?.removeFromSuperview()
                cell.blur = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
                cell.blur.frame = cell.photo.bounds
                cell.photo.addSubview(cell.blur)
            }
            
            cell.contentView.addSubview(separatorLineView)
            
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //CELL PRINT
        if(indexPath.section == 1)
        {
            let image = DAOSentMidia.sharedInstance.sentMidiaImageForKey(self.printscreens[indexPath.row].imageKey)
            
            if(image != nil)
            {
                self.midiaViewer = MidiaViewer_View(image: image!)
                self.navigationController?.pushViewController(self.midiaViewer, animated: true)
            }
            else
            {
                let alert = UIAlertView(title: "Oops!", message: "This picture is no longer available", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
        }
        
        
        //QUE TRETA?
        
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
            section.font = UIFont(name: "SukhumvitSet-Light", size: 18)

            return section
        }
        else if(section == 1)
        {
            let section = UILabel(frame: CGRectMake(0, 0, screenWidth, 20))
            section.backgroundColor = oficialMediumGray
            section.text = "    Screenshots"
            section.textColor = oficialGreen
            section.font = UIFont(name: "SukhumvitSet-Light", size: 18)
            return section
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if(indexPath.section == 0)
        {
            return true
        }
        else
        {
            return false
        }
    }

    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let button = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) in
            
            let request = DAOFriendRequests.sharedInstance.requests[indexPath.item]
            let index = DAOFriendRequests.sharedInstance.requests.indexOf(request)
            DAOFriendRequests.sharedInstance.deleteRequest(request.id, callback: { (success) -> Void in
                self.requests = DAOFriendRequests.sharedInstance.requests
                self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Fade)
            })
            
        })
        
        button.backgroundColor = oficialRed
        
        return [button]
    }
    
    //** TABLE VIEW PROPRIETS END ******//


    func reloadNotifications()
    {
        self.requests = DAOFriendRequests.sharedInstance.getRequests()
        self.tableView.reloadData()
    }
}
