//
//  ResourceList.swift
//  GreenList
//
//  Created by Gustavo Belo Brilhante on 21/03/17.
//  Copyright © 2017 Gustavo. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResourceList: NSObject {
    
    var resourceList:[ResourceHolder] = [ResourceHolder]()
    
    func toDictionary() -> [String:Any]{
        var dict = [String:Any]()
        
        dict["resourceList"] = self.resourceList.map{ $0.toDictionary() }
        
        return dict
    }
    
    func toJSON() -> JSON {
        return JSON(self.toDictionary())
    }
    
}
