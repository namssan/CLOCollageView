//
//  CLOBaseLineView.swift
//  CLOCollageView
//
//  Created by Sang Nam on 6/5/18.
//  Copyright © 2018 Sang Nam. All rights reserved.
//

import UIKit

enum CLOBaseLineViewMoveType : Int {
    case leftRight
    case upDown
}

class CLOBaseLineView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var id : Int = 0
    var moveType : CLOBaseLineViewMoveType = .leftRight
    var baseLC : NSLayoutConstraint?
    
}
