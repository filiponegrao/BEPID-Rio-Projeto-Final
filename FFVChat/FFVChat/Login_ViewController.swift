//
//  Login_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 12/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse

class Login_ViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet var loginButton: UIButton!
    
    var emailField: MKTextField!
    
    var passwordField: MKTextField!
    
    @IBOutlet var registerButton: UIButton!
    
    @IBOutlet weak var facebookConnect: UIButton!
    
    var loadingScreen: LoadScreen_View!
    
    var logo : UIImageView!
    
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLogged", name: UserCondition.userLogged.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userNotFound", name: UserCondition.userNotFound.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "incompleteRegister", name: UserCondition.incompleteRegister.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "wrongPassword", name: UserCondition.wrongPassword.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginCanceled", name: UserCondition.loginCanceled.rawValue, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "userLogged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "userNotFound", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "incompleteRegister", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "wrongPassword", object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "loginCanceled", object: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialDarkGray
        
        let background = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        background.image = UIImage(named: "ContactBackground")
        background.alpha = 0.04
        background.contentMode = .ScaleAspectFill
        self.view.addSubview(background)
        
        self.logo = UIImageView(frame: CGRectMake(0,0, screenWidth/2, screenWidth/4))
        self.logo.center = CGPointMake(screenWidth/2, screenHeight/5)
        self.logo.image = UIImage(named: "logo")
        self.view.addSubview(self.logo)
        
        self.emailField = MKTextField(frame: CGRectMake(0, 0, screenWidth*0.7, 40))
        self.emailField.center = CGPointMake(screenWidth/2, screenHeight/3 + screenHeight/12)
        self.emailField.autocapitalizationType = .None
        self.emailField.autocorrectionType = .No
        self.emailField.textAlignment = .Center
        self.emailField.layer.borderColor = UIColor.clearColor().CGColor
        self.emailField.floatingPlaceholderEnabled = true
        self.emailField.placeholder = "username"
        self.emailField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        self.emailField.tintColor = oficialGreen
        self.emailField.rippleLayerColor = UIColor.clearColor()
//        self.emailField.rippleLocation = MKRippleLocation.TapLocation
        self.emailField.bottomBorderEnabled = true
        self.emailField.bottomBorderColor = oficialGreen
        self.emailField.tintColor = oficialGreen
        self.emailField.textColor = oficialLightGray
        self.emailField.keyboardType = UIKeyboardType.EmailAddress
        self.emailField.keyboardAppearance = UIKeyboardAppearance.Dark
        self.view.addSubview(self.emailField)
        
        self.passwordField = MKTextField(frame: CGRectMake(0, 0, screenWidth*0.7, 40))
        self.passwordField.center = CGPointMake(screenWidth/2, self.emailField.center.y + 50)
        self.passwordField.autocapitalizationType = .None
        self.passwordField.autocorrectionType = .No
        self.passwordField.textAlignment = .Center
        self.passwordField.layer.borderColor = UIColor.clearColor().CGColor
        self.passwordField.floatingPlaceholderEnabled = true
        self.passwordField.placeholder = "password"
        self.passwordField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        self.passwordField.tintColor = oficialGreen
//        self.passwordField.rippleLocation = MKRippleLocation.TapLocation
        self.passwordField.rippleLayerColor = UIColor.clearColor()
        self.passwordField.bottomBorderEnabled = true
        self.passwordField.bottomBorderColor = oficialGreen
        self.passwordField.tintColor = oficialGreen
        self.passwordField.textColor = oficialLightGray
        self.passwordField.keyboardType = UIKeyboardType.NumberPad
        self.passwordField.keyboardAppearance = UIKeyboardAppearance.Dark
        self.passwordField.secureTextEntry = true
        self.passwordField.delegate = self
        self.view.addSubview(self.passwordField)
        
        self.loginButton = UIButton(frame: CGRectMake(0,0,screenWidth/2.5, screenWidth/10))
        self.loginButton.addTarget(self, action: "loginParse", forControlEvents: .TouchUpInside)
        self.loginButton.backgroundColor = oficialDarkGreen
        self.loginButton.center = CGPointMake(screenWidth/2, self.passwordField.frame.origin.y + self.passwordField.frame.size.height + screenHeight/18)
        self.loginButton.setTitle("Login", forState: .Normal)
        self.loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.loginButton.titleLabel?.font = UIFont(name: "Helvetica", size: 12)
        self.loginButton.titleLabel?.setSizeFont(15)
        self.loginButton.layer.cornerRadius = 7
        self.loginButton.clipsToBounds = true
        self.view.addSubview(self.loginButton)
        
        self.registerButton.setTitleColor(oficialGreen, forState: .Normal)
        
        self.view.sendSubviewToBack(background)
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        return newLength <= 6 // Bool
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }

    func loginParse()
    {
        if(self.emailField.text != "" && self.passwordField != "")
        {
            self.loadingScreen = LoadScreen_View()
            self.view.addSubview(self.loadingScreen)
            DAOUser.sharedInstance.loginParse(self.emailField.text!, password: self.passwordField.text!)
        }
        else
        {
            let alert = UIAlertView(title: "Please, fill out all fields correctly", message: "", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
    }


    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
//    {
//        if(textField == self.passwordField)
//        {
//            let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
//            return newLength <= 6 // Bool
//        }
//        return true
//    }
    
    @IBAction func register(sender: UIButton)
    {
//        self.checkMaxLength(passwordField, maxLength: 6)
        if (self.passwordField.text?.characters.count > 6)
        {
            self.passwordField.resignFirstResponder()
        }
        
        let register = AppRegister_ViewController(nibName: "AppRegister_ViewController", bundle: nil)
        self.presentViewController(register, animated: true, completion: nil)
        }
    
    
    @IBAction func loginFace(sender: UIButton)
    {
        self.loadingScreen = LoadScreen_View()
        self.view.addSubview(self.loadingScreen)
        DAOUser.sharedInstance.loginFaceParse()
    }
    
    func userLogged()
    {
        self.loadingScreen?.removeFromSuperview()
        let privacy = Privacy_ViewController(nibName: "Privacy_ViewController", bundle: nil)
        self.presentViewController(privacy, animated: true, completion: nil)
    }
    
    
    
    func userNotFound()
    {
        self.loadingScreen.removeFromSuperview()
        let alert = UIAlertView(title: "User not registered", message: "User not found or incorrect password", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    func incompleteRegister()
    {
        self.loadingScreen.removeFromSuperview()
        let fbregister = FacebookRegister_ViewController(nibName: "FacebookRegister_ViewController", bundle: nil)
        self.presentViewController(fbregister, animated: true, completion: nil)
    }
    
    func loginCanceled()
    {
        self.loadingScreen.removeFromSuperview()
        let alert = UIAlertView(title: "Login failed", message: "Please, try again", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    func wrongPassword()
    {
        self.loadingScreen.removeFromSuperview()
        let alert = UIAlertView(title: "Incorrect password", message: "Please, try again", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
}
