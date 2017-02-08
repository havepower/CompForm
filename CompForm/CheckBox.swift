//
//  CheckBox.swift
//  ListMeds
//
//  Created by My Star on 2/3/17.
//  Copyright © 2017 Silver Star. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    // Images
    let checkedImage = UIImage(named: "ic_checked")! as UIImage
    let uncheckedImage = UIImage(named: "ic_unchecked")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
//        self.addTarget(self, action:#selector(buttonClicked), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
//    func buttonClicked(sender: UIButton) {
//        if sender == self {
//            isChecked = !isChecked
//        }
//    }
}
