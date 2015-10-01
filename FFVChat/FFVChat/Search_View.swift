//
//  Search_View.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Search_View: UIView, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate
{
    var result : [String]!

    var backButton : UIButton!
    
    var tableView : UITableView!
    
    var searchBar : UISearchBar!
    
    var navBar : UIView!
    
    init()
    {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        
        self.navBar = UIView(frame: CGRectMake(0, 0, screenWidth, 60))
        self.navBar.backgroundColor = UIColor.grayColor()
        self.navBar.alpha = 0
        self.addSubview(self.navBar)
        
        self.searchBar = UISearchBar(frame: CGRectMake(screenWidth*3/4 - 20, 20, 20, 40))
        self.searchBar.delegate = self
        self.searchBar.tintColor = UIColor.clearColor()
        self.searchBar.barTintColor = UIColor.clearColor()
        self.searchBar.autocapitalizationType = UITextAutocapitalizationType.None
        self.searchBar.autocorrectionType = UITextAutocorrectionType.No
        self.navBar.addSubview(self.searchBar)
        
        self.tableView = UITableView(frame: CGRectMake(screenWidth, 60, screenWidth, screenHeight-60))
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "CellContacts_TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.addSubview(self.tableView)

        
        self.backButton = UIButton(frame: CGRectMake(0, 20, 60, 30))
        self.backButton.setTitle("Cancelar", forState: .Normal)
        self.backButton.addTarget(self, action: "removeView", forControlEvents: .TouchUpInside)
        self.backButton.alpha = 0
        self.navBar.addSubview(self.backButton)
        
        self.result = [String]()
        
    }
    
    
    func insertView()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.navBar.alpha = 1
            self.searchBar.frame = CGRectMake(70, 20, screenWidth*3/4, 40)
            self.backButton.alpha = 1
            self.tableView.frame = CGRectMake(0, 60, screenWidth, screenHeight-60)
            
            }) { (success) -> Void in
                
        }
    }
    
    
    func removeView()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.navBar.alpha = 0
            self.searchBar.frame = CGRectMake(screenWidth*3/4 - 20, 20, 20, 40)
            self.tableView.frame = CGRectMake(screenWidth, 60, screenWidth, screenHeight-60)
            self.backButton.alpha = 0
            
            }) { (success) -> Void in
                self.removeFromSuperview()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return result.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellContacts_TableViewCell
        
        cell.username.text = result[indexPath.row]
        DAOContacts.getPhotoFromUsername(cell.username.text!) { (image) -> Void in
            cell.photo.image = image
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        if(searchText.characters.count > 2)
        {
            DAOContacts.getUsersWithString(searchText) { (usernames: [String]) -> Void in
                
                self.result = usernames
                self.tableView.reloadData()
            }
        }
    }

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool
    {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
  
}
