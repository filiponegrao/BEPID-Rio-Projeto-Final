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
    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var registerButton: UIButton!
    
    var loadingScreen: LoadScreen_View!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLogged", name: UserCondition.userLogged.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userNotLogged", name: UserCondition.userNotFound.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goValidation", name: UserCondition.passwordMissing.rawValue, object: nil)
       
        //OLAR AMIGOS
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)

    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func login(sender: UIButton)
    {
        if(self.emailField.text != "" && self.passwordField != "")
        {
            DAOUser.loginParse(self.emailField.text!, password: self.passwordField.text!)
            self.loadingScreen = LoadScreen_View()
            self.view.addSubview(self.loadingScreen)
        }
        else
        {
            let alert = UIAlertView(title: "Preencha corretamente os campos", message: "Preencha corretamente os campos", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    func userLogged()
    {
        let chat = Chat_ViewController(nibName: "Chat_ViewController", bundle: nil)
        self.presentViewController(chat, animated: true, completion: nil)
    }
    
    
    func userNotLogged()
    {
        let alert = UIAlertView(title: "Usuario nao cadastrado", message: "O usuario nao foi encontrado ou a senha esta incorreta", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    @IBAction func register(sender: UIButton)
    {
        let register = AppRegister_ViewController(nibName: "AppRegister_ViewController", bundle: nil)
        self.presentViewController(register, animated: true, completion: nil)
    }
    @IBAction func loginFace(sender: UIButton)
    {
        DAOUser.loginFaceParse()
    }
    
    func goValidation()
    {
        let fbregister = FacebookRegister_ViewController(nibName: "FacebookRegister_ViewController", bundle: nil)
        self.presentViewController(fbregister, animated: true, completion: nil)
    }
    
    
    
    
    
    
}
