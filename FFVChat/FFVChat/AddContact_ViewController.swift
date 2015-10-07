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
    var result : [metaContact] = [metaContact]()
    
    var backButton : UIButton!
    
    var tableView : UITableView!
    
    var searchBar : UISearchBar!
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = lightGray
        self.navigationController?.navigationBar.hidden = false
        
        self.backButton = UIButton(frame: CGRectMake(0, 10, 80, 80))
        self.backButton.setImage(UIImage(named: "quitButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "doneSearch", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.backButton)
        
        self.searchBar = UISearchBar(frame: CGRectMake(50, 30, screenWidth - 50, 40))
        self.view.addSubview(self.searchBar)
        
        self.tableView = UITableView(frame: CGRectMake(0, 70, screenWidth, screenHeight))
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
    
    //** TABLE VIEW PROPRIETS *********//
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return result.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellAdd_TableViewCell
        cell.username.text = self.result[indexPath.row].username
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70
    }
    
    //** TABLE VIEW PROPRIETS END ******//
    
    
    //** CONTROLLER MANAGEMENT FUNCTIONS ****//
    func doneSearch()
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
            
        }
    }


}


