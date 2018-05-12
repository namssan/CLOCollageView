//
//  PickerCollectionViewCell.swift
//  CLOCollageView
//
//  Created by Sang Nam on 5/5/18.
//  Copyright © 2018 Sang Nam. All rights reserved.
//

import UIKit

class PickerViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var borderLayer: UIView!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var numLbl: UILabel!
    
    var isCellSelected : Bool = false {
        
        didSet {
            self.selectView.isHidden = !self.isCellSelected
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func initialize() {
        
        borderLayer.backgroundColor = .clear
        borderLayer.layer.borderColor = UIColor(hex: 0xF46060).cgColor
        borderLayer.layer.borderWidth = 3.0
        
    }
}
