//
//  Notification_TableViewCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 07/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Notification_TableViewCell: UITableViewCell
{

    var icon : UIImageView!
    
    var notification : UILabel!
    
    var acceptButton : UIButton!
    
    var request : FriendRequest?

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.icon = UIImageView(frame: CGRectMake(10, 10, 50, 50))
        self.icon.image = UIImage(named: "addButton")
        self.icon.clipsToBounds = true
        self.icon.layer.cornerRadius = self.icon.frame.size.width/2
        self.addSubview(self.icon)
        
        self.notification = UILabel(frame: CGRectMake(70, 10, screenWidth - 70 - 70, 40))
        self.notification.textColor = lightBlue
        self.notification.numberOfLines = 3
        self.addSubview(self.notification)
        
        
        self.acceptButton = UIButton(frame: CGRectMake(screenWidth - 70, 0, 70, 70))
        self.acceptButton.setImage(UIImage(named: "accept"), forState: .Normal)
        self.acceptButton.addTarget(self, action: "acceptRequest", forControlEvents: .TouchUpInside)
        self.addSubview(self.acceptButton)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }

    
    func acceptRequest()
    {
        DAOFriendRequests.sharedInstance.acceptRequest(self.request!)
    }
}


