//
//  FNChoiceBar.swift
//  FFVChat
//
//  Created by Filipo Negrao on 01/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol FNChoiceBarDelegate
{
    func fnChoiceBar(itemSelecionado index: Int)
}

class FNChoiceBar : UIView, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate
{
    var lastContentOffset : CGFloat!
    
    public weak var delegate : FNChoiceBarDelegate?

    var collectionView : UICollectionView!
    
    var selectionLine : UIView!
    
    //Fixos
    var altura : CGFloat!
    
    //Manejamento de itens
    var opcoes = [String]()
    
    var imagens = [UIImage]()
    
    init(altura: CGFloat, opcoes: [String], imagens: [UIImage])
    {
        self.imagens = imagens
        self.opcoes = opcoes
        self.altura = altura
        super.init(frame: CGRectMake(0, screenHeight - altura, screenWidth, altura))
    
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: altura - 5, height: altura - 5)
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 5 //espaçamento entre uma celula de baixo com a de cima
        layout.headerReferenceSize = CGSizeMake(0, 0)
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 5, screenWidth, altura - 5), collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.registerClass(CellFilter_CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.collectionView)
        
        
        self.selectionLine = UIView(frame: CGRectMake(0, 0, altura - 10, 2))
        self.selectionLine.backgroundColor = oficialGreen
        self.addSubview(self.selectionLine)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CellFilter_CollectionViewCell
        
        cell.title.text = self.opcoes[indexPath.item]
        cell.imageView.image = self.imagens[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return opcoes.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var attributes : UICollectionViewLayoutAttributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath)!
        var rect = attributes.frame
        
        var frame = collectionView.convertRect(rect, toView: collectionView.superview)
        
        let limite = frame.origin.x + altura - 5
        let origem = frame.origin.x
        
        print("limite \(limite) e origem \(origem)")
        
        if(limite > screenWidth)
        {
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        }
        else if((origem - self.collectionView.contentOffset.y) < 0)
        {
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        }
        
        attributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath)!
        rect = attributes.frame
        
        frame = collectionView.convertRect(rect, toView: collectionView.superview)
        
        let inicio = frame.origin.x
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.selectionLine.frame.origin.x = inicio
            
            }) { (success: Bool) -> Void in
                
                
        }
        
        self.delegate?.fnChoiceBar(itemSelecionado: indexPath.item)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        self.lastContentOffset = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        self.lastContentOffset = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if(self.lastContentOffset == nil) { self.lastContentOffset = scrollView.contentOffset.x }
        let distance = self.lastContentOffset - scrollView.contentOffset.x
        
        self.lastContentOffset = scrollView.contentOffset.x
        self.selectionLine.frame.origin.x += distance
    }
    
}


