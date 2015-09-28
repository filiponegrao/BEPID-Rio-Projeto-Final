//
//  FacebookRegister_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 12/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class FacebookRegister_ViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var labelUsername: UITextField!
    
    @IBOutlet var labelPassword: UITextField!
    
    @IBOutlet weak var labelConfirmPassword: UITextField!
    
    var activeField: UITextField?

    override func viewWillAppear(animated: Bool)
    {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAlreadyExist", name: UserCondition.userAlreadyExist.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLogged", name: UserCondition.userLogged.rawValue, object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginCanceled", name: UserCondition.loginCanceled.rawValue, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "userAlreadyExist", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "userLogged", object: nil)
        
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "loginCanceled", object: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let image = DAOUser.getProfileImage()
        
        self.imageView.image = image
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2
        
        let name = DAOUser.getUserName()
        let trimmedString = name.removeWhitespace()
        
        let username = trimmedString.lowercaseString
        print(username)
        self.labelUsername.text = username
        
//        //pra mover a tela quando abre o teclado
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow"), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide"), name:UIKeyboardWillHideNotification, object: nil)
//        
    }
    
    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func register(sender: UIButton)
    {
//        if (self.labelUsername.text != "" && self.labelPassword.text != "" && self.labelConfirmPassword.text != "" && self.imageView != nil)
//        {
//            
//        }
//        
//        else
//        {
//            let alert = UIAlertView(title: "Ops!", message: "Por favor, preencha todos os campos corretamente", delegate: nil, cancelButtonTitle: "Ok")
//            alert.show()
//        }
        DAOUser.configUserFace(self.labelUsername.text!, password: self.labelPassword.text!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)

    }
    
    func userLogged()
    {
//        let chat = Chat_ViewController(nibName: "Chat_ViewController", bundle: nil)
//        self.presentViewController(chat, animated: true, completion: nil)
        let importcontact = Import_ViewController(nibName: "Import_ViewController", bundle: nil)
        self.presentViewController(importcontact, animated: true, completion: nil)
    }
}
