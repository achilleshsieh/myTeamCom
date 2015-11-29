//
//  MaterialButton.swift
//  myTeamCom
//
//  Created by aloha kids on 11/24/15.
//  Copyright © 2015 Richard. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.9
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }

}
