//
//  DeleteProfile_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 04/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class DeleteProfile_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    var tableView : UITableView!
    
    var navBar : NavigationDeleteProfile_View!
    
    var section = ["Registered email", "Username", "Password"]
    
    var emailField : UITextField!
    
    var usernameField : UITextField!
    
    var passwordField : UITextField!
    
    var doneButton : MKButton!
    
    var loadingView : LoadScreen_View!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        self.navBar = NavigationDeleteProfile_View(requester: self)
        self.navBar.layer.zPosition = 5
        self.navBar.tittle.font = UIFont(name: "SukhumvitSet-Medium", size: 22)
        self.view.addSubview(self.navBar)

        self.tableView = UITableView(frame: CGRectMake(0,50, screenWidth, screenHeight/5 * 2 - 10))
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.layer.zPosition = 0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView)
        
        self.doneButton = MKButton(frame: CGRectMake(0, screenHeight - 45, screenWidth, 45))
        self.doneButton.setTitle("Done", forState: .Normal)
        self.doneButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.doneButton.backgroundColor = oficialGreen
        self.doneButton.addTarget(self, action: "deleteProfile", forControlEvents: UIControlEvents.TouchUpInside)
        self.doneButton.backgroundLayerCornerRadius = 900
        self.doneButton.rippleLocation = .Center
        self.doneButton.ripplePercent = 4
        self.doneButton.rippleLayerColor = oficialDarkGray
        self.view.addSubview(self.doneButton)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews()
    {
        self.navBar.tittle.setSizeFont(22)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    //TEXT FIELD
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if(textField == self.passwordField)
        {
            let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
            return newLength <= 6 // Bool
        }
        
        return true
    }
    
    //TABLE VIEW PROPERTIES
    
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
        cell.selectionStyle = .None
        
        
        let separatorLineView = UIView(frame: CGRectMake(0, 0, screenWidth, 4))
        separatorLineView.backgroundColor = oficialMediumGray
        
        if(indexPath.row == 0)
        {
            self.emailField = UITextField(frame: CGRectMake(15,0,screenWidth - 10, cell.frame.size.height))
            self.emailField.placeholder = self.section[indexPath.row]
            self.emailField.attributedPlaceholder = NSAttributedString(string: self.section[indexPath.row], attributes: [NSForegroundColorAttributeName: oficialLightGray])
            self.emailField.keyboardAppearance = .Dark
            self.emailField.keyboardType = .EmailAddress
            self.emailField.autocapitalizationType = .None
            self.emailField.autocorrectionType = .No
            self.emailField.tintColor = oficialGreen
            self.emailField.textColor = oficialLightGray
            self.emailField.delegate = self
            
            cell.contentView.addSubview(self.emailField)
        }
        else if(indexPath.row == 1)
        {
            self.usernameField = UITextField(frame: CGRectMake(15,0,screenWidth - 10, cell.frame.size.height))
            self.usernameField.placeholder = self.section[indexPath.row]
            self.usernameField.attributedPlaceholder = NSAttributedString(string: self.section[indexPath.row], attributes: [NSForegroundColorAttributeName: oficialLightGray])
            self.usernameField.keyboardAppearance = .Dark
            self.usernameField.keyboardType = .EmailAddress
            self.usernameField.autocapitalizationType = .None
            self.usernameField.autocorrectionType = .No
            self.usernameField.tintColor = oficialGreen
            self.usernameField.textColor = oficialLightGray
            self.usernameField.delegate = self
            
            cell.contentView.addSubview(self.usernameField)
        }
        else if(indexPath.row == 2)
        {
            self.passwordField = UITextField(frame: CGRectMake(15,0,screenWidth - 10, cell.frame.size.height))
            self.passwordField.placeholder = self.section[indexPath.row]
            self.passwordField.attributedPlaceholder = NSAttributedString(string: self.section[indexPath.row], attributes: [NSForegroundColorAttributeName: oficialLightGray])
            self.passwordField.keyboardAppearance = .Dark
            self.passwordField.keyboardType = .NumberPad
            self.passwordField.secureTextEntry = true
            self.passwordField.tintColor = oficialGreen
            self.passwordField.textColor = oficialLightGray
            self.passwordField.delegate = self
            
            cell.contentView.addSubview(self.passwordField)
        }
        
        cell.addSubview(separatorLineView)
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    //FIM TABLEVIEW PROPERTIES
    
    func deleteProfile()
    {
        let username = DAOUser.sharedInstance.getUsername()
        
        if(self.emailField.text != "" && self.usernameField.text != "" && self.passwordField.text != "")
        {
            self.loadingView = LoadScreen_View()
            self.view.addSubview(self.loadingView)
            
            if(!(DAOUser.sharedInstance.checkCorrectEmail(self.emailField.text!)))
            {
                self.loadingView?.removeFromSuperview()
                let alert = UIAlertView(title: "Oops!", message: "Your email is wrong", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            else if(self.usernameField.text != username)
            {
                self.loadingView?.removeFromSuperview()
                let alert = UIAlertView(title: "Oops!", message: "Your username is wrong", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            else if(!(DAOUser.sharedInstance.checkPassword(self.passwordField.text!)))
            {
                self.loadingView?.removeFromSuperview()
                let alert = UIAlertView(title: "Oops!", message: "Your password is wrong", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            else
            {
                self.loadingView?.removeFromSuperview()

            }
        }
        else
        {
            let alert = UIAlertView(title: "Oops!", message: "Please, fill in the fields correctly", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
            self.loadingView?.removeFromSuperview()
        }
    }
}
