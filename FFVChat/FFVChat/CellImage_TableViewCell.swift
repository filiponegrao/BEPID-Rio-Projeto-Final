//
//  CellImage_TableViewCell.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CellImage_TableViewCell: UITableViewCell
{
    var cellView : UIView!
    
    var imageCell : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame.size.height = screenWidth/6 * 2
        
        self.cellView = UIView(frame: CGRectMake(0, 5, self.frame.size.height , self.frame.size.height))
        self.cellView.clipsToBounds = true
        self.cellView.layer.cornerRadius = 7.0
        self.cellView.backgroundColor = UIColor.whiteColor()
        self.cellView.center = CGPointMake(self.center.x, self.center.y)
        self.contentView.addSubview(cellView)
        
        self.imageCell = UIImageView(frame: CGRectMake(2.5, 2.5, self.cellView.frame.size.width - 5, self.cellView.frame.size.height - 5))
        self.imageCell.clipsToBounds = true
        self.imageCell.layer.cornerRadius = 7.0
        self.imageCell.center = CGPointMake(self.cellView.center.x, self.cellView.center.y)
        self.imageCell.backgroundColor = oficialGreen
        self.cellView.addSubview(imageCell)
       
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
