//
//  NavigationSideCell.swift
//  A Sea of Quotes
//
//  Created by Maya Angelica  on 4/27/16.
//  Copyright © 2016 mayaah. All rights reserved.
//

import Foundation
import UIKit

class NavigationSideCell: UITableViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var selectIndicator: UIView!
    
    override func awakeFromNib() {
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        if(selected){
            selectIndicator.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        }else{
            selectIndicator.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        }
    }
}