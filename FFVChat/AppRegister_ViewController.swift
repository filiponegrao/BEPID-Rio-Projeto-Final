//
//  AppRegister_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class AppRegister_ViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var photo: UIImageView!

    @IBOutlet var labelEmail: UITextField!
    
    @IBOutlet var labelUsername: UITextField!
    
    @IBOutlet var labelSenha: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "next", name: UserCondition.userLogged.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAlreadyRegistered", name: UserCondition.userAlreadyExist.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "emailInUse", name: UserCondition.emailInUse.rawValue, object: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func register(sender: UIButton)
    {
        DAOUser.registerUser(labelUsername.text!, email: labelEmail.text!, password: labelSenha.text!, photo: photo.image!)
    }

    func next()
    {
        let chat = Chat_ViewController(nibName: "Chat_ViewController", bundle: nil)
        self.presentViewController(chat, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
        
    }

    func userAlreadyRegistered()
    {
        let alert = UIAlertView(title: "Ops!", message: "Ja existe um usuario com o nome de usuario desejado", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    
    func emailInUse()
    {
        let alert = UIAlertView(title: "Ops!", message: "Ja existe um usuario com o email utilizado", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
}
