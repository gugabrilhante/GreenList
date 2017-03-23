//
//  ResourceCell.swift
//  GreenList
//
//  Created by Gustavo Belo Brilhante on 21/03/17.
//  Copyright © 2017 Gustavo. All rights reserved.
//

import Foundation
import UIKit

class ResourceCell : UITableViewCell{
    
    @IBOutlet weak var resourceContentLabel: UILabel!
    
    @IBOutlet weak var updatedAtContent: UILabel!
    @IBOutlet weak var valueContent: UILabel!
    
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
    
    func setContents(res:ResourceArg){
        resourceContentLabel.text = res.resource_id
        updatedAtContent.text = res.updated_at
        valueContent.text = res.value
    }
    
}

