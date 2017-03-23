//
//  ResourceHolder.swift
//  GreenList
//
//  Created by Gustavo Belo Brilhante on 21/03/17.
//  Copyright © 2017 Gustavo. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResourceHolder: NSObject{
    
    var resource:ResourceArg!
    
    func toDictionary() -> [String:Any]{
        var dict = [String:Any]()
        
        dict["resource"] = self.resource.toDictionary()
        
        return dict
    }
    
    func toJSON() -> JSON {
        return JSON(self.toDictionary())
    }
    
    class func fromJSON(_ valueJSON:JSON) -> ResourceHolder {
        let resourceHolder = ResourceHolder()
     
        resourceHolder.resource = ResourceArg.fromJSON(valueJSON["resource"])
        
        return resourceHolder
    }
    
    class func collectionFromJSON(_ valueJson:JSON) -> [ResourceHolder] {
        if let valueJsonArray = valueJson.array {
            return valueJsonArray.map { (requestJSON) -> ResourceHolder in ResourceHolder.fromJSON(requestJSON) }
        }
        return [ResourceHolder]()
    }
    
}
