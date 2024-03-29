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
                
    var navBar : NavigationGallery_View!
    
    var contact : Contact!
    
    var sentMidias  = [SentMidia]()
    
    var imageManagerScreeen : ImageManager_View!
    
    var text : UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        self.navigationController!.interactivePopGestureRecognizer!.enabled = false
        
        self.navBar = NavigationGallery_View(requester: self)
        self.view.addSubview(self.navBar)

        self.sentMidias = DAOSentMidia.sharedInstance.sentMidiaFor(self.contact)

        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.itemSize = CGSize(width: screenWidth/3 - 5, height: screenWidth/3 - 5)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 5 //espaçamento entre uma celula de baixo com a de cima
        layout.headerReferenceSize = CGSizeMake(0, 0)

        self.collectionView = UICollectionView(frame: CGRectMake(0, 70, screenWidth, screenHeight - 70) , collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.registerClass(CellSentMidia_CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        
        self.text = UILabel(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.text.font = UIFont(name: "SukhumvitSet-Text", size: 17)
        self.text.text = "There is no pictures"
        self.text.textColor = oficialLightGray
        self.text.textAlignment = .Center
        self.text.alpha = 0
        self.view.addSubview(self.text)
        
        //PasswordView
        self.passwordView = Password_View(requester:self)
        self.view.addSubview(self.passwordView)
        
        if(self.sentMidias.count == 0)
        {
            self.text.alpha = 1
        }
        else
        {
            self.text.alpha = 0
        }
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
 
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
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
        
        cell.backgroundColor = UIColor.clearColor()
        let img = UIImage(data: self.sentMidias[indexPath.item].image!)
        cell.image.image = img
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let attributes : UICollectionViewLayoutAttributes = self.collectionView.layoutAttributesForItemAtIndexPath(indexPath)!
        let frame = attributes.frame
        
        let origin = self.collectionView.convertRect(frame, toView: self.collectionView.superview)
        
        self.imageManagerScreeen = ImageManager_View(sentMidia: self.sentMidias[indexPath.row], requester: self, photoOrigin: origin)
        
        self.view.addSubview(self.imageManagerScreeen)
        self.imageManagerScreeen.animateOn()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.sentMidias.count
    }
    
    //** END COLLECTION VIEW PROPERTIES **//

    
}
