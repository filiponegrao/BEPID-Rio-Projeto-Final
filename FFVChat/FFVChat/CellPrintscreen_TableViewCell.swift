//
//  CellPrintscreen_TableViewCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 28/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class CellPrintscreen_TableViewCell: UITableViewCell
{
    var photo : UIImageView!
    
    var title: UILabel!
    
    var details : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.photo = UIImageView(frame: CGRectMake(10, 10, 80, 80))
        self.photo.contentMode = .ScaleAspectFill
        self.photo.layer.cornerRadius = 8 //self.photo.frame.size.width/2
        self.photo.clipsToBounds = true
        self.addSubview(self.photo)
        
        self.title = UILabel(frame: CGRectMake(self.photo.frame.origin.x + self.photo.frame.size.width + 10, 10, screenWidth - 110, 60))
        self.title.text = "testando um texto grande pra ficar escirto em duas linhas e tal"
        self.title.numberOfLines = 3
        self.title.font = UIFont(name: "Helvetica", size: 16)
        self.title.textColor = oficialLightGray
        self.title.textAlignment = .Left
        self.addSubview(self.title)
        
        self.details = UILabel(frame: CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y + self.title.frame.size.height, self.title.frame.size.width, 30))
        self.details.textAlignment = .Left
        self.details.font = UIFont(name: "Helvetica", size: 10)
        self.details.textColor = oficialLightGray
        self.details.numberOfLines = 2
        self.addSubview(self.details)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
