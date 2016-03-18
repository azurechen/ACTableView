//
//  ACAbstractTableViewCell.swift
//  ACTableView
//
//  Created by Azure Chen on 3/14/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACAbstractTableViewCell: UITableViewCell {
    
    private let ICON_WIDTH: CGFloat = 29.0
    private let ICON_TEAILING: CGFloat = 15.0
    
    @IBOutlet weak var iconImageView: UIImageView?
    @IBOutlet weak var iconWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var iconTrailingConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var inset: CGFloat?
    
    internal weak var input: ACInput?
    internal var params: ACFormParams?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inset = self.separatorInset.left
    }
    
    internal func setIconImage(image: UIImage?) {
        if (iconImageView != nil && image != nil) {
            iconWidthConstraint?.constant = ICON_WIDTH
            iconTrailingConstraint?.constant = ICON_TEAILING
            self.separatorInset = UIEdgeInsets(top: 0, left: inset! + ICON_WIDTH + ICON_TEAILING, bottom: 0, right: 0)
        } else {
            iconWidthConstraint?.constant = 0
            iconTrailingConstraint?.constant = 0
            self.separatorInset = UIEdgeInsets(top: 0, left: inset!, bottom: 0, right: 0)
        }
        
        iconImageView?.image = image
    }
    
    internal func setTitle(title: String?, withParams params: ACFormParams) {
        switch params.style {
        case .Value1:
            titleLabel.text = title
            titleLabel.textColor = params.normalColor
        case .Value2:
            titleLabel.text = title
            titleLabel.textColor = params.tintColor
        }
    }
    
    internal func initByInput(input: ACInput, withParams params: ACFormParams) {
        setIconImage(input.image)
        setTitle(input.title, withParams: params)
    }
    
    internal func updateByInput() {
    }
    
}
