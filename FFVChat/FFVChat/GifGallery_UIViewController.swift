//
//  GifGallery_UIViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 03/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class GifGallery_UIViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    var collectionView : UICollectionView!
    
    var navBar : UIView!
    
    var backButton : UIButton!
    
    var gifs : [Gif]!
    
    var progress : NVActivityIndicatorView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        
        self.navBar = UIView(frame: CGRectMake(0,0,screenWidth, 70))
        self.navBar.backgroundColor = oficialDarkGray
        self.view.addSubview(self.navBar)
        
        self.backButton = UIButton(frame: CGRectMake(0,20, 50, 50))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.backButton)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.itemSize = CGSize(width: screenWidth/2 - 5, height: screenWidth/2 - 5)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 5 //espaçamento entre uma celula de baixo com a de cima
        layout.headerReferenceSize = CGSizeMake(0, 0)
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 70, screenWidth, screenHeight - 70) , collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        
        self.progress = NVActivityIndicatorView(frame: CGRectMake(0, 0, 60, 60), type: NVActivityIndicatorType.Pacman, color: oficialLightGray)
        self.progress.center = self.collectionView.center
        self.progress.startAnimation()
        
        self.gifs = DAOGifs.sharedInstance.getGifs()
        self.collectionView.reloadData()
        
        if(self.gifs.count == 0)
        {
            self.collectionView.addSubview(self.progress)
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload", name: NotificationController.center.gifDownloaded.name, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(NotificationController.center.gifDownloaded)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    func back()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reload()
    {
        self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.gifs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        cell.subviews.last?.removeFromSuperview()
        
        let imageview = MKImageView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
        imageview.backgroundColor = UIColor.blackColor()
        imageview.image = UIImage.animatedImageWithData(self.gifs[indexPath.item].data)
        imageview.clipsToBounds = true
        imageview.contentMode = .ScaleAspectFill
        
        cell.addSubview(imageview)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let attributes : UICollectionViewLayoutAttributes = self.collectionView!.layoutAttributesForItemAtIndexPath(indexPath)!
        let frame = attributes.frame
        
        let origin = self.collectionView!.convertRect(frame, toView: self.collectionView!.superview)
        
        let sharing = GifSharing_View(imageOrigin: origin)
        self.view.addSubview(sharing)
        sharing.imageView.image = UIImage.animatedImageWithData(self.gifs[indexPath.item].data)
        sharing.animateOn()
        
    }

}
