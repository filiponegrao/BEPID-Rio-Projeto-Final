//
//  AppRegister_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit


class AppRegister_ViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate
{
    var image : UIImage!
    
    var buttonView : UIImageView!
    
    var picker : UIImagePickerController? = UIImagePickerController()
    
    var popover : UIPopoverController? = nil
    
    var loadingScreen: LoadScreen_View!
    
    @IBOutlet weak var buttonphoto: UIButton!

    @IBOutlet var labelEmail: UITextField!
    
    @IBOutlet var labelUsername: UITextField!
    
    @IBOutlet var labelPassword: UITextField!
    
    @IBOutlet weak var labelConfirmPassword: UITextField!
    
    @IBOutlet var containerView: UIView!
    
    override func viewWillAppear(animated: Bool)
    {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "emailInUse", name: UserCondition.emailInUse.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAlreadyExist", name: UserCondition.userAlreadyExist.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLogged", name: UserCondition.userLogged.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginCanceled", name: UserCondition.loginCanceled.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow"), name:UIKeyboardWillShowNotification, object: nil);

    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "emailInUse", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "userAlreadyExist", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "userLogged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "loginCanceled", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.picker!.delegate = self
        
        self.labelEmail.delegate = self
        self.labelPassword.delegate = self
        self.labelConfirmPassword.delegate = self
        self.labelUsername.delegate = self

        self.buttonphoto.clipsToBounds = true
        
        self.buttonView = UIImageView(frame: CGRectMake(0, 0, self.buttonphoto.frame.width, self.buttonphoto.frame.height))
        self.buttonphoto.addSubview(self.buttonView)
        self.buttonphoto.imageView?.contentMode = UIViewContentMode.ScaleAspectFill

        
        
    }
    
    //Sobe a view e desce a view
    func keyboardWillShow() {
        self.view.frame.origin.y = -150
    }
    func keyboardWillHide() {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.frame.origin.y = 0
        }
    }
    func textFieldDidEndEditing(textField: UITextField)
    {
        self.keyboardWillHide()
    }
    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func photoButtonClicked(sender: AnyObject)
    {
        let alert: UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: {
            
            UIAlertAction in
            self.openCamera()
        })
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler: {
            UIAlertAction in
            self.openGallery()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            
            UIAlertAction in
        })
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            self.popover = UIPopoverController(contentViewController: alert)
            self.popover!.presentPopoverFromRect(self.buttonphoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            self.picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self.picker?.cameraDevice = .Front
            self.picker?.cameraCaptureMode = .Photo
            self.picker?.allowsEditing = true
            self.presentViewController(self.picker!, animated: true, completion: nil)
        }
        else
        {
            openGallery()
        }
    }
    
    
    func openGallery()
    {
        self.picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(self.picker!, animated: true, completion: nil)
        }
        else
        {
            self.popover = UIPopoverController(contentViewController: self.picker!)
            self.popover!.presentPopoverFromRect(self.buttonphoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.image = image
        self.buttonView.image = self.image
        self.buttonView.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("picker cancel")
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    @IBAction func register(sender: UIButton)
    {
        if (self.labelEmail.text != "" && self.labelUsername.text != "" && self.labelPassword.text != "" && self.labelConfirmPassword.text != "" && self.image != nil)
        {
            if (!(DAOUser.isValidEmail(self.labelEmail.text!)))
            {
                let alert = UIAlertView(title: "Ops!", message: "Por favor, digite um e-mail válido", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
                
                else if (self.verifyWhiteSpace(self.labelUsername.text!))
            {
                let alert = UIAlertView(title: "Ops!", message: "Nome de usuário não pode conter espaços em branco", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
                
            else if (self.verifySpecialCharacter(self.labelUsername.text!))
            {
                let alert = UIAlertView(title: "Ops!", message: "Nome de usuário não pode conter caracteres especiais", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
            else if ((self.verifyInvalidPassword(labelPassword.text!)) || (self.verifyInvalidPassword(labelConfirmPassword.text!)))
            {
                let alert = UIAlertView(title: "Ops!", message: "Senha deve conter exatamente 6 números", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
                
            else if (self.labelPassword.text != self.labelConfirmPassword.text)
            {
                let alert = UIAlertView(title: "Ops!", message: "Senhas estão diferentes", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }

            else
            {
                self.loadingScreen = LoadScreen_View()
                self.view.addSubview(loadingScreen)
                DAOUser.registerUser(labelUsername.text!, email: labelEmail.text!, password: labelPassword.text!, photo: self.image!)
            }
            
        }
        else
        {
            let alert = UIAlertView(title: "Ops!", message: "Por favor, preencha todos os campos corretamente", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
        
        
    }

    func emailInUse()
    {
        self.loadingScreen.removeFromSuperview()
        let alert = UIAlertView(title: "Ops!", message: "Este email já foi utilizado", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    func userAlreadyExist()
    {
        self.loadingScreen.removeFromSuperview()
        let alert = UIAlertView(title: "Ops!", message: "Já existe um usuário com este nome ", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    func userLogged()
    {
        self.loadingScreen.removeFromSuperview()
        let chat = Chat_ViewController(nibName: "Chat_ViewController", bundle: nil)
        self.presentViewController(chat, animated: true, completion: nil)
    }

    func loginCanceled()
    {
        self.loadingScreen.removeFromSuperview()
        let alert = UIAlertView(title: "Falha ao logar", message: "Por favor, tente novamente.", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func cancel(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true
            , completion: nil)
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
    
    
}
