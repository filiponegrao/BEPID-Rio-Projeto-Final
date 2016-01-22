//
//  GifKeyboard.swift
//  FFVChat
//
//  Created by Filipo Negrao on 05/01/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit


class GifKeyboard: UIView, UICollectionViewDataSource, UICollectionViewDelegate
{
    weak var controller: Chat_ViewController!
    
    var closeButton : UIButton!
    
    var galleryButton : UIButton!
    
    var collectionView: UICollectionView!
    
    var gifs : [Gif]!
    
    init(controller: Chat_ViewController)
    {
        self.controller = controller
        
        super.init(frame: CGRectMake(0, screenHeight-220, screenWidth, 220))
        
        self.backgroundColor = oficialDarkGray
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 95, height: 95)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 10 //espaçamento entre uma celula de baixo com a de cima
        layout.scrollDirection = .Horizontal
        layout.headerReferenceSize = CGSizeMake(0, 0)
        
        self.collectionView = UICollectionView(frame: CGRectMake(10, 10, screenWidth-20, 200) , collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.showsVerticalScrollIndicator = false
        self.addSubview(self.collectionView)
        
        self.gifs = DAOContents.sharedInstance.getNewestGifs()
        
        self.closeButton = UIButton(frame: CGRectMake(0,0,45,45))
        self.closeButton.setImage(UIImage(named: "close"), forState: .Normal)
        self.addSubview(self.closeButton)

    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //*** TableView Properties ***//
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        cell.clipsToBounds = true
        
        cell.subviews.last?.removeFromSuperview()
        
        let webview = UIWebView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
        webview.backgroundColor = oficialMediumGray
        webview.clipsToBounds = true
        webview.contentMode = .ScaleAspectFit
        webview.userInteractionEnabled = false
        webview.layer.cornerRadius = 8
        webview.scalesPageToFit = true
        
        let request = NSURLRequest(URL: NSURL(string: self.gifs[indexPath.item].url)!)
        
        webview.loadRequest(request)
        
        cell.addSubview(webview)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return gifs.count
    }
    
    
    
}
