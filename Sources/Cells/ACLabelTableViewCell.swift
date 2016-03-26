//
//  ACLabelTableViewCell.swift
//  ACTableView
//
//  Created by Azure Chen on 3/20/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACLabelTableViewCell: ACAbstractTableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        adjustPreferredMaxLayoutWidth()
        super.layoutSubviews()
    }
    
    func adjustPreferredMaxLayoutWidth() {
        // adjust the height of label
        let pstyle = NSMutableParagraphStyle()
        pstyle.lineBreakMode = titleLabel.lineBreakMode
        
        let titleSize = titleLabel.text!.sizeWithAttributes([
            NSFontAttributeName: titleLabel.font,
            NSParagraphStyleAttributeName: pstyle,
            ])
        
        var marginWidth: CGFloat?
        if #available(iOS 8.0, *) {
            marginWidth = self.layoutMargins.left + self.layoutMargins.right
        }
        // set preferredMaxLayoutWidth
        contentLabel.preferredMaxLayoutWidth =
            UIScreen.mainScreen().bounds.width - titleSize.width -
            ((iconImageView != nil && iconImageView!.image != nil) ? (ICON_WIDTH + ICON_TEAILING) : 0) -
            (marginWidth != nil ? marginWidth! : 15 + 15) -
            (self.params?.style == .Value1 ? 8 : 6)
    }
    
}

public class ACInputLabel: ACInput {
    
    public init(name: String, image: UIImage?, title: String?, content: String?) {
        super.init(name: name, image: image, title: title, placeholder: nil, value: content)
    }
    
    override func getItems(params: ACFormParams) -> [ACTableViewItem] {
        // use identifier to avoid unnecessary register
        return [
            ACTableViewItem(tag: name + "_ITEM", identifier: "ACLabel\(String(params.style))", display: true) { (item, cell) in
                
                let _cell = cell as! ACLabelTableViewCell
                _cell.initWithInput(self, withParams: params)
                
                _cell.contentLabel.text = self.value as! String?
                switch params.style {
                case .Value1:
                    _cell.contentLabel.textColor = params.secondColor
                case .Value2:
                    _cell.contentLabel.textColor = params.firstColor
                }
            },
        ]
    }
    
}
