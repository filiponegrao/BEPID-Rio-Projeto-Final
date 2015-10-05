//
//  CellAdd_TableViewCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 04/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CellAdd_TableViewCell: UITableViewCell {

    @IBOutlet var photo: UIImageView!
    
    @IBOutlet var username: UILabel!
    
    @IBOutlet var trustLevel: UILabel!
    
    @IBOutlet var addButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.photo.clipsToBounds = true
        self.photo.layer.cornerRadius = self.photo.frame.size.width/2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addContact(sender: UIButton)
    {
        
    }
}
