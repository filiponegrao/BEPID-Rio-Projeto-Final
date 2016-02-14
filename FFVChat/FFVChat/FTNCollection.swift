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
    
    var collectionView: UICollectionView!
    
    var gifs : [Gif]!
    
    var serverGifs : [String]!
    
    init(origin: CGPoint)
    {        
        super.init(frame: CGRectMake(origin.x, origin.y, gifcollectionBarWigth, gifcollectionBarHeight))
        
        self.backgroundColor = oficialSemiGray
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.frame.size.width/3, height: self.frame.size.width/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0 //espaçamento entre uma celula de baixo com a de cima
        layout.scrollDirection = .Vertical
        layout.headerReferenceSize = CGSizeMake(0, 0)
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44) , collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.registerClass(FTNCollectionWebCell.self, forCellWithReuseIdentifier: "CellWeb")
        self.collectionView.registerClass(FTNCollectionGifCell.self, forCellWithReuseIdentifier: "CellGif")
        self.collectionView.registerClass(FTNCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")

        self.collectionView.showsVerticalScrollIndicator = false
        
        self.addSubview(self.collectionView)
        
        self.closeButton = UIButton(frame: CGRectMake(0,0,self.frame.size.width,44))
        self.closeButton.setTitle("Cancelar", forState: .Normal)
        self.closeButton.setTitleColor(oficialGreen, forState: .Normal)
        self.closeButton.backgroundColor = oficialDarkGray
//        self.closeButton.setImage(UIImage(named: "close"), forState: .Normal)
        self.addSubview(self.closeButton)
        
        self.gifs = DAOContents.sharedInstance.getAllGifs()
        self.serverGifs = [String]()
        
        DAOPostgres.sharedInstance.getAllGifsName({ (gifs) -> Void in
            self.serverGifs = gifs
            self.collectionView.reloadData()
        })
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //*** TableView Properties ***//
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        switch indexPath.section
        {
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellGif", forIndexPath: indexPath) as! FTNCollectionGifCell
            cell.gifView.runGif(self.gifs[indexPath.item].data)
            cell.contentMode = .ScaleAspectFill
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellWeb", forIndexPath: indexPath) as! FTNCollectionWebCell
            cell.webView.loadRequest(NSURLRequest(URL: NSURL(string: DAOContents.sharedInstance.getUrlFromGifName(self.serverGifs[indexPath.item]))!))
            cell.webView.contentScaleFactor = 2
            cell.webView.userInteractionEnabled = false
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
            
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        switch section
        {
        case 0:
            return self.gifs.count
        case 1:
            return self.serverGifs.count
            
        default:
            
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(self.collectionView.frame.size.width, 44)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        switch kind
        {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! FTNCollectionViewHeader
            
            switch indexPath.section
            {
            case 0:
                headerView.title.text = "GIFs baixados (enviados e recebidos)"
            case 1:
                headerView.title.text = "GIFs disponiveis"
                
            default:
                break
            }
            
            return headerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    
}