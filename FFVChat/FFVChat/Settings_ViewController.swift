//
//  Settings_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit
import Foundation

class Settings_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate
{
    var tableView : UITableView!
    
    let section1 = ["Change password", "Delete Profile"]
    
    let section2 = ["Chat"]
    
    let section3 = ["Notifications"]
    
    let section4 = ["About us"]
    
    var navBar : NavigationSettings_View!

    var picker = UIImagePickerController()
    
    var popover : UIPopoverController!
    
    var editPhotoButton : UIButton! // botão para mudar foto de perfil
    
    var profilePicView : UIImageView! // onde fica a foto de perfil
    
    var circleView : CircleView!
    
    var trustLevel : Int!
    
    var profileImage : UIImage!
    
    override func viewDidLoad()
    {
        self.profileImage = DAOUser.sharedInstance.getProfileImage()
        
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        self.navBar = NavigationSettings_View(requester: self)
        self.navBar.layer.zPosition = 5
        self.navBar.tittle.font = UIFont(name: "SukhumvitSet-Medium", size: 22)
        self.view.addSubview(self.navBar)
        
        self.tableView = UITableView(frame: CGRectMake(0,60, screenWidth, screenHeight - 60))
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.layer.zPosition = 0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        self.tableView.registerClass(MKTableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView)
        
        // Do any additional setup after loading the view.
        
       
    }

    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBar.hidden = true
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
    
    //****************************************************//
    //*********** TABLE VIEW PROPERTIES ******************//
    //****************************************************//
    
