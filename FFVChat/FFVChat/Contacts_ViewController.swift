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
    
    var contacts = [Contact]()
    
    var navigationBar : NavigationContact_View!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = oficialDarkGray
        
        //Nav Bar
        self.navigationBar = NavigationContact_View(requester: self)
        self.view.addSubview(self.navigationBar)
        
        //Table view
        self.tableView = UITableView(frame: CGRectMake(0, self.navigationBar.frame.size.height, screenWidth, screenHeight - self.navigationBar.frame.size.height))
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.registerNib(UINib(nibName: "CellAll_TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        self.contacts = DAOContacts.getAllContacts()
        //end.
    }
    
    //*** PROPRIEDADES DE APRESENTACAO DO CONTROOLER **//
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadContacts", name: ContactNotification.contactAdded.rawValue, object: nil)
        DAOFriendRequests.sharedInstance.friendsAccepted()
        
//        self.navigationController?.navigationBar.hidden = true
    }
    
    
    override func viewDidDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ContactNotification.contactAdded.rawValue, object: nil)
    }
    //**  FIM DAS PROPRIEDADES DE APRESENTACAO DO CONTROLLER **//
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    
    //** TABLE VIEW PROPERTIE *********//
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let clearConversation = UITableViewRowAction(style: .Normal, title: "Clear") { (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            DAOParseMessages.sharedInstance.clearConversation(self.contacts[indexPath.row].username)
        }
        clearConversation.backgroundColor = oficialGreen
        
        return [clearConversation]
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellAll_TableViewCell
        cell.username.text = self.contacts[indexPath.row].username
        cell.photo.image = self.contacts[indexPath.row].thumb
        cell.backgroundColor = UIColor.clearColor()
//        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let chat = Chat_ViewController(nibName: "Chat_ViewController", bundle: nil)
        chat.contact = self.contacts[indexPath.row]
        self.navigationController?.pushViewController(chat, animated: true)
//        DAOFriendRequests.sharedInstance.sendPushForFriendRequest(self.contacts[indexPath.row].username)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70
    }
    
    //** TABLE VIEW PROPRIETS END ******//
    
    
    //** FUNCOES DE MANEGAMENTO DE DADOS **//
    
    func reloadContacts()
    {
        self.contacts = DAOContacts.getAllContacts()
        self.tableView.reloadData()
    }
    //** FIM DAS FUNCOES DE MANEGAMENTO DE DADOS **//
    
    
    //commit a alegria
}




