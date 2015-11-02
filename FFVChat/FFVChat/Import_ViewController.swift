//
//  Import_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Import_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var titleView: UILabel!

    @IBOutlet var textView: UILabel!
    
    var doneButton: UIButton!
    
    var allContactsView : UIView!
    
    var allContactsButton : UIButton!
    
    @IBOutlet var tableView: UITableView!
    
    var metaContacts = [facebookContact]()
    
    var agree : Bool = false
    
    var all : Bool = false
    
    var agreeButton : UIButton!
    
    var dontAgreeButton : UIButton!
    
    var contactsAdded : Int = 0
    
    var contactsShouldAdd : Int = 0
    
    var selectedItens : [String : Bool]!
    
    var loadingView : LoadScreen_View!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //doneButton
        self.doneButton = UIButton(frame: CGRectMake(screenWidth/2 + 2, self.tableView.frame.origin.y - 65, screenWidth/2-2, 30))
        self.doneButton.backgroundColor = oficialGreen
        self.doneButton.setTitle("Done", forState: .Normal)
        self.doneButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.doneButton.addTarget(self, action: "done", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.doneButton)
        

        //all contacts button
        self.allContactsButton = UIButton(frame: CGRectMake(0, self.tableView.frame.origin.y
            - 80, screenWidth/2 - 2, 40))
        self.allContactsButton.setImage(UIImage(named: "checkOff"), forState: .Normal)
        self.allContactsButton.setTitle("Todos", forState: .Normal)
        self.allContactsButton.addTarget(self, action: "selectAllContacts", forControlEvents: .TouchUpInside)
        self.allContactsButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 20)
        self.view.addSubview(self.allContactsButton)
        
        //tableview
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(UINib(nibName: "CellImportContact_TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        self.loadingView = LoadScreen_View()
        self.view.addSubview(self.loadingView)
        
        //carregando info...
        DAOUser.sharedInstance.getFaceContacts { (metaContacts) -> Void in
            
            self.metaContacts = metaContacts
            self.selectedItens = [:]
            //iniciando o dicionario
            for meta in self.metaContacts
            {
                self.selectedItens[meta.facebookId] = true
            }
            print("\(self.selectedItens.count) contatos do face recuperados")
            self.tableView.reloadData()
            self.loadingView.removeFromSuperview()
            self.allContactsButton.setImage(UIImage(named: "checkOn"), forState: .Normal)
            self.all = true
        }
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contactAdded", name: NotificationController.center.friendRequested.name, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationController.center.friendRequested.name, object: nil)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return metaContacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellImportContact_TableViewCell
        cell.name.text = self.metaContacts[indexPath.row].facebookName
        cell.username.text = "Carregando..."
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.clearColor()
        
        if(self.selectedItens[self.metaContacts[indexPath.row].facebookId]!)
        {
            cell.checkOn()
        }
        else
        {
            cell.checkOff()
        }
        
        DAOParse.getFacebookProfilePicture(self.metaContacts[indexPath.row].facebookId) { (image: UIImage?) -> Void in
            cell.photo.image = image
        }
        
        DAOParse.getUsernameFromFacebookID(self.metaContacts[indexPath.row].facebookId) { (string: String?) -> Void in
            cell.username.text = string
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 48
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CellImportContact_TableViewCell
        if(cell.checked)
        {
            let id = self.metaContacts[indexPath.row].facebookId
            self.selectedItens[id] = true
            cell.checkOff()
            self.all = false
            self.allContactsButton.setImage(UIImage(named: "checkOff"), forState: .Normal)
        }
        else
        {
            let id = self.metaContacts[indexPath.row].facebookId
            self.selectedItens[id] = false
            cell.checkOn()
        }
    }
    
    
    func done()
    {
        self.loadingView = LoadScreen_View()
        self.view.addSubview(self.loadingView)
        
        print(self.selectedItens)
        
        for item in self.metaContacts
        {
            if(self.selectedItens[item.facebookId]!)
            {
                self.contactsShouldAdd++
                DAOFriendRequests.sharedInstance.sendRequest(facebookID: item.facebookId)
            }
        }
        if(self.contactsShouldAdd == 0)
        {
            let contacts = AppNavigationController()
            self.presentViewController(contacts, animated: true, completion: nil)
        }
    }
    
    
    func contactAdded()
    {
        self.contactsAdded++
        
        if(self.contactsShouldAdd == self.contactsAdded)
        {
            let contacts = AppNavigationController()
            self.presentViewController(contacts, animated: true, completion: nil)
        }
        
    }
    
    
    func selectAllContacts()
    {
        self.all = !self.all
        
        if(self.all)
        {
            self.allContactsButton.setImage(UIImage(named: "checkOn"), forState: .Normal)
            for item in self.metaContacts
            {
                self.selectedItens[item.facebookId] = true
                
            }
            self.tableView.reloadData()
        }
        else
        {
            self.allContactsButton.setImage(UIImage(named: "checkOff"), forState: .Normal)
            for item in self.metaContacts
            {
                self.selectedItens[item.facebookId] = false
            }
            self.tableView.reloadData()
        }
    }
    

    
}
