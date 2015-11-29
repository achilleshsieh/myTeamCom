//
//  MaterialTextField.swift
//  myTeamCom
//
//  Created by aloha kids on 11/24/15.
//  Copyright © 2015 Richard. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
    }
    
    // for placeholder
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    // for editable text
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

}
