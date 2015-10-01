//
//  CellChat_TableViewCell.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 01/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CellChat_TableViewCell: UITableViewCell
{
    
    @IBOutlet weak var labelMessage: UITextView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
