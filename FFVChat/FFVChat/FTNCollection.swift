//
//  FTNCollection.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class FTNCollection : UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    var closeButton : UIButton!
    
    var moreButton : UIButton!
    
    var collectionView: UICollectionView!
    
    var gifs : [Gif]!
    
    var selectedGif: String = ""
    
    var confirmView : UIView!
    
    weak var controller : FTNChatController!
    
    var s : UIImageView!
    
    init(origin: CGPoint, controller : FTNChatController)
    {
        self.controller = controller
        super.init(frame: CGRectMake(origin.x, origin.y, gifcollectionBarWigth, gifcollectionBarHeight))
        
        self.backgroundColor = oficialSemiGray
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.frame.size.width/3, height: self.frame.size.width/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0 //espaçamento entre uma celula de baixo com a de cima
        layout.scrollDirection = .Vertical
        layout.headerReferenceSize = CGSizeMake(0, 0)
        
        self.gifs = DAOContents.sharedInstance.getAllGifs()
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44) , collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.registerClass(FTNCollectionGifCell.self, forCellWithReuseIdentifier: "CellGif")



        self.collectionView.showsVerticalScrollIndicator = false
        
        self.addSubview(self.collectionView)
        
        let blackview = UIView(frame: CGRectMake(0,0,self.frame.size.width, 44))
        blackview.backgroundColor = oficialDarkGray
        self.addSubview(blackview)
        
        self.closeButton = UIButton(frame: CGRectMake(20,0,self.frame.size.width/2 - 20,44))
        self.closeButton.setTitle("Cancel", forState: .Normal)
        self.closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.closeButton.contentHorizontalAlignment = .Left
        self.closeButton.titleLabel?.font = UIFont(name: "Sukhumvit Set", size: 17)
        self.addSubview(self.closeButton)
        
        self.moreButton = UIButton(frame: CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2 - 20, 44))
        self.moreButton.setTitle("More", forState: .Normal)
        self.moreButton.setTitleColor(oficialGreen, forState: .Normal)
        self.moreButton.contentHorizontalAlignment = .Right
        self.moreButton.titleLabel?.font = UIFont(name: "Sukhumvit Set", size: 17)
        self.addSubview(self.moreButton)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: NotificationController.center.gifDownloaded.name, object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //*** TableView Properties ***//
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellGif", forIndexPath: indexPath) as! FTNCollectionGifCell
        cell.gifView.runGif(self.gifs[indexPath.item].data)
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FTNCollectionGifCell
        
        if(self.selectedGif == self.gifs[indexPath.item].name)
        {
            self.selectedGif = ""
            self.controller.delegate?.FTNChatSendGifName(self.controller, gifName: self.gifs[indexPath.item].name)
            self.controller.closeGifGallery()
            cell.removeConfirm()
        }
        else
        {
            self.selectedGif = self.gifs[indexPath.item].name

            cell.insertConfirm()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FTNCollectionGifCell
        
        cell.removeConfirm()
        
    }
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.gifs.count
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSizeMake(self.collectionView.frame.size.width, 44)
//    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSizeMake(self.collectionView.frame.size.width, 44)
//    }
//    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
//    {
//        switch kind
//        {
//            
//        case UICollectionElementKindSectionHeader:
//            
//            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! FTNCollectionViewHeader
//            
//            headerView.title.text = "GIFs mais acessados!"
//            
//            return headerView
//            
//        case UICollectionElementKindSectionFooter:
//            
//            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! FTNCollectionViewHeader
//            
//            footerView.title.text = "As imagens sao de direito da figura exposta."
//            footerView.title.adjustsFontSizeToFitWidth = true
//            footerView.title.minimumScaleFactor = 0.1
//            
//            return footerView
//            
//        default:
//            
//            assert(false, "Unexpected element kind")
//            
//            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! FTNCollectionViewHeader
//
//            return footerView
//        }
//    }
    
    
    func refresh()
    {
        self.gifs = DAOContents.sharedInstance.getAllGifs()
        self.collectionView.reloadData()
    }
    
}