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
    
    var loadingView : LoadScreen_View!
    
    var forgotPassword : UIButton!
    
    var changePasswordAlert : UIAlertController!
    
    var newPasswordAlert : UIAlertController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        self.navBar = NavigationChangePassword_View(requester: self)
        self.navBar.layer.zPosition = 5
        self.navBar.tittle.font = UIFont(name: "Sukhumvit Set", size: 22)
        self.view.addSubview(self.navBar)
        
        self.tableView = UITableView(frame: CGRectMake(0,50, screenWidth, screenHeight/5 * 2 - 10))
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
        self.doneButton.addTarget(self, action: "changePassword", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.doneButton)
        
        
        self.forgotPassword = UIButton(frame: CGRectMake(20, self.tableView.frame.origin.y + self.tableView.frame.size.height + 10, screenWidth - 80, 50))
        self.forgotPassword.backgroundColor = UIColor.clearColor()
        self.forgotPassword.setTitle("I forgot my password", forState: .Normal)
        self.forgotPassword.setTitleColor(oficialGreen, forState: .Normal)
        self.forgotPassword.setTitleColor(oficialDarkGreen, forState: .Highlighted)
        self.forgotPassword.contentHorizontalAlignment = .Left
        self.forgotPassword.addTarget(self, action: "setForgotPassword", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.forgotPassword)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "passwordChanged", name: "passwordChanged", object: nil)
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
            self.currentPassword.delegate = self
       
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
            self.newPassword.delegate = self
            
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
            self.newPasswordAgain.delegate = self
            
            cell.addSubview(self.newPasswordAgain)
        }
        
        cell.contentView.addSubview(separatorLineView)
        
        return cell

    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }

    //FIM TABLEVIEW PROPERTIES
    
    func changePassword()
    {
        
        self.doneButton.highlighted = true
        
        if(self.currentPassword.text != "" && self.newPassword != "" && self.newPasswordAgain != "")
        {
            self.loadingView = LoadScreen_View()
            self.view.addSubview(self.loadingView)
            DAOUser.sharedInstance.checkPassword(self.currentPassword.text!) { (correct) -> Void in
                if(!correct)
                {
                    self.loadingView?.removeFromSuperview()
                    let alert = UIAlertView(title: "Ops!", message: "Your password is wrong", delegate: nil, cancelButtonTitle: "Ok")
                    alert.show()
                }
                else
                {
                    if(self.newPassword.text == self.newPasswordAgain.text)
                    {
                        DAOUser.sharedInstance.changePassword(self.newPassword.text!)
                    }
                    else
                    {
                        let alert = UIAlertView(title: "Ops!", message: "Passwords are different", delegate: nil, cancelButtonTitle: "Ok")
                        alert.show()
                        self.loadingView?.removeFromSuperview()
                    }
                }
            }
        }
        else
        {
            let alert = UIAlertView(title: "Ops!", message: "Please, fill the fields correctly", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
            self.loadingView?.removeFromSuperview()

        }
        
       
    }
    
    func passwordChanged()
    {
        self.loadingView?.removeFromSuperview()
        let alert = UIAlertController(title: "Succeful!", message: "Your password have been changed succefully!", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func setForgotPassword()
    {
        self.loadingView = LoadScreen_View()
        self.view.addSubview(self.loadingView)
        
        self.changePasswordAlert = UIAlertController(title: "Insert your email", message: "To confirm the action, insert your email", preferredStyle: .Alert)
        
        self.changePasswordAlert.addTextFieldWithConfigurationHandler { (textfield: UITextField) -> Void in
            
            textfield.placeholder = "Insert your email registered on myne"
            textfield.keyboardAppearance = .Dark
        }
        
        self.changePasswordAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction) -> Void in
            
            if(DAOUser.sharedInstance.checkCorrectEmail(self.changePasswordAlert.textFields!.first!.text!))
            {
                self.newPasswordAlert = UIAlertController(title: "New password", message: "Inserti your new password", preferredStyle: .Alert)
                
                self.newPasswordAlert.addTextFieldWithConfigurationHandler({ (textfield: UITextField) -> Void in
                    
                    textfield.placeholder = "6 numbers"
                    textfield.delegate = self
                    textfield.keyboardType = .NumberPad
                    textfield.keyboardAppearance = .Dark
                })
                
                
                self.newPasswordAlert.addAction(UIAlertAction(title: "Change", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    
                    self.loadingView = LoadScreen_View()
                    self.view.addSubview(self.loadingView)
                    DAOUser.sharedInstance.changePassword(self.newPasswordAlert.textFields!.last!.text!)
                    
                }))
                
                self.newPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
                    
                }))
                
                self.presentViewController(self.newPasswordAlert, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "Email incorrect!", message: "Your email entered is incorrect, please insert the correct!", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
                    
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }))
        
        self.changePasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
            
            
        }))
        self.loadingView.removeFromSuperview()
        self.presentViewController(self.changePasswordAlert, animated: true, completion: nil)
    }
}



