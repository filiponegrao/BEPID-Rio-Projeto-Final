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
    
    let section1 = ["Change password", "Delete Profile", "Clean all media gallery"]
    
    let section2 = ["About us"]
    
    var navBar : NavigationSettings_View!

    var picker : UIImagePickerController? = UIImagePickerController()
    
    var popover : UIPopoverController? = nil
    
    var editPhotoButton : UIButton! // botão para mudar foto de perfil
    
    var image : UIImage!
    
    var profilePicView : UIImageView! // onde fica a foto de perfil
    
    var circleView : CircleView!
    
    var trustLevel : Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        self.navBar = NavigationSettings_View(requester: self)
        self.navBar.layer.zPosition = 5
        self.view.addSubview(self.navBar)
        
        self.tableView = UITableView(frame: CGRectMake(0,60, screenWidth, screenHeight - 60))
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.layer.zPosition = 0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView)
        
        
        self.circleView = CircleView(frame: CGRect(x: 0, y: 0, width: screenWidth/2.3, height: screenWidth/2.3)) //circle do trust level
        
        // Do any additional setup after loading the view.
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.barTintColor = oficialDarkGray
        
        self.navBar.tittle.font = UIFont(name: "Sukhumvit Set", size: 40)
       
    }

    override func viewWillAppear(animated: Bool)
    {
        
        self.navigationController?.navigationBar.hidden = true
//        let bar : UINavigationBar! =  self.navigationController?.navigationBar
//        
//        let backButton = UIBarButtonItem(image: UIImage(named: "backButton"), style: .Plain, target: self, action: "back")
//        
//        self.navigationItem.backBarButtonItem = backButton
//        
//    
//        bar.barTintColor = oficialDarkGray
//        bar.tintColor = oficialGreen
//        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        bar.titleTextAttributes = titleDict as? [String : AnyObject]
//        self.title = "Settings"
//        bar.titleTextAttributes = [NSForegroundColorAttributeName : oficialGreen]
//        

        
       
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            return 1
        }
        else if(section == 1)
        {
            return 3
        }
        else if(section == 2)
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
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = oficialSemiGray
        cell.selectionStyle = .Default
        
        let separatorLineView = UIView(frame: CGRectMake(0, 0, screenWidth, 4))
        separatorLineView.backgroundColor = oficialMediumGray
        
        
        if(indexPath.row == 0 && indexPath.section == 0)
        {
            let image = DAOUser.sharedInstance.getProfileImage()  // imagem do usuário
            let username = DAOUser.sharedInstance.getUserName()
            
            let usernameLabel : UILabel!
            let trustLabel : UILabel!
            
            self.trustLevel = DAOUser.sharedInstance.getTrustLevel()
            
            // image view que mostra a foto do usuário
            self.profilePicView = UIImageView(frame: CGRectMake(0, 0, screenWidth/2.5, screenWidth/2.5)) // onde tá a foto de perfil
            self.profilePicView.image = image
            self.profilePicView.clipsToBounds = true
            self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.width/2
            self.profilePicView.contentMode = .ScaleAspectFill
            self.profilePicView.center = CGPointMake(cell.center.x, cell.center.y - 40)
            self.profilePicView.layer.zPosition = 5
            
            // botão ícone câmera por cima da foto de perfil
            self.editPhotoButton = UIButton(frame: CGRectMake(0, 0 , screenWidth/2.5, screenWidth/2.5))
            self.editPhotoButton.setImage(UIImage(named: "settingsCameraButton"), forState: .Normal)
            self.editPhotoButton.alpha = 0.5
            self.editPhotoButton.addTarget(self, action: "changeProfilePicture", forControlEvents: .TouchUpInside)
            self.editPhotoButton.center = CGPointMake(cell.center.x, cell.center.y - 40)
            
            // label que mostra nome do usuário
            usernameLabel = UILabel(frame: CGRectMake(0, 0, screenWidth, 20))
            usernameLabel.text = username
            usernameLabel.textColor = oficialLightGray // verificar trust level
            usernameLabel.textAlignment = .Center
            usernameLabel.center = CGPointMake(cell.center.x, cell.center.y + self.profilePicView.frame.height/4 + 10)
            
            // label que mostra trust level do usuário
            trustLabel = UILabel(frame: CGRectMake(0, 0, screenWidth, 40))
            trustLabel.text = "\(self.trustLevel)" + "%"
            trustLabel.font = UIFont(name: "Helvetica", size: 25)
            trustLabel.center = CGPointMake(cell.center.x, cell.center.y + self.profilePicView.frame.height/4 + usernameLabel.frame.height + 10)
            trustLabel.textAlignment = .Center
            
            if(self.trustLevel == 100)
            {
                trustLabel.textColor = oficialGreen
            }
            else
            {
                trustLabel.textColor = oficialRed
            }
            

            
            addCircleView()

            
            cell.subviews.last?.removeFromSuperview()
            cell.addSubview(usernameLabel)
            cell.addSubview(trustLabel)
            cell.addSubview(self.profilePicView)
            cell.addSubview(self.editPhotoButton)
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            


        }
            
        else if(indexPath.section == 1)
        {
            if(indexPath.row == 0)
            {
                let nextButton = UIButton(frame: CGRectMake(screenWidth - 45, 0, 45, 45))
                nextButton.setImage(UIImage(named: "nextButton"), forState: .Normal)
                cell.addSubview(nextButton)
                
                
                cell.textLabel?.text = self.section1[indexPath.row]
                cell.textLabel?.textColor = UIColor.grayColor()
            }
            else if(indexPath.row == 1)
            {
                cell.textLabel?.text = self.section1[indexPath.row]
                cell.textLabel?.textColor = UIColor.grayColor()
            }
            else if(indexPath.row == 2)
            {
                cell.textLabel?.text = self.section1[indexPath.row]
                cell.textLabel?.textColor = UIColor.grayColor()
            }
        }
        
        else if(indexPath.section == 2)
        {
            let nextButton = UIButton(frame: CGRectMake(screenWidth - 45, 0, 45, 45))
            nextButton.setImage(UIImage(named: "nextButton"), forState: .Normal)
            cell.addSubview(nextButton)
            
            cell.textLabel?.text = self.section2[indexPath.row]
            cell.textLabel?.textColor = UIColor.grayColor()

        }
        
        cell.contentView.addSubview(separatorLineView)

        
        return cell
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView)
    {
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
      
        
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: {
            
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
            self.popover = UIPopoverController(contentViewController: self.picker!)
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
            self.picker?.sourceType = UIImagePickerControllerSourceType.Camera
            self.picker?.cameraDevice = .Front
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
        self.picker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone)
        {
            self.presentViewController(self.picker!, animated: true, completion: nil)
        }
        else
        {
            self.popover = UIPopoverController(contentViewController: self.picker!)
            self.popover?.presentPopoverFromRect(self.editPhotoButton.frame, inView: self.view, permittedArrowDirections: .Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.image = image
        self.profilePicView.image = self.image
        self.profilePicView.contentMode = UIViewContentMode.ScaleAspectFill
//        self.photoButton.setImage(self.profilePicView.image, forState: .Normal)
//        self.tableView.reloadData()
        
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
    
    func addCircleView()
    {
        let circleWidth = screenWidth/2
        let circleHeight = screenWidth/2
        
        // Create a new CircleView
        let circleView = CircleView(frame: CGRectMake(0, 0, circleWidth, circleHeight))
        
        circleView.center = CGPointMake(self.profilePicView.center.x, self.profilePicView.center.y)
        
        circleView.setColor(self.trustLevel)
        circleView.layer.zPosition = 0
        
        view.addSubview(circleView)
        
        // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(1.0, trustLevel: self.trustLevel)
    }
    

}
