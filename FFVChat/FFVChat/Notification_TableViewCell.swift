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
    
    var username : UILabel!
    
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
        
        self.username = UILabel(frame: CGRectMake(70, 15, screenWidth/4 * 2, 20))
        self.username.textColor = oficialLightGray
        self.addSubview(self.username)
        
        self.notification = UILabel(frame: CGRectMake(70, 35, screenWidth/5 * 3, 20))
        self.notification.textColor = oficialLightGray
        self.notification.numberOfLines = 3
        self.addSubview(self.notification)
        
        
        self.acceptButton = UIButton(frame: CGRectMake(screenWidth - 60, 5, 60, 60))
        self.acceptButton.setImage(UIImage(named: "aceptInvite"), forState: .Normal)
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
//        let alert = UIAlertController(title: "", message: "Are you sure to add this contact?", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
//            
//            //            DAOContacts.sharedInstance.deleteContact(self.contact.username)
//            
//            
//        }))
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
//            
//            
//        }))
        
        DAOFriendRequests.sharedInstance.acceptRequest(self.request!)
        self.acceptButton.setImage(UIImage(named: "accept"), forState: .Normal)
        
    }
}


