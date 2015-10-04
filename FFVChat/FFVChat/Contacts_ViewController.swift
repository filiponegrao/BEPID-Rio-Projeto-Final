//
//  Contacts_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Contacts_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var searchButton: UIButton!
    
    var contacts : [Contact] = [Contact]()
    
    var searchView : Search_View!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.addSubview(NavigationContact_View(requester: self))
        self.view.backgroundColor = UIColor(netHex: 0x343539)
        
        self.contacts = DAOContacts.getAllContacts()
        self.tableView.reloadData()
        print("\(self.contacts.count) contatos recuperados")
        //tableView
        self.tableView.registerNib(UINib(nibName: "CellContacts_TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }

    override func viewWillAppear(animated: Bool)
    {
        self.contacts = DAOContacts.getAllContacts()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func logout(sender: UIButton)
    {
        self.presentViewController(Login_ViewController(nibName: "Login_ViewController", bundle: nil), animated: true, completion: nil)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contacts.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellContacts_TableViewCell
        
        cell.username.text = self.contacts[indexPath.row].username
        cell.trustLevel.text = "Confiavel demais eim"
        cell.photo.image = self.contacts[indexPath.row].thumb
        cell.addButton.hidden = true
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }

//    func search()
//    {
//        self.searchView = Search_View()
//        self.view.addSubview(self.searchView)
//        self.searchView.insertView(self)
//    }
}
