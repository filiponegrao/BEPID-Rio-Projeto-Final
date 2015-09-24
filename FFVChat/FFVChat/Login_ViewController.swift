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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userNotFound", name: UserCondition.userNotFound.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "incompleteRegister", name: UserCondition.incompleteRegister.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "wrongPassword", name: UserCondition.wrongPassword.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginCanceled", name: UserCondition.loginCanceled.rawValue, object: nil)
      
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)

    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func loginParse(sender: UIButton)
    {
        if(self.emailField.text != "" && self.passwordField != "")
        {
            self.loadingScreen = LoadScreen_View()
            self.view.addSubview(loadingScreen)
            DAOUser.loginParse(self.emailField.text!, password: self.passwordField.text!)
        }
        else
        {
            let alert = UIAlertView(title: "Preencha corretamente os campos", message: "", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    
    
    func userLogged()
    {
        self.loadingScreen.removeFromSuperview()
        let chat = Chat_ViewController(nibName: "Chat_ViewController", bundle: nil)
        self.presentViewController(chat, animated: true, completion: nil)
    }
    
    
    func userNotFound()
    {
        self.loadingScreen.removeFromSuperview()
        let alert = UIAlertView(title: "Usuário nao cadastrado", message: "O usuário não foi encontrado ou a senha está incorreta", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    @IBAction func register(sender: UIButton)
    {
        let register = AppRegister_ViewController(nibName: "AppRegister_ViewController", bundle: nil)
        self.presentViewController(register, animated: true, completion: nil)
    }
    
    
    @IBAction func loginFace(sender: UIButton)
    {
        self.loadingScreen = LoadScreen_View()
        self.view.addSubview(loadingScreen)
        DAOUser.loginFaceParse()
        
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
        let alert = UIAlertView(title: "Falha ao logar", message: "Por favor, tente novamente.", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    func wrongPassword()
    {
        self.loadingScreen.removeFromSuperview()
        let alert = UIAlertView(title: "Senha incorreta", message: "Por favor, tente novamente.", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
}
