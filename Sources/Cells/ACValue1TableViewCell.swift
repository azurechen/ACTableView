//
//  ACValue1TableViewCell.swift
//  ACTableView
//
//  Created by Azure Chen on 3/14/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACValue1TableViewCell: UITableViewCell {
    
    let ICON_WIDTH: CGFloat = 29.0
    let ICON_TEAILING: CGFloat = 15.0
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var inset: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inset = self.separatorInset.left
    }
    
    internal func setIconImage(image: UIImage?) {
        if (image != nil) {
            iconWidthConstraint.constant = ICON_WIDTH
            iconTrailingConstraint.constant = ICON_TEAILING
            self.separatorInset = UIEdgeInsets(top: 0, left: inset! + ICON_WIDTH + ICON_TEAILING, bottom: 0, right: 0)
        } else {
            iconWidthConstraint.constant = 0
            iconTrailingConstraint.constant = 0
            self.separatorInset = UIEdgeInsets(top: 0, left: inset!, bottom: 0, right: 0)
        }
        
        iconImageView.image = image
    }
}
