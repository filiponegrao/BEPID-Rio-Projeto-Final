//
//  FTNChatView.swift
//  FFVChat
//
//  Created by Filipo Negrao on 05/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class FTNChatView : NSObject
{
    class func flowLayoutForCollectionChat(viewFrame frame: CGRect) -> UICollectionViewFlowLayout
    {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionLayout.itemSize = CGSize(width: frame.size.width, height: collectionCellHeight)
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 0 //espaçamento entre uma celula de baixo com a de cima
        //        self.collectionLayout.headerReferenceSize = CGSizeMake(0, 0)
        
        return collectionLayout
    }
    
    class func collectionChat(viewFrame frame: CGRect) -> UICollectionView
    {
        let collectionView = UICollectionView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height) , collectionViewLayout: self.flowLayoutForCollectionChat(viewFrame: frame))

        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.keyboardDismissMode = .Interactive
        collectionView.registerClass(FTNCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollEnabled = true

        return collectionView
    }
    
    
}