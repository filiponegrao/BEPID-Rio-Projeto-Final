//
//  FacebookRegister_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 12/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class FacebookRegister_ViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate
{
    var loadingScreen: LoadScreen_View!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var imageView: UIImageView!

    @IBOutlet var labelUsername: MKTextField!
    
    @IBOutlet var labelPassword: MKTextField!
    
    @IBOutlet weak var labelConfirmPassword: MKTextField!
    
    var activeField: UITextField?
    
    var backButton : UIButton!

    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAlreadyExist", name: UserCondition.userAlreadyExist.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLogged", name: UserCondition.userLogged.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginCanceled", name: UserCondition.loginCanceled.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "userAlreadyExist", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "userLogged", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "loginCanceled", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = oficialDarkGray
        
        let image = DAOUser.sharedInstance.getProfileImage()
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, screenHeight/2.5, screenHeight/2.5))
        self.imageView.center = CGPointMake(screenWidth/2, 20 + screenHeight/4)
        self.imageView.image = image
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2
        self.imageView.layer.borderColor = oficialDarkGreen.CGColor
        self.imageView.layer.borderWidth = 4
        self.imageView.contentMode = .ScaleAspectFill
        self.view.addSubview(self.imageView)
        
        self.registerButton.setTitle("Register", forState: .Normal)
        self.registerButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.registerButton.backgroundColor = oficialDarkGreen
        self.registerButton.layer.cornerRadius = 7
        self.registerButton.clipsToBounds = true
        
        let name = DAOUser.sharedInstance.getUsername()
        let trimmedString = name.removeWhitespace()
        
        let username = trimmedString.lowercaseString
        print(username)
        self.labelUsername.text = username
        
        self.labelUsername.delegate = self
        self.labelPassword.delegate = self
        self.labelConfirmPassword.delegate = self
        
        self.labelUsername.autocapitalizationType = .None
        self.labelUsername.autocorrectionType = .No
        self.labelUsername.textAlignment = .Center
        self.labelUsername.layer.borderColor = UIColor.clearColor().CGColor
        self.labelUsername.floatingPlaceholderEnabled = true
        self.labelUsername.placeholder = "username"
         self.labelUsername.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        self.labelUsername.tintColor = oficialGreen
//        self.labelUsername.rippleLocation = MKRippleLocation.TapLocation
        self.labelUsername.rippleLayerColor = UIColor.clearColor()
        self.labelUsername.bottomBorderEnabled = true
        self.labelUsername.bottomBorderColor = oficialGreen
        self.labelUsername.tintColor = oficialGreen
        self.labelUsername.textColor = oficialLightGray
        
        self.labelPassword.autocapitalizationType = .None
        self.labelPassword.autocorrectionType = .No
        self.labelPassword.textAlignment = .Center
        self.labelPassword.layer.borderColor = UIColor.clearColor().CGColor
        self.labelPassword.floatingPlaceholderEnabled = true
        self.labelPassword.placeholder = "password"
        self.labelPassword.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        self.labelPassword.tintColor = oficialGreen
        self.labelPassword.rippleLayerColor = UIColor.clearColor()
//        self.labelPassword.rippleLocation = MKRippleLocation.TapLocation
        self.labelPassword.bottomBorderEnabled = true
        self.labelPassword.bottomBorderColor = oficialGreen
        self.labelPassword.tintColor = oficialGreen
        self.labelPassword.textColor = oficialLightGray
        
        self.labelConfirmPassword.autocapitalizationType = .None
        self.labelConfirmPassword.autocorrectionType = .No
        self.labelConfirmPassword.textAlignment = .Center
        self.labelConfirmPassword.layer.borderColor = UIColor.clearColor().CGColor
        self.labelConfirmPassword.floatingPlaceholderEnabled = true
        self.labelConfirmPassword.placeholder = "confirm password"
        self.labelConfirmPassword.attributedPlaceholder = NSAttributedString(string: "confirm password", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        self.labelConfirmPassword.tintColor = oficialGreen
//        self.labelConfirmPassword.rippleLocation = MKRippleLocation.TapLocation
        self.labelConfirmPassword.rippleLayerColor = UIColor.clearColor()
        self.labelConfirmPassword.bottomBorderEnabled = true
        self.labelConfirmPassword.bottomBorderColor = oficialGreen
        self.labelConfirmPassword.tintColor = oficialGreen
        self.labelConfirmPassword.textColor = oficialLightGray
        
        self.backButton = UIButton(frame: CGRectMake(5, 25, 45, 45))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.backButton)

    }
    
    
    override func viewDidAppear(animated: Bool)
     {
        let image = DAOUser.sharedInstance.getProfileImage()
        self.imageView.image = image
    }
    
    //Sobe a view e desce a view
    //Sobe a view e desce a view
    func keyboardWillShow(notification: NSNotification)
    {
        if(self.view.frame.origin.y == 0)
        {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.frame.origin.y = 0
        }
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if(textField == labelPassword || textField == labelConfirmPassword)
        {
            let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
            return newLength <= 6 // Bool
        }
        else
        {
            return true
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func userAlreadyExist()
    {
        self.loadingScreen?.removeFromSuperview()
        let alert = UIAlertView(title: "Ops!", message: "This username already exists", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    func userLogged()
    {
        self.loadingScreen?.removeFromSuperview()
        let tutorial = Tutorial_PageViewController()
        self.presentViewController(tutorial, animated: true, completion: nil)
    }
    
    func loginCanceled()
    {
        self.loadingScreen?.removeFromSuperview()
        let alert = UIAlertView(title: "Login failed", message: "Please, try again", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    func verifySpecialCharacter(username: String) -> Bool
    {
        let characterSet:NSCharacterSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789_.-")
        let searchTerm = username
        if ((searchTerm.rangeOfCharacterFromSet(characterSet.invertedSet)) != nil)
        {
            print("special characters found")
            return true
        }
        return false
    }
    
    func verifyWhiteSpace (username: String) -> Bool
    {
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        
        let range = username.rangeOfCharacterFromSet(whitespace)
        
        // range will be nil if no whitespace is found
        if (range != nil) {
            print("whitespace found")
            return true
        }
        else
        {
            print("whitespace not found")
            return false
        }
    }
    
    func verifyInvalidPassword (password: String) -> Bool
    {
        let characterSet:NSCharacterSet = NSCharacterSet(charactersInString: "0123456789")
        let searchTerm = password
        if ((searchTerm.rangeOfCharacterFromSet(characterSet.invertedSet)) != nil)
        {
            print("senha não contém só números")
            return true
        }
        else if (password.characters.count != 6)
        {
            print("senha deve conter 6 números")
            return true
        }
        return false
    }
    @IBAction func register(sender: UIButton)
    {
        if(self.labelUsername != "" && self.labelPassword.text != "" && self.labelConfirmPassword.text != "")
        {
            if(self.verifyWhiteSpace(self.labelUsername.text!))
            {
                let alert = UIAlertView(title: "Oops!", message: "A username can't have white spaces", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
                
            else if (self.verifySpecialCharacter(self.labelUsername.text!))
            {
                let alert = UIAlertView(title: "Oops!", message: "A username can't have special characters", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
                
            else if (self.labelUsername.text?.characters.count < 4)
            {
                let alert = UIAlertView(title: "Oops!", message: "A username must have, at least, 4 characters", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
                
            else if ((self.verifyInvalidPassword(labelPassword.text!)) || (self.verifyInvalidPassword(labelConfirmPassword.text!)))
            {
                let alert = UIAlertView(title: "Oops!", message: "Your password must have, exactly, 6 numbers", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
                
            else if (self.labelPassword.text != self.labelConfirmPassword.text)
            {
                let alert = UIAlertView(title: "Oops!", message: "Passwords don't match!", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
                
            else
            {
                self.loadingScreen = LoadScreen_View()
                self.view.addSubview(loadingScreen)
                DAOUser.sharedInstance.configUserFace(self.labelUsername.text!, password: self.labelPassword.text!)
            }
            
        }
            
        else
        {
            let alert = UIAlertView(title: "Oops!", message: "Please, fill in the fields correctly", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
    }

    func back()
    {
          self.dismissViewControllerAnimated(true, completion: nil)
    }
   
}