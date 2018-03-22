//
//  FolderTableViewCell.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 2/26/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import UIKit

class FolderTableViewCell: UITableViewCell {
    @IBOutlet var folderName: UILabel!
    @IBOutlet var timesRight: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
