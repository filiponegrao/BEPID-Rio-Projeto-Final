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
    
    var cellBackgroundView : UIView!
    
    var message : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame.size.height = 70
        
        self.cellView = UIView(frame: CGRectMake(screenWidth/6, 5, (screenWidth/6) * 5, self.frame.size.height - 5))
        print(self.frame.size.height)
        self.cellView.backgroundColor = UIColor.clearColor()
        self.cellView.clipsToBounds = true
        self.cellView.layer.cornerRadius = 7.0
        self.cellView.center = CGPointMake(self.center.x, self.center.y)
        self.contentView.addSubview(cellView)
        
        self.cellBackgroundView = UIView(frame: CGRectMake(0, 0, self.cellView.frame.size.width, self.cellView.frame.size.height))
        self.cellBackgroundView.backgroundColor = UIColor.whiteColor()
        self.cellBackgroundView.alpha = 0.2
        self.cellView.addSubview(cellBackgroundView)
        
        self.message = UILabel(frame: CGRectMake(5, 5, self.cellView.frame.size.width - 10, self.cellView.frame.size.height - 10))
        self.message.textColor = UIColor.whiteColor()
        self.message.textAlignment = .Center
        self.cellView.addSubview(message)
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
