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
    var collectionView : UICollectionView!
    
    var passwordView : UIView!
                
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
        
        
        //PasswordView
        self.passwordView = Password_View(requester:self)
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
    
    
}
