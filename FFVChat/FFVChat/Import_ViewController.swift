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
    
    var metaContacts = [metaContact]()
    
    var agree : Bool = false
    
    var all : Bool = false
    
    var agreeButton : UIButton!
    
    var dontAgreeButton : UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //doneButton
        self.doneButton = UIButton(frame: CGRectMake(screenWidth/2 + 2, self.tableView.frame.origin.y - 65, screenWidth/2-2, 30))
        self.doneButton.backgroundColor = UIColor(netHex: 0x888686)
        self.doneButton.setTitle("Finalizar", forState: .Normal)
        self.doneButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
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
        
        //carregando info...
        DAOUser.getFaceContacts { (metacontent) -> Void in
            
            if(metacontent != nil)
            {
                self.metaContacts = metacontent!
                self.tableView.reloadData()
            }
        }
        
        self.selectAllContacts()
        
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
        cell.name.text = self.metaContacts[indexPath.row].faceUsername
        cell.backgroundColor = UIColor.clearColor()
        cell.checkOff()
        
        DAOContacts.getProfilePicture(self.metaContacts[indexPath.row].facebookID) { (image: UIImage?) -> Void in
            cell.photo.image = image
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
        cell.setClick()
        cell.backgroundColor = UIColor.clearColor()
    }
    
    
    func done()
    {
        let chat = Chat_ViewController(nibName: "Chat_ViewController", bundle: nil)
        self.presentViewController(chat, animated: true, completion: nil)
    }
    
    
    func selectAllContacts()
    {
        self.all = !(self.all)
        if(self.all)
        {
            self.allContactsButton.setImage(UIImage(named: "checkOn"), forState: .Normal)
            for(var i = 0; i < self.metaContacts.count; i++)
            {
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: i, inSection: 0)) as! CellImportContact_TableViewCell
                cell.checkOn()
            }
        }
        else
        {
            self.allContactsButton.setImage(UIImage(named: "checkOff"), forState: .Normal)
            for(var i = 0; i < self.metaContacts.count; i++)
            {
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: i, inSection: 0)) as! CellImportContact_TableViewCell
                cell.checkOff()
            }
        }
    }
    

    
}
