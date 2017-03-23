//
//  EmptyCell.swift
//  GreenList
//
//  Created by Gustavo Belo Brilhante on 23/03/17.
//  Copyright © 2017 Gustavo. All rights reserved.
//

import Foundation
import UIKit

class EmptyCell : UITableViewCell{
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.layoutMargins = UIEdgeInsets.zero
        
        // Configure the view for the selected state
    }

    
}
