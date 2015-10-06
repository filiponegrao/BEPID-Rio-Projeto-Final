//
//  Contacts_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 06/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Contacts_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var tableView : UITableView!
    
    var contacts : [Contact]!
    
    var navigationBar : NavigationContact_View!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = lightGray
        
        //Nav Bar
        self.navigationBar = NavigationContact_View(requester: self)
        self.view.addSubview(self.navigationBar)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    
    //** TABLE VIEW PROPRIETS *********//
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellAll_TableViewCell
        cell.username.text = self.contacts[indexPath.row].username
        cell.photo.image = self.contacts[indexPath.row].thumb
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    //** TABLE VIEW PROPRIETS END ******//
    
}