    //Espaçamento em baixo
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    //Espaçamento em cima
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 20
    }
    
    //View transparente do espaçamento de baixo
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return nil
    }
    
    //View transparente do espaçamento de cima
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRectMake(0,0,screenWidth, 20))
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 45
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            return 1
        }
        else if(section == 1)
        {
            return 2
        }
        else if(section == 2)
        {
            return 1
        }
        else if(section == 3)
        {
            return 1
        }
        else if(section == 4)
        {
            return 1
        }

        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        if(indexPath.row == 0 && indexPath.section == 0)
        {
            return screenWidth/2 + 20
        }
        else
        {
            return 45
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : MKTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MKTableViewCell
//        cell.rippleLocation = .Center
//        cell.backgroundLayerColor = oficialDarkGray
    
        cell.backgroundColor = oficialSemiGray
        cell.selectionStyle = .None
        
        let separatorLineView = UIView(frame: CGRectMake(0, 0, screenWidth, 4))
        separatorLineView.backgroundColor = oficialMediumGray
        
        
        if(indexPath.row == 0 && indexPath.section == 0)
        {
            let username = DAOUser.sharedInstance.getUsername()
            
            let usernameLabel : UILabel!
            let trustLabel : UILabel!

            
            // image view que mostra a foto do usuário
            self.profilePicView = UIImageView(frame: CGRectMake(0, 0, screenWidth/2.5, screenWidth/2.5)) // onde tá a foto de perfil
            self.profilePicView.image = self.profileImage
            self.profilePicView.clipsToBounds = true
            self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.width/2
            self.profilePicView.contentMode = .ScaleAspectFill
            self.profilePicView.center = CGPointMake(cell.center.x, cell.center.y - 40)
            cell.addSubview(self.profilePicView)

            
            // label que mostra nome do usuário
            usernameLabel = UILabel(frame: CGRectMake(0, 0, screenWidth, 20))
            usernameLabel.text = username
            usernameLabel.textColor = UIColor.whiteColor()
            usernameLabel.textAlignment = .Center
            usernameLabel.center = CGPointMake(cell.center.x, cell.center.y + self.profilePicView.frame.height/4 + 15)
            usernameLabel.font = UIFont(name: "SukhumvitSet-Light", size: 18)
            cell.addSubview(usernameLabel)

            
            // label que mostra trust level do usuário
            trustLabel = UILabel(frame: CGRectMake(0, 0, screenWidth, 40))
            trustLabel.textColor = UIColor.whiteColor()
            trustLabel.font = UIFont(name: "SukhumvitSet-Light", size: 25)
            trustLabel.setSizeFont(25)
            
            trustLabel.center = CGPointMake(cell.center.x, cell.center.y + self.profilePicView.frame.height/4 + usernameLabel.frame.height + 18)
            trustLabel.textAlignment = .Center
            cell.addSubview(trustLabel)
            
            self.trustLevel = DAOUser.sharedInstance.getTrustLevel()
            trustLabel.text = "\(self.trustLevel)%"
            
            
            // Create a new CircleView
            let circleWidth = screenWidth/2.5 + 4
            let circleHeight = screenWidth/2.5
            
            let circleView = CircleView(frame: CGRectMake(0, 0, circleWidth, circleHeight))
            
            circleView.center = CGPointMake(self.profilePicView.center.x, self.profilePicView.center.y)
            
            circleView.setColor(self.trustLevel)
            
            cell.addSubview(circleView)
//            cell.bringSubviewToFront(self.editPhotoButton)
            
            // Animate the drawing of the circle over the course of 1 second
            circleView.animateCircle(1.0, trustLevel: self.trustLevel)
 
            
            // botão ícone câmera por cima da foto de perfil
            self.editPhotoButton = UIButton(frame: CGRectMake(0, 0 , self.profilePicView.frame.size.width, self.profilePicView.frame.size.height))
            self.editPhotoButton.setImage(UIImage(named: "settingsCameraButton"), forState: .Normal)
            self.editPhotoButton.alpha = 1
            self.editPhotoButton.addTarget(self, action: "changeProfilePicture", forControlEvents: .TouchUpInside)
            self.editPhotoButton.center = CGPointMake(self.profilePicView.center.x , self.profilePicView.center.y)
            cell.addSubview(self.editPhotoButton)
            
        
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            


        }
            
        else if(indexPath.section == 1)
        {
            cell.rippleLocation = .Center
            cell.backgroundLayerColor = oficialDarkGray
            
            if(indexPath.row == 0)
            {
                let nextButton = UIButton(frame: CGRectMake(screenWidth - 45, 0, 45, 45))
                nextButton.setImage(UIImage(named: "nextButton"), forState: .Normal)
                cell.addSubview(nextButton)
                
                
                cell.textLabel?.text = self.section1[indexPath.row]
                cell.textLabel?.backgroundColor = UIColor.clearColor()
                cell.textLabel?.textColor = oficialLightGray
                cell.textLabel?.font = UIFont(name: "SukhumvitSet-Light", size: 18)
            }
            else if(indexPath.row == 1)
            {
                let nextButton = UIButton(frame: CGRectMake(screenWidth - 45, 0, 45, 45))
                nextButton.setImage(UIImage(named: "nextButton"), forState: .Normal)
                cell.addSubview(nextButton)

                cell.textLabel?.text = self.section1[indexPath.row]
                cell.textLabel?.backgroundColor = UIColor.clearColor()
                cell.textLabel?.textColor = oficialLightGray
                cell.textLabel?.font = UIFont(name: "SukhumvitSet-Light", size: 18)

            }
        }
        
        else if(indexPath.section == 2)
        {
            cell.rippleLocation = .Center
            cell.backgroundLayerColor = oficialDarkGray
            
            let nextButton = UIButton(frame: CGRectMake(screenWidth - 45, 0, 45, 45))
            nextButton.setImage(UIImage(named: "nextButton"), forState: .Normal)
            cell.addSubview(nextButton)
            
            
            cell.textLabel?.text = self.section2[indexPath.row]
            cell.textLabel?.backgroundColor = UIColor.clearColor()
            cell.textLabel?.textColor = oficialLightGray
            cell.textLabel?.font = UIFont(name: "SukhumvitSet-Light", size: 18)
        }
        
        else if(indexPath.section == 3)
        {
            cell.rippleLocation = .Center
            cell.backgroundLayerColor = oficialDarkGray
            
            let nextButton = UIButton(frame: CGRectMake(screenWidth - 45, 0, 45, 45))
            nextButton.setImage(UIImage(named: "nextButton"), forState: .Normal)
            cell.addSubview(nextButton)
            
            cell.textLabel?.text = self.section3[indexPath.row]
            cell.textLabel?.backgroundColor = UIColor.clearColor()
            cell.textLabel?.textColor = oficialLightGray
            cell.textLabel?.font = UIFont(name: "SukhumvitSet-Light", size: 18)
        }
        
        else if(indexPath.section == 4)
        {
            cell.rippleLocation = .Center
            cell.backgroundLayerColor = oficialDarkGray

            let nextButton = UIButton(frame: CGRectMake(screenWidth - 45, 0, 45, 45))
            nextButton.setImage(UIImage(named: "nextButton"), forState: .Normal)
            cell.addSubview(nextButton)
            
            cell.textLabel?.text = self.section4[indexPath.row]
            cell.textLabel?.backgroundColor = UIColor.clearColor()
            cell.textLabel?.textColor = oficialLightGray
            cell.textLabel?.font = UIFont(name: "SukhumvitSet-Light", size: 18)
        }
        
        cell.contentView.addSubview(separatorLineView)

        return cell
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView)
    {
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
      
        if(indexPath.section == 1 && indexPath.row == 0)
        {
            let changePassword = ChangePassword_ViewController()
            self.navigationController?.pushViewController(changePassword, animated: true)
        }
        else if(indexPath.section == 1 && indexPath.row == 1)
        {
            let deleteProfile = DeleteProfile_ViewController()
            self.navigationController?.pushViewController(deleteProfile, animated: true)
        }
        else if(indexPath.section == 2 && indexPath.row == 0)
        {
            let chatSettings = ChatSettings_ViewController()
            self.navigationController?.pushViewController(chatSettings, animated: true)
        }
        else if(indexPath.section == 3 && indexPath.row == 0)
        {
            let messageSettings = MessageAlertSettings_ViewController()
            self.navigationController?.pushViewController(messageSettings, animated: true)
        }
        
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
    
    //****************************************************//
    //*********** END TABLE VIEW PROPERTIES **************//
    //****************************************************//
    
    
    //Functions
    
    func changeProfilePicture()
    {
        let alert = UIAlertController(title: "Change profile picture", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: {
            
            UIAlertAction in
            self.openCamera()
        })
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .Default, handler: {
            
            UIAlertAction in
            self.openGallery()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            
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
            self.popover = UIPopoverController(contentViewController: self.picker)
            self.popover!.presentPopoverFromRect(self.editPhotoButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }

        
        
//        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
//        
//            
//        }))
//        alert.addAction(UIAlertAction(title: "Photo Album", style: .Default, handler: { (action: UIAlertAction) -> Void in
//            
//            
//        }))
//        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) -> Void in
//            alert.dismissViewControllerAnimated(true, completion: nil)
//        }))
//        
//        
//        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            self.picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.picker.cameraDevice = .Front
            self.picker.allowsEditing = true
            self.picker.delegate = self
            self.presentViewController(self.picker, animated: true, completion: nil)
        }
        else
        {
            openGallery()
        }
    }
    
    func openGallery()
    {
        self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.picker.delegate = self
        self.picker.allowsEditing = true
        
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone)
        {
            self.presentViewController(self.picker, animated: true, completion: nil)
        }
        else
        {
            self.popover = UIPopoverController(contentViewController: self.picker)
            self.popover?.presentPopoverFromRect(self.editPhotoButton.frame, inView: self.view, permittedArrowDirections: .Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)

        self.profilePicView.image = image
        DAOUser.sharedInstance.changeProfilePicture(image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func aboutUs()
    {
        
    }
    
    func privacyAndUse()
    {
        
    }
    
    func changePassword()
    {
        
    }
    
    func cleanData()
    {
        
    }
    
    func logOut()
    {
        
    }
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    

}
