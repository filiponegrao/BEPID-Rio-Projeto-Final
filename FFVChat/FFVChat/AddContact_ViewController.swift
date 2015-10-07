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
        
        self.view.backgroundColor = lightGray
        self.navigationController?.navigationBar.hidden = false
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "doneSearch"))
        
        self.backButton = UIButton(frame: CGRectMake(0, 10, 80, 80))
        self.backButton.setImage(UIImage(named: "quitButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "quitSearch", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.backButton)
        
        self.searchBar = UISearchBar(frame: CGRectMake(80, 30, screenWidth - 80, 40))
        self.searchBar.delegate = self
        self.searchBar.autocapitalizationType = .None
        self.searchBar.autocorrectionType = .No
        self.searchBar.barTintColor = lightGray
        self.searchBar.tintColor = lightBlue
        self.searchBar.isFirstResponder()
        self.view.addSubview(self.searchBar)
        
        self.tableView = UITableView(frame: CGRectMake(0, 90, screenWidth, screenHeight))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "CellAdd_TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.tableView)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //** SEARCH BAR FUNCTONS ***//
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.characters.count > 1)
        {
            DAOContacts.getUsersWithString(searchText) { (contacts) -> Void in
                
                self.results = contacts
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
        if(self.searchBar.text?.characters.count > 1)
        {
            DAOContacts.getUsersWithString(self.searchBar.text!) { (contacts) -> Void in
                
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
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellAdd_TableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.username.text = self.results[indexPath.row].username
        
        DAOContacts.getPhotoFromUsername(self.results[indexPath.row].username) { (image) -> Void in
            cell.photo.image = image
        }
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
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
        self.dismissViewControllerAnimated(true) { () -> Void in
            
            
        }
    }
    
    


}


