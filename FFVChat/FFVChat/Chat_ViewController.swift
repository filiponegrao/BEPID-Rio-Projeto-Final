//
//  Chat_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Chat_ViewController: UIViewController
{

    @IBOutlet weak var tableView: UITableView!
    
    var senderMessages = ["Hello", "Good to see you"]
    var receiverMessages = ["Hi", "Manda nudes!" ]
    
    var contacts : Contact!
    
    var navBar : NavigationChat_View!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navBar = NavigationChat_View(requester: self)
        self.view.addSubview(self.navBar)
        
        
        self.tableView.registerNib(UINib(nibName: "CellChat_TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        print(DAOUser.sharedInstance.getUserName())
        print(DAOUser.sharedInstance.getEmail())
        print(DAOUser.sharedInstance.getPassword())
        print(DAOUser.sharedInstance.getTrustLevel())
        print(DAOUser.sharedInstance.getProfileImage())
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let message = self.senderMessages[0]
        let currentMessage : NSString = message as NSString
        let messageSize : CGSize! = currentMessage.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14.0)])
        return messageSize.height + 48
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ((self.senderMessages.count) + (self.receiverMessages.count))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellChat_TableViewCell
        
        return cell
    }
    
    
}
