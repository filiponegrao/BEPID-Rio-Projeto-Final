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
    
    var doneButton: MKButton!
    
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
        self.view.backgroundColor = oficialDarkGray
        
        //title view
        self.titleView.textColor = oficialGreen
        self.titleView.font = UIFont(name: "Sukhumvit Set", size: 22)
        self.titleView.setSizeFont(22)
        
        //text view
        self.textView.textColor = oficialLightGray

        //all contacts button
        self.allContactsButton = UIButton(frame: CGRectMake(screenWidth/2, self.tableView.frame.origin.y
            - 60, screenWidth/2, 40))
        self.allContactsButton.setImage(UIImage(named: "checkOff"), forState: .Normal)
        self.allContactsButton.setTitle("All contacts", forState: .Normal)
        self.allContactsButton.setTitleColor(oficialGreen, forState: .Normal)
        self.allContactsButton.addTarget(self, action: "selectAllContacts", forControlEvents: .TouchUpInside)
        self.allContactsButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 20)
        self.allContactsButton.transform = CGAffineTransformMakeScale(-1.0, 1.0)
        self.allContactsButton.titleLabel!.transform = CGAffineTransformMakeScale(-1.0, 1.0)
        self.allContactsButton.imageView!.transform = CGAffineTransformMakeScale(-1.0, 1.0)
        self.view.addSubview(self.allContactsButton)
        
        //tableview
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = oficialSemiGray
        self.tableView.registerNib(UINib(nibName: "CellImportContact_TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.separatorStyle = .None

        
        self.loadingView = LoadScreen_View()
        self.view.addSubview(self.loadingView)
        
        //doneButton
        self.doneButton = MKButton(frame: CGRectMake(0, screenHeight - 50, screenWidth, 50))
        self.doneButton.backgroundColor = oficialGreen
        self.doneButton.setTitle("Done", forState: .Normal)
        self.doneButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.doneButton.addTarget(self, action: "done", forControlEvents: .TouchUpInside)
        self.doneButton.backgroundLayerCornerRadius = 900
        self.doneButton.rippleLocation = .Center
        self.doneButton.ripplePercent = 4
        self.doneButton.rippleLayerColor = oficialDarkGray
        self.view.addSubview(self.doneButton)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        //carregando info...
        DAOUser.sharedInstance.getFaceFriends { (friends) -> Void in
            
            self.metaContacts = friends
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
        cell.backgroundColor = oficialSemiGray
        
        let separatorLineView = UIView(frame: CGRectMake(10, cell.frame.size.height - 1 , screenWidth - 20, 1))
        separatorLineView.backgroundColor = oficialLightGray
        
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
        
        cell.addSubview(separatorLineView)
        
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
            self.selectedItens[id] = false
            cell.checkOff()
            self.all = false
            self.allContactsButton.setImage(UIImage(named: "checkOff"), forState: .Normal)
        }
        else
        {
            let id = self.metaContacts[indexPath.row].facebookId
            self.selectedItens[id] = true
            cell.checkOn()
        }
    }
    
    
    func done()
    {
        AppStateData.sharedInstance.importContacts()
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
//            self.allContactsButton.imageView?.contentMode = .ScaleAspectFill
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
