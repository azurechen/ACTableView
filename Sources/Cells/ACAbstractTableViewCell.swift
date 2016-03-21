//
//  ACAbstractTableViewCell.swift
//  ACTableView
//
//  Created by Azure Chen on 3/14/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACAbstractTableViewCell: UITableViewCell {
    
    internal let ICON_WIDTH: CGFloat = 29.0
    internal let ICON_TEAILING: CGFloat = 15.0
    
    @IBOutlet weak var iconImageView: UIImageView?
    @IBOutlet weak var iconWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var iconTrailingConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var inset: CGFloat?
    
    internal weak var input: ACInput?
    internal var params: ACFormParams?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        
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
        titleLabel.text = title
        switch params.style {
        case .Value1:
            titleLabel.textColor = params.firstColor
        case .Value2:
            titleLabel.textColor = params.tintColor
        }
    }
    
    internal func initWithInput(input: ACInput, withParams params: ACFormParams) {
        self.input = input
        self.params = params
        
        setIconImage(input.image)
        setTitle(input.title, withParams: params)
    }
    
}
