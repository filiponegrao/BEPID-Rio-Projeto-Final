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
    
    @IBOutlet var labelSenha: UITextField!
    
    @IBOutlet var containerView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "emailInUse", name: UserCondition.emailInUse.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAlreadyExist", name: UserCondition.userAlreadyExist.rawValue, object: nil)
        
       
        
        
        self.picker!.delegate = self
        
        self.labelEmail.delegate = self
        self.labelSenha.delegate = self
        self.labelUsername.delegate = self

        self.buttonphoto.clipsToBounds = true
        
        self.buttonView = UIImageView(frame: CGRectMake(0, 0, self.buttonphoto.frame.width, self.buttonphoto.frame.height))
        self.buttonphoto.addSubview(self.buttonView)
        self.buttonphoto.imageView?.contentMode = UIViewContentMode.ScaleAspectFill

        
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        print("did begin edtting")
        UIView.animateWithDuration(0.3) { () -> Void in
            
            self.containerView.frame.origin = CGPointMake(0, -150)
        }
    }
    
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        print("did endedditng")
        UIView.animateWithDuration(0.3) { () -> Void in
            self.containerView.frame.origin = CGPointMake(0, 0)
        }
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
            popover = UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(buttonphoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallery()
        }
    }
    
    
    func openGallery()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover = UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(buttonphoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.image = image
        self.buttonView.image = image
        self.buttonView.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("picker cancel")
    }
    
    
    @IBAction func register(sender: UIButton)
    {
        self.loadingScreen = LoadScreen_View()
        self.view.addSubview(loadingScreen)
        DAOUser.registerUser(labelUsername.text!, email: labelEmail.text!, password: labelSenha.text!, photo: image!)
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
        let alert = UIAlertView(title: "Ops!", message: "Já existe um usuário com este nome ", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    
    func emailInUse()
    {
        let alert = UIAlertView(title: "Ops!", message: "Este email já foi utilizado", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    @IBAction func cancel(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true
            , completion: nil)
    }
    
}
