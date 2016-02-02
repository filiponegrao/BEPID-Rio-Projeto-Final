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
    
    var backgroundLabel : UIView!
    
    var textMessage : UILabel!
    
    var sentDate : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.cellView = UIView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        self.cellView.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(cellView)
        
        self.backgroundLabel = UIView(frame: CGRectMake(margemLateral, margemVertical, cellBackgroundWidth, cellBackgroundHeigth))
        self.backgroundLabel.backgroundColor = UIColor.whiteColor()
        self.backgroundLabel.layer.cornerRadius = 10
        self.backgroundLabel.alpha = 0.1
        self.cellView.addSubview(self.backgroundLabel)
        
        self.textMessage = UILabel(frame: CGRectMake(margemLateral * 2, margemVertical * 2, cellTextWidth, cellTextHeigth))
        self.textMessage.textColor = UIColor.whiteColor()
        self.textMessage.font = textMessageFont
        self.textMessage.textAlignment = .Center
        self.textMessage.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.textMessage.numberOfLines = 0
//        self.textMessage.userInteractionEnabled = false
        self.cellView.addSubview(self.textMessage)
        
        let h = Editor.heightForView("09:00", font: UIFont(name: "Gill Sans", size: 10)!, width: dateTextWidth)
        self.sentDate = UILabel(frame: CGRectMake(cellBackgroundWidth - dateTextWidth + margemLateral - 5, cellBackgroundHeigth - dateTextHeigth - margemVertical*2, dateTextWidth, h))
        self.sentDate.text = "09:00"
        self.sentDate.font = UIFont(name: "Gill Sans", size: 10)
        self.sentDate.textAlignment = .Right
        self.sentDate.textColor = UIColor.whiteColor()
        self.cellView.addSubview(self.sentDate)
        
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
