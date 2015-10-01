//
//  Chat_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Chat_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var tableView: UITableView!
    
    var senderMessages = ["Hello", "Good to see you"]
    var receiverMessages = ["Hi", "Manda nudes!" ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(UINib(nibName: "CellChat_TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        print(DAOUser.getUserName())
        print(DAOUser.getEmail())
        print(DAOUser.getPassword())
        print(DAOUser.getTrustLevel())
        print(DAOUser.getProfileImage())
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((self.senderMessages.count) + (self.receiverMessages.count))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellChat_TableViewCell
        
        return cell
    }
    
    @IBAction func logOut(sender: UIButton)
    {
        DAOUser.logOut()
        let login = Login_ViewController(nibName: "Login_ViewController", bundle: nil)
        self.presentViewController(login, animated: true, completion: nil)
    }
}
