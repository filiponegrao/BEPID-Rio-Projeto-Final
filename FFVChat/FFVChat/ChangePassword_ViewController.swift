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
        self.doneButton.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
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
    
    func buttonClicked(sender:UIButton)
    {
        sender.selected = !sender.selected
        sender.highlighted = true
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
            let currentPassword = UITextField(frame: CGRectMake(15,0,screenWidth - 10, cell.frame.size.height))
            currentPassword.placeholder = self.section[indexPath.row]
            currentPassword.attributedPlaceholder = NSAttributedString(string: self.section[indexPath.row], attributes: [NSForegroundColorAttributeName: oficialLightGray])
            currentPassword.keyboardAppearance = UIKeyboardAppearance.Dark
            currentPassword.keyboardType = .NumberPad
            currentPassword.secureTextEntry = true
            currentPassword.tintColor = oficialGreen
            currentPassword.textColor = oficialLightGray
            
            if (currentPassword.text?.characters.count > 6)
            {
                currentPassword.resignFirstResponder()
            }
            
            cell.addSubview(currentPassword)
        }
        else if(indexPath.row == 1)
        {
            let newPassword = UITextField(frame: CGRectMake(15,0,screenWidth - 10, cell.frame.size.height))
            newPassword.placeholder = self.section[indexPath.row]
            newPassword.attributedPlaceholder = NSAttributedString(string: self.section[indexPath.row], attributes: [NSForegroundColorAttributeName: oficialLightGray])
            newPassword.keyboardAppearance = UIKeyboardAppearance.Dark
            newPassword.keyboardType = .NumberPad
            newPassword.secureTextEntry = true
            newPassword.tintColor = oficialGreen
            newPassword.textColor = oficialLightGray
            cell.addSubview(newPassword)
        }
        else if(indexPath.row == 2)
        {
            let newPasswordAgain = UITextField(frame: CGRectMake(15,0,screenWidth - 10, cell.frame.size.height))
            newPasswordAgain.placeholder = self.section[indexPath.row]
            newPasswordAgain.attributedPlaceholder = NSAttributedString(string: self.section[indexPath.row], attributes: [NSForegroundColorAttributeName: oficialLightGray])
            newPasswordAgain.keyboardAppearance = UIKeyboardAppearance.Dark
            newPasswordAgain.keyboardType = .NumberPad
            newPasswordAgain.secureTextEntry = true
            newPasswordAgain.tintColor = oficialGreen
            newPasswordAgain.textColor = oficialLightGray
            cell.addSubview(newPasswordAgain)
        }
        
        cell.contentView.addSubview(separatorLineView)
        
        return cell

    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }

    //FIM TABLEVIEW PROPERTIES
    
}
