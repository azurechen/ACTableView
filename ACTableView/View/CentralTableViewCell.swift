//
//  CentralTableViewCell.swift
//  ACTableView
//
//  Created by AzureChen on 2016/2/20.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class CentralTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
