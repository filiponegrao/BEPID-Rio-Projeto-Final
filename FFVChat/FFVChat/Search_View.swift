////
////  Search_View.swift
////  FFVChat
////
////  Created by Fernanda Carvalho on 17/09/15.
////  Copyright (c) 2015 FilipoNegrao. All rights reserved.
////
//
//import UIKit
//
//class Search_View: UIView, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate
//{
//    var result : [metaContact]!
//
//    var backButton : UIButton!
//    
//    var tableView : UITableView!
//    
//    var searchBar : UISearchBar!
//    
//    var navBar : UIView!
//    
//    var contacts : Contacts_ViewController!
//    
//    init()
//    {
//        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
//        self.backgroundColor = UIColor.clearColor()
//        self.clipsToBounds = true
//        
//        self.navBar = UIView(frame: CGRectMake(0, 0, screenWidth, 60))
//        self.navBar.backgroundColor = UIColor(netHex: 0x03bbff)
//        self.navBar.alpha = 0
//        self.addSubview(self.navBar)
//        
//        self.searchBar = UISearchBar(frame: CGRectMake(screenWidth*3/4 - 20, 20, 20, 40))
//        self.searchBar.delegate = self
//        self.searchBar.tintColor = UIColor.clearColor()
//        self.searchBar.barTintColor = UIColor(netHex: 0x03bbff)
//        self.searchBar.autocapitalizationType = UITextAutocapitalizationType.None
//        self.searchBar.autocorrectionType = UITextAutocorrectionType.No
//        self.navBar.addSubview(self.searchBar)
//        
//        self.tableView = UITableView(frame: CGRectMake(screenWidth, 60, screenWidth, screenHeight-60))
//        self.tableView.backgroundColor = UIColor(netHex: 0x343539)
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.tableView.registerNib(UINib(nibName: "CellContacts_TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
//        self.addSubview(self.tableView)
//
//        
//        self.backButton = UIButton(frame: CGRectMake(0, 20, 40, 40))
////        self.backButton.setTitle("Cancelar", forState: .Normal)
//        self.backButton.setImage(UIImage(named: "icon_back"), forState: .Normal)
//        self.backButton.addTarget(self, action: "removeView", forControlEvents: .TouchUpInside)
//        self.backButton.alpha = 0
//        self.navBar.addSubview(self.backButton)
//        
//        self.result = [metaContact]()
//        
//    }
//    
//    
//    func insertView()
//    {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
//        
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            
//            self.navBar.alpha = 1
//            self.searchBar.frame = CGRectMake(70, 20, screenWidth*3/4, 40)
//            self.tableView.frame.origin.x = 0
//            self.backButton.alpha = 1
//           
//            
//            }) { (success) -> Void in
//                self.searchBar.becomeFirstResponder()
//    
//        }
//    }
//    
//    
//    func removeView()
//    {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
//        
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            
//            self.navBar.alpha = 0
//            self.searchBar.frame = CGRectMake(screenWidth*3/4 - 20, 20, 20, 40)
//            self.tableView.frame.origin.x = screenWidth
//            self.backButton.alpha = 0
//            
//            
//            }) { (success) -> Void in
//                self.removeFromSuperview()
//        }
//    }
//    
//    
//    //Sobe a view e desce a viewb
//    func keyboardWillShow(notification: NSNotification)
//    {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
//        {
//            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, screenWidth, self.tableView.frame.size.height - keyboardSize.height)
//        }
//    }
//    
//    func keyboardWillHide(notification: NSNotification)
//    {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
//        {
//            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, screenWidth, screenHeight - 60)
//        }
//    }
//
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return result.count
//    }
//    
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
//    {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellContacts_TableViewCell
//        
//        cell.id = result[indexPath.row].id
//        cell.backgroundColor = UIColor.clearColor()
//        cell.username.text = result[indexPath.row].username
//        DAOContacts.getPhotoFromUsername(result[indexPath.row].username) { (image) -> Void in
//            cell.photo.image = image
//        }
//        
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return 70
//    }
//    
//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
//    {
//        if(searchText.characters.count > 2)
//        {
//            DAOContacts.getUsersWithString(searchText) { (metaContacts: [metaContact]) -> Void in
//                
//                self.result = metaContacts
//                self.tableView.reloadData()
//            }
//        }
//    }
//
//    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool
//    {
//        return true
//    }
//    
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.searchBar.endEditing(true)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    
//  
//}
