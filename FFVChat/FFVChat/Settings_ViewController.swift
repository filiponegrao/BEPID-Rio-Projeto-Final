//
//  Settings_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit
import Foundation

class Settings_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var tableView : UITableView!
    
    let section1 = ["About us", "Privacy and Terms"]
    
    let section2 = ["Change password", "Clean Conversation"]
    
    let section3 = ["Logout"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        self.title = "Settings"
        
        let navBar = self.navigationController!.navigationBar

        self.tableView = UITableView(frame: CGRectMake(0,0, screenWidth, screenHeight))
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool)
    {
        
        self.navigationController?.navigationBar.hidden = false
        let bar : UINavigationBar! =  self.navigationController?.navigationBar
    
        bar.barTintColor = oficialDarkGray
        bar.tintColor = oficialBlue
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        bar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.title = "Search"
        bar.titleTextAttributes = [NSForegroundColorAttributeName : oficialGreen]
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //****************************************************//
    //*********** TABLE VIEW PROPERTIES ******************//
    //****************************************************//
    
    //Espaçamento em baixo
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    //Espaçamento em cima
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 20
    }
    
    //View transparente do espaçamento de baixo
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return nil
    }
    
    //View transparente do espaçamento de cima
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRectMake(0,0,screenWidth, 20))
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 45
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            return 1
        }
        else if(section == 1)
        {
            return 2
        }
        else if(section == 2)
        {
            return 2
        }
        else if(section == 3)
        {
            return 1
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        if(indexPath.row == 0 && indexPath.section == 0)
        {
            return screenWidth/2 + 20
        }
        else
        {
            return 45
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = oficialDarkGray
        cell.selectionStyle = .None
        
        if(indexPath.row == 0 && indexPath.section == 0)
        {
            let image = DAOUser.sharedInstance.getProfileImage()
            let imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth/2, screenWidth/2))
            imageView.image = image
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = imageView.frame.size.width/2
            imageView.contentMode = .ScaleAspectFill
            imageView.center = CGPointMake(cell.center.x, cell.center.y - 20)
            cell.subviews.last?.removeFromSuperview()
            cell.addSubview(imageView)
        }
        else
        {
            
            if(indexPath.section == 1)
            {
                cell.textLabel?.text = self.section1[indexPath.row]
                cell.textLabel?.textColor = UIColor.grayColor()
            }
            else if(indexPath.section == 2)
            {
                cell.textLabel?.text = self.section2[indexPath.row]
                cell.textLabel?.textColor = UIColor.grayColor()

            }
            else
            {
                cell.textLabel?.text = self.section3[indexPath.row]
                cell.textLabel?.textColor = UIColor.grayColor()

            }
        }
        
        return cell
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView)
    {
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
      
        
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
    
    //****************************************************//
    //*********** END TABLE VIEW PROPERTIES **************//
    //****************************************************//
    
    
    //Functions
    
    func changeProfilePicture()
    {
        
    }
    
    func aboutUs()
    {
        
    }
    
    func privacyAndUse()
    {
        
    }
    
    func changePassword()
    {
        
    }
    
    func cleanData()
    {
        
    }
    
    func logOut()
    {
        
    }
    
    

}
