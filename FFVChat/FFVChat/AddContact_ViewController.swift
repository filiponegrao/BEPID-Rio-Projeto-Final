//
//  AddContact_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 07/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class AddContact_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate
{
    var results : [metaContact] = [metaContact]()
    
    var backButton : UIButton!
    
    var tableView : UITableView!
    
    var searchBar : UISearchBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialDarkGray
        self.navigationController?.navigationBar.hidden = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "doneSearch"))
        
        self.backButton = UIButton(frame: CGRectMake(0, 20, 50, 50))
        self.backButton.setImage(UIImage(named: "quitButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "quitSearch", forControlEvents: .TouchUpInside)
//        self.view.addSubview(self.backButton)
        
        self.searchBar = UISearchBar(frame: CGRectMake(0, 70, screenWidth, 30))
        self.searchBar.delegate = self
        self.searchBar.autocapitalizationType = .None
        self.searchBar.autocorrectionType = .No
        self.searchBar.barTintColor = oficialDarkGray
        self.searchBar.tintColor = oficialBlue
        self.searchBar.becomeFirstResponder()
        self.searchBar.keyboardAppearance = UIKeyboardAppearance.Dark
        self.searchBar.placeholder = "Search for a username"
        self.view.addSubview(self.searchBar)
        
        self.tableView = UITableView(frame: CGRectMake(0, 100, screenWidth, screenHeight))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "CellAdd_TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell2")
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.tableView)
    
    }
    

    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBar.hidden = false
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = oficialDarkGray
        bar.tintColor = oficialBlue
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        bar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.title = "Search"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButton"), style: UIBarButtonItemStyle.Done, target: self, action: "back")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : oficialGreen]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //** SEARCH BAR FUNCTONS ***//
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.characters.count > 1)
        {
            DAOParse.getUsersWithString(searchText) { (contacts) -> Void in
                
                self.results = contacts
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
        if(self.searchBar.text?.characters.count > 1)
        {
            DAOParse.getUsersWithString(self.searchBar.text!) { (contacts) -> Void in
                
                self.results = contacts
                self.tableView.reloadData()
            }
        }
    }
    
    func doneSearch()
    {
        self.searchBar.endEditing(true)
    }
    
    //** END SEARCH BAR FUNCTIONS **//
    
    
    //** TABLE VIEW PROPRIETS *********//
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(results.count == 0)
        {
            return 1
        }
        else
        {
            return results.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if(self.results.count == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell2", forIndexPath: indexPath)
            cell.textLabel?.text = "No results."
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor.clearColor()
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellAdd_TableViewCell
            let username = self.results[indexPath.row].username
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.username.text = username
            
            DAOFriendRequests.sharedInstance.wasAlreadyRequested(username, callback: { (was) -> Void in
                if(was == true)
                {
                    cell.addButton.hidden = true
                    
                    cell.invited = UIImageView(frame: CGRectMake(cell.addButton.frame.origin.x, cell.addButton.frame.origin.y + 10, cell.addButton.frame.size.width/2, cell.addButton.frame.size.height/2))
                    cell.invited.center = CGPointMake(cell.addButton.center.x, cell.addButton.center.y/2)
                    cell.invited.image = UIImage(named: "accept")
                    cell.addSubview(cell.invited)
                    
                    cell.invitedLabel = UILabel(frame: CGRectMake(cell.invited.frame.origin.x, cell.invited.frame.origin.y + cell.invited.frame.size.height, cell.invited.frame.size.width, cell.addButton.frame.size.height/2))
                    cell.invitedLabel.text = "Invited"
                    cell.invitedLabel.textColor = oficialGreen
                    cell.invitedLabel.adjustsFontSizeToFitWidth = true
                    cell.addSubview(cell.invitedLabel)
                }
            })
            
            DAOParse.getPhotoFromUsername(self.results[indexPath.row].username) { (image) -> Void in
                cell.photo.image = image
            }
            
            cell.backgroundColor = UIColor.clearColor()
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.searchBar.endEditing(true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70
    }
        
    //** TABLE VIEW PROPRIETS END ******//
    
    
    //** CONTROLLER MANAGEMENT FUNCTIONS ****//
    func quitSearch()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    


}


