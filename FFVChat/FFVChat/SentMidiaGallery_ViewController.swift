//
//  SentMidiaGallery_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit
import Foundation

class SentMidiaGallery_ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    let bWidth = screenWidth/4.5
    
    let bMargem : CGFloat = 15

    var collectionView : UICollectionView!
    
    var passwordView : UIView!
    
    var passwordLabel : UILabel!
    
    var passwordNumbers = [Int]()
    
    var blurView : UIVisualEffectView!
    
    var navBarView : UIView!
    
    var contact : Contact!
    
    var sentMidias  = [SentMidia]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        self.navBarView = UIView(frame: CGRectMake(0, 0, screenWidth, 80))
        self.navBarView.backgroundColor = oficialDarkGray
        let backButton = UIButton(frame: CGRectMake(0, 25, 44, 44))
        backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        backButton.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        self.navBarView.addSubview(backButton)
        self.view.addSubview(self.navBarView)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        layout.itemSize = CGSize(width: screenWidth/2-13, height: screenWidth/2-13)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8 //espaçamento entre uma celula de baixo com a de cima
        layout.headerReferenceSize = CGSizeMake(0, 0)

        self.collectionView = UICollectionView(frame: CGRectMake(0, 80, screenWidth, screenHeight - 80) , collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.registerClass(CellSentMidia_CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.view.addSubview(self.collectionView)
        
        
        //blur
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.blurView.frame = self.view.bounds
        self.view.addSubview(self.blurView)
        
        //PasswordView
        self.passwordView = self.createPasswordView()
        self.view.addSubview(self.passwordView)

    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.sentMidias = DAOSentMidia.sharedInstance.sentMidiaFor(self.contact)
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    

    //*** COLLECTION VIEW PROPERTIES **//
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CellSentMidia_CollectionViewCell
        
        let img = UIImage(data: self.sentMidias[indexPath.item].image!)
        cell.image.image = img
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.sentMidias.count
    }
    
    //** END COLLECTION VIEW PROPERTIES **//

    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func createPasswordView() -> UIView
    {
        let password = UIView(frame: CGRectMake(0,0,screenWidth,screenHeight))
        password.backgroundColor = UIColor.clearColor()
        
        let background = UIView(frame: CGRectMake(0,0,screenWidth,screenHeight))
        background.backgroundColor = oficialDarkGray
        background.alpha = 0.8
        password.addSubview(background)

        let text = UILabel(frame: CGRectMake(10, 50,screenWidth - 20,50))
        text.text = "Insert your\nMyne password"
        text.numberOfLines = 2
        text.font = UIFont(name: "Helvetica", size: 20)
        text.textColor = oficialGreen
        text.textAlignment = .Center
        password.addSubview(text)
        
        let cancelButton = UIButton(frame: CGRectMake(0,20,50,50))
        cancelButton.setTitle("X", forState: .Normal)
        cancelButton.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        password.addSubview(cancelButton)
        
        self.passwordLabel = UILabel(frame: CGRectMake(20,text.frame.origin.y + text.frame.size.height, screenWidth - 40,50))
        self.passwordLabel.text = "_ _ _ _ _ _"
        self.passwordLabel.textColor = UIColor.whiteColor()
        self.passwordLabel.font = UIFont(name: "Helvetica", size: 20)
        self.passwordLabel.textAlignment = .Center
        password.addSubview(self.passwordLabel)
        
        let b1 = UIButton(frame: CGRectMake(0, 0, bWidth, bWidth))
        b1.center = CGPointMake(screenWidth/4 - bMargem, screenHeight*2/5 - 10)
        b1.layer.cornerRadius = bWidth/2
        b1.layer.borderColor = oficialGreen.CGColor
        b1.setTitle("1", forState: .Normal)
        b1.tag = 1
        b1.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        b1.layer.borderWidth = 1
        b1.titleLabel?.font = UIFont(name: "Arial", size: 35)
        password.addSubview(b1)
        
        let b2 = UIButton(frame: CGRectMake(0, 0, bWidth, bWidth))
        b2.center = CGPointMake(screenWidth/2, screenHeight*2/5 - 10)
        b2.layer.cornerRadius = bWidth/2
        b2.layer.borderColor = oficialGreen.CGColor
        b2.setTitle("2", forState: .Normal)
        b2.layer.borderWidth = 1
        b2.tag = 2
        b2.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        b2.titleLabel?.font = UIFont(name: "Arial", size: 35)
        password.addSubview(b2)
        
        let b3 = UIButton(frame: CGRectMake(0, 0, bWidth, bWidth))
        b3.center = CGPointMake(screenWidth*3/4 + bMargem, screenHeight*2/5 - 10)
        b3.layer.cornerRadius = bWidth/2
        b3.layer.borderColor = oficialGreen.CGColor
        b3.setTitle("3", forState: .Normal)
        b3.layer.borderWidth = 1
        b3.tag = 3
        b3.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        b3.titleLabel?.font = UIFont(name: "Arial", size: 35)
        password.addSubview(b3)
        
        let b4 = UIButton(frame: CGRectMake(b1.frame.origin.x, b1.frame.origin.y + b1.frame.size.height + bMargem, bWidth, bWidth))
        b4.layer.cornerRadius = bWidth/2
        b4.layer.borderColor = oficialGreen.CGColor
        b4.setTitle("4", forState: .Normal)
        b4.layer.borderWidth = 1
        b4.tag = 4
        b4.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        b4.titleLabel?.font = UIFont(name: "Arial", size: 35)
        password.addSubview(b4)
        
        let b5 = UIButton(frame: CGRectMake(b2.frame.origin.x, b2.frame.origin.y + b2.frame.size.height + bMargem, bWidth, bWidth))
        b5.layer.cornerRadius = bWidth/2
        b5.layer.borderColor = oficialGreen.CGColor
        b5.setTitle("5", forState: .Normal)
        b5.layer.borderWidth = 1
        b5.tag = 5
        b5.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        b5.titleLabel?.font = UIFont(name: "Arial", size: 35)
        password.addSubview(b5)
        
        let b6 = UIButton(frame: CGRectMake(b3.frame.origin.x, b3.frame.origin.y + b3.frame.size.height + bMargem, bWidth, bWidth))
        b6.layer.cornerRadius = bWidth/2
        b6.layer.borderColor = oficialGreen.CGColor
        b6.setTitle("6", forState: .Normal)
        b6.layer.borderWidth = 1
        b6.tag = 6
        b6.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        b6.titleLabel?.font = UIFont(name: "Arial", size: 35)
        password.addSubview(b6)
        
        let b7 = UIButton(frame: CGRectMake(b4.frame.origin.x, b4.frame.origin.y + b4.frame.size.height + bMargem, bWidth, bWidth))
        b7.layer.cornerRadius = bWidth/2
        b7.layer.borderColor = oficialGreen.CGColor
        b7.setTitle("7", forState: .Normal)
        b7.layer.borderWidth = 1
        b7.tag = 7
        b7.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        b7.titleLabel?.font = UIFont(name: "Arial", size: 35)
        password.addSubview(b7)
        
        let b8 = UIButton(frame: CGRectMake(b5.frame.origin.x, b5.frame.origin.y + b5.frame.size.height + bMargem, bWidth, bWidth))
        b8.layer.cornerRadius = bWidth/2
        b8.layer.borderColor = oficialGreen.CGColor
        b8.setTitle("8", forState: .Normal)
        b8.layer.borderWidth = 1
        b8.tag = 8
        b8.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        b8.titleLabel?.font = UIFont(name: "Arial", size: 35)
        password.addSubview(b8)
        
        let b9 = UIButton(frame: CGRectMake(b6.frame.origin.x, b6.frame.origin.y + b6.frame.size.height + bMargem, bWidth, bWidth))
        b9.layer.cornerRadius = bWidth/2
        b9.layer.borderColor = oficialGreen.CGColor
        b9.setTitle("9", forState: .Normal)
        b9.layer.borderWidth = 1
        b9.tag = 9
        b9.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        b9.titleLabel?.font = UIFont(name: "Arial", size: 35)
        password.addSubview(b9)
        
        let b0 = UIButton(frame: CGRectMake(b8.frame.origin.x, b8.frame.origin.y + b5.frame.size.height + bMargem, bWidth, bWidth))
        b0.layer.cornerRadius = bWidth/2
        b0.layer.borderColor = oficialGreen.CGColor
        b0.setTitle("0", forState: .Normal)
        b0.layer.borderWidth = 1
        b0.tag = 0
        b0.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        b0.titleLabel?.font = UIFont(name: "Arial", size: 35)
        password.addSubview(b0)
        
        let limpar = UIButton(frame: CGRectMake(b9.frame.origin.x,b0.frame.origin.y, bWidth, bWidth))
        limpar.setTitle("Clean", forState: .Normal)
        limpar.addTarget(self, action: "clean", forControlEvents: .TouchUpInside)
        password.addSubview(limpar)
        
        
        return password
    }
    
    
    func clickButton(sender: UIButton)
    {
        self.passwordNumbers.append(sender.tag)
        switch self.passwordNumbers.count
        {
        case 0:
            self.passwordLabel.text = "_ _ _ _ _ _"
            
        case 1:
            self.passwordLabel.text = "\(self.passwordNumbers[0]) _ _ _ _ _"
            
        case 2:
            self.passwordLabel.text = "* \(self.passwordNumbers[1]) _ _ _ _"
            
        case 3:
            self.passwordLabel.text = "* * \(self.passwordNumbers[2]) _ _ _"
            
        case 4:
            self.passwordLabel.text = "* * * \(self.passwordNumbers[3]) _ _"
            
        case 5:
            self.passwordLabel.text = "* * * * \(self.passwordNumbers[4]) _"
            
        case 6:
            self.passwordLabel.text = "* * * * *\(self.passwordNumbers[5])"
            let inserted = "\(self.passwordNumbers[0])\(self.passwordNumbers[1])\(self.passwordNumbers[2])\(self.passwordNumbers[3])\(self.passwordNumbers[4])\(self.passwordNumbers[5])"
            if(inserted == DAOUser.sharedInstance.getPassword())
            {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.passwordView.alpha = 0
                    }, completion: { (success:Bool) -> Void in
                        self.passwordView.removeFromSuperview()
                        self.blurView.removeFromSuperview()
                })
            }
            else
            {
                let alert = UIAlertController(title: "Password Incorrect", message: "Your entered password is incorrect. It's worth remembering that this password is the Myne password you used to singin, not your iPhone password", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                    
                    self.passwordNumbers = [Int]()
                    self.passwordLabel.text = "_ _ _ _ _ _"
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        default:
            self.passwordLabel.text = "* * * *"
        }
        
    }
    
    func clean()
    {
        if(self.passwordNumbers.count > 0)
        {
            self.passwordNumbers.removeLast()
        }
        
        switch self.passwordNumbers.count
        {
        case 0:
            self.passwordLabel.text = "_ _ _ _ _ _"
            
        case 1:
            self.passwordLabel.text = "\(self.passwordNumbers[0]) _ _ _ _ _"
            
        case 2:
            self.passwordLabel.text = "* \(self.passwordNumbers[1]) _ _ _ _"
            
        case 3:
            self.passwordLabel.text = "* * \(self.passwordNumbers[2]) _ _ _"
            
        case 4:
            self.passwordLabel.text = "* * * \(self.passwordNumbers[3]) _ _"
        default:
            self.passwordLabel.text = "_ _ _ _ _ _"
        }
    }
    
}
