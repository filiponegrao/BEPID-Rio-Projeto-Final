//
//  CellContacts_TableViewCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 30/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CellContacts_TableViewCell: UITableViewCell {

    @IBOutlet var username: UILabel!
    
    @IBOutlet var trustLevel: UILabel!
    
    @IBOutlet var photo: UIImageView!
    
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
