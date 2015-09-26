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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //doneButton
        self.doneButton = UIButton(frame: CGRectMake(screenWidth/2 + 2, self.tableView.frame.origin.y - 80, screenWidth/2-2, 40))
        self.doneButton.backgroundColor = UIColor(netHex: 0x888686)
        self.doneButton.setTitle("Finalizar", forState: .Normal)
        self.doneButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.doneButton.addTarget(self, action: "done", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.doneButton)
        
        //allcontacts view
        self.allContactsView = UIView(frame: CGRectMake(0, self.tableView.frame.origin.y
             - 80, screenWidth/2 - 2, 40))
        self.allContactsView.backgroundColor = UIColor(netHex: 0x888686)
        self.view.addSubview(self.allContactsView)
        
        let text = UILabel(frame: CGRectMake(40, 10, self.allContactsView.frame.size.width - 40, 20))
        text.text = "Todos"
        self.allContactsView.addSubview(text)
        
        //all contacts button
        self.allContactsButton = UIButton(frame: CGRectMake(10, 10, 20, 20))
        self.allContactsButton.setImage(UIImage(named: "checkOn"), forState: .Normal)
        self.allContactsButton.addTarget(self, action: "selectAllContacts", forControlEvents: .TouchUpInside)
        self.allContactsView.addSubview(self.allContactsButton)
        
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
        
    }
    
}
