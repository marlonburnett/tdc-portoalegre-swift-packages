//
//  SelectionClearTableViewCell.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 27/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import UIKit

class SelectionClearTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = backgroundView
    }
}
