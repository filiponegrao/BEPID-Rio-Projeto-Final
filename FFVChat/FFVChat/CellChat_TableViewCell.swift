//
//  CellChat_TableViewCell.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 07/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CellChat_TableViewCell: UITableViewCell
{
    var cellView : UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame.size.height = 70
        
        self.cellView = UIView(frame: CGRectMake(screenWidth/6, 5, (screenWidth/6) * 5, self.frame.size.height - 5))
        print(self.frame.size.height)
        self.cellView.backgroundColor = UIColor.whiteColor()
        self.cellView.alpha = 0.2
//        self.cellView.clipsToBounds = true
        self.cellView.layer.cornerRadius = 7.0
        self.cellView.center = CGPointMake(self.center.x, self.center.y)
        self.contentView.addSubview(cellView)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib()
    {        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
