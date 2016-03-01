//
//  Backgrounds_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 23/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class Backgrounds_ViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    var collectionView : UICollectionView!
    
    var backgrounds = UserLayoutSettings.sharedInstance.getBackgrounds()
    
    var selectedBackground = UserLayoutSettings.sharedInstance.getCurrentBackgroundName()
    
    var navBar : UIView!
    
    var tittle : UILabel!
    
    var label1 : UILabel!
    
    var label2 : UILabel!
    
    var photoButton : UIButton!
    
    var s : UIImageView!
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = oficialMediumGray
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 5, right: 10)
        layout.itemSize = CGSize(width: (screenWidth-20)/3 - 10, height: (screenHeight-20)/3 - 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10 //espaçamento entre uma celula de baixo com a de cima
        layout.headerReferenceSize = CGSizeMake(0, 0)
        
        
        //VIEW NAVBAR//
        self.navBar = UIView(frame: CGRectMake(0, 0, screenWidth, 70))
        self.navBar.backgroundColor = oficialDarkGray
        self.view.addSubview(self.navBar)
        
        //TITULO NAVBAR//
        self.tittle = UILabel(frame: CGRectMake(0, 25, screenWidth, 35))
        self.tittle.text = "Backgrounds"
        self.tittle.font = UIFont(name: "SukhumvitSet-Medium", size: 22)
        self.tittle.textAlignment = .Center
        self.tittle.textColor = oficialGreen
        self.view.addSubview(self.tittle)
        
        
        let backButton = UIButton(frame: CGRectMake(0,20,50,50))
        backButton.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.navBar.addSubview(backButton)
        
        self.label1 = UILabel(frame: CGRectMake(10, self.navBar.frame.size.height, screenWidth - 20, 30))
        self.label1.text = "Pick an image from your photo album"
        self.label1.font = UIFont(name: "SukhumvitSet-Medium", size: 14)
        self.label1.textColor = oficialLightGray
        self.view.addSubview(self.label1)
        
        let label = UILabel(frame: CGRectMake(0, self.label1.frame.origin.y + self.label1.frame.size.height, screenWidth, 44))
        label.backgroundColor = oficialDarkGray
        self.view.addSubview(label)
        
        self.photoButton = UIButton(frame: CGRectMake(20, self.label1.frame.origin.y + self.label1.frame.size.height, screenWidth - 20, 44))
        self.photoButton.setTitle("Photo Album", forState: .Normal)
        self.photoButton.setTitleColor(oficialLightGray, forState: .Normal)
        self.photoButton.contentHorizontalAlignment = .Left
        self.view.addSubview(self.photoButton)
        
        
        self.label2 = UILabel(frame: CGRectMake(10, self.photoButton.frame.origin.y + self.photoButton.frame.size.height + 10, screenWidth - 20, 30))
        self.label2.text = "Or choose one of theese:"
        self.label2.font = UIFont(name: "SukhumvitSet-Medium", size: 14)
        self.label2.textColor = oficialLightGray
        self.view.addSubview(self.label2)
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, self.label2.frame.origin.y + self.label2.frame.size.height, screenWidth, screenHeight - (self.label1.frame.size.height + self.photoButton.frame.size.height + self.label2.frame.size.height + 10)) , collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = oficialDarkGray
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.layer.borderColor = oficialLightGray.CGColor
        //        self.collectionView.layer.borderWidth = 0.5
        
        self.view.addSubview(self.collectionView)

    }
    
    deinit
    {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        
        while(cell.subviews.last != nil) { cell.subviews.last?.removeFromSuperview() }
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self.backgrounds[indexPath.item]
        cell.addSubview(imageView)
        
        if(self.selectedBackground == UserLayoutSettings.sharedInstance.backgrounds[indexPath.item])
        {
            s?.removeFromSuperview()
            s = UIImageView(frame: CGRectMake(0, 0, cell.frame.size.width/2, cell.frame.size.width/2))
            s.image = UIImage(named: "accept")
            s.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2)
            s.contentMode = .ScaleAspectFit
            
            imageView.alpha = 0.5
            
            cell.addSubview(s)
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.backgrounds.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)!
        
        if(self.backgrounds[indexPath.item] != self.selectedBackground)
        {
            self.selectedBackground = UserLayoutSettings.sharedInstance.backgrounds[indexPath.item]
            
            UserLayoutSettings.sharedInstance.setCurrentBackground(indexPath.item)
            
            s?.removeFromSuperview()
            s = UIImageView(frame: CGRectMake(0, 0, cell.frame.size.width/2, cell.frame.size.width/2))
            s.image = UIImage(named: "accept")
            s.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2)
            s.contentMode = .ScaleAspectFit
            
            cell.subviews.last!.alpha = 0.5
            
            self.s.transform = CGAffineTransformMakeScale(0.01, 0.01)
            
            cell.addSubview(s)
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
                
                self.s.transform = CGAffineTransformMakeScale(1, 1)
                
                }, completion: { (success: Bool) -> Void in
                    
                    
            })
        }
        else
        {
            
        }
 
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
            
            self.s.transform = CGAffineTransformMakeScale(0.01, 0.01)
            
            }, completion: { (success: Bool) -> Void in
                
                self.s?.removeFromSuperview()
        })
        
        cell?.subviews.last?.alpha = 1
    }
    
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
