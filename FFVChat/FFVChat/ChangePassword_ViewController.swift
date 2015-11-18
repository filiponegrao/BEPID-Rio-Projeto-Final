//
//  ChangePassword_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 15/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class ChangePassword_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    var tableView : UITableView!
    
    var navBar : NavigationChangePassword_View!
    
    var section = ["Current password", "New password", "Confirm new password"]
    
    var doneButton : UIButton!
    
    var currentPassword : UITextField!
    
    var newPassword : UITextField!
    
    var newPasswordAgain : UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        self.navBar = NavigationChangePassword_View(requester: self)
        self.navBar.layer.zPosition = 5
        self.navBar.tittle.font = UIFont(name: "Sukhumvit Set", size: 22)
        self.view.addSubview(self.navBar)
        
        self.tableView = UITableView(frame: CGRectMake(0,60, screenWidth, screenHeight - 80))
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.layer.zPosition = 0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView)
        
        self.doneButton = UIButton(frame: CGRectMake(0, screenHeight - 45, screenWidth, 45))
        self.doneButton.setTitle("Done", forState: .Normal)
        self.doneButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.doneButton.backgroundColor = oficialGreen
        self.doneButton.highlighted = true
//        self.doneButton.addTarget(self, action: "changePassword", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.doneButton)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews()
    {
        self.navBar.tittle.font = self.navBar.tittle.font.fontWithSize(22)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
        resignFirstResponder()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        return newLength <= 6 // Bool
    }

    
    //TABLEVIEW PROPERTIES
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRectMake(0,0,screenWidth, 30))
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = oficialSemiGray
        cell.selectionStyle = .Default
        
        let separatorLineView = UIView(frame: CGRectMake(0, 0, screenWidth, 4))
        separatorLineView.backgroundColor = oficialMediumGray
        
        if(indexPath.row == 0)
        {
            self.currentPassword = UITextField(frame: CGRectMake(15,0,screenWidth - 10, cell.frame.size.height))
            self.currentPassword.placeholder = self.section[indexPath.row]
            self.currentPassword.attributedPlaceholder = NSAttributedString(string: self.section[indexPath.row], attributes: [NSForegroundColorAttributeName: oficialLightGray])
            self.currentPassword.keyboardAppearance = UIKeyboardAppearance.Dark
            self.currentPassword.keyboardType = .NumberPad
            self.currentPassword.secureTextEntry = true
            self.currentPassword.tintColor = oficialGreen
            self.currentPassword.textColor = oficialLightGray
            
            if (self.currentPassword.text?.characters.count > 6)
            {
                self.currentPassword.resignFirstResponder()
            }
            
            cell.addSubview(self.currentPassword)
        }
        else if(indexPath.row == 1)
        {
            self.newPassword = UITextField(frame: CGRectMake(15,0,screenWidth - 10, cell.frame.size.height))
            self.newPassword.placeholder = self.section[indexPath.row]
            self.newPassword.attributedPlaceholder = NSAttributedString(string: self.section[indexPath.row], attributes: [NSForegroundColorAttributeName: oficialLightGray])
            self.newPassword.keyboardAppearance = UIKeyboardAppearance.Dark
            self.newPassword.keyboardType = .NumberPad
            self.newPassword.secureTextEntry = true
            self.newPassword.tintColor = oficialGreen
            self.newPassword.textColor = oficialLightGray
            cell.addSubview(self.newPassword)
        }
        else if(indexPath.row == 2)
        {
            self.newPasswordAgain = UITextField(frame: CGRectMake(15,0,screenWidth - 10, cell.frame.size.height))
            self.newPasswordAgain.placeholder = self.section[indexPath.row]
            self.newPasswordAgain.attributedPlaceholder = NSAttributedString(string: self.section[indexPath.row], attributes: [NSForegroundColorAttributeName: oficialLightGray])
            self.newPasswordAgain.keyboardAppearance = UIKeyboardAppearance.Dark
            self.newPasswordAgain.keyboardType = .NumberPad
            self.newPasswordAgain.secureTextEntry = true
            self.newPasswordAgain.tintColor = oficialGreen
            self.newPasswordAgain.textColor = oficialLightGray
            cell.addSubview(self.newPasswordAgain)
        }
        
        cell.contentView.addSubview(separatorLineView)
        
        return cell

    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }

    //FIM TABLEVIEW PROPERTIES
    
//    func changePassword(sender:UIButton)
//    {
//        
//        self.doneButton.highlighted = true
//        
//        if(self.currentPassword.text != "")
//        {
//            DAOUser.sharedInstance.checkPassword(self.currentPassword.text!) { (correct) -> Void in
//                if(correct == false)
//                {
//                    let alert = UIAlertView(title: "Ops!", message: "Your password is wrong", delegate: nil, cancelButtonTitle: "Ok")
//                    alert.show()
//                }
//                else
//                {
//                    if(self.newPassword.text == self.newPasswordAgain.text)
//                    {
//                        DAOUser.sharedInstance.changePassword()
//                    }
//                    else
//                    {
//                        let alert = UIAlertView(title: "Ops!", message: "Passwords are different", delegate: nil, cancelButtonTitle: "Ok")
//                        alert.show()
//                    }
//                }
//            }
//        }
//        else
//        {
//            let alert = UIAlertView(title: "Ops!", message: "Please, enter your password", delegate: nil, cancelButtonTitle: "Ok")
//            alert.show()
//        }
//        
//       
//    }
    
}