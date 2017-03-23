//
//  Resource.swift
//  GreenList
//
//  Created by Gustavo Belo Brilhante on 21/03/17.
//  Copyright © 2017 Gustavo. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResourceArg: NSObject{

    var created_at:String?
    var updated_at:String?
    var resource_id:String?
    var module_id:String?
    var value:String?
    var language_id:String?
    var user_modified:String?
    
    func toDictionary() -> [String:Any]{
        var dict = [String:Any]()
        
        dict["created_at"] = self.created_at
        dict["updated_at"] = self.updated_at
        dict["resource_id"] = self.resource_id
        dict["module_id"] = self.module_id
        dict["value"] = self.value
        dict["language_id"] = self.language_id
        dict["user_modified"] = self.user_modified
        
        return dict
    }
    
    func toJSON() -> JSON {
        return JSON(self.toDictionary())
    }
    
    class func fromJSON(_ valueJSON:JSON) -> ResourceArg {
        let resouce = ResourceArg()
        
        resouce.created_at = valueJSON["created_at"].string
        resouce.updated_at = valueJSON["updated_at"].string
        resouce.resource_id = valueJSON["resource_id"].string
        resouce.module_id = valueJSON["module_id"].string
        resouce.value = valueJSON["value"].string
        resouce.language_id = valueJSON["language_id"].string
        resouce.user_modified = valueJSON["user_modified"].string
        
        return resouce
    }
    
    class func collectionFromJSON(_ valueJson:JSON) -> [ResourceArg] {
        if let valueJsonArray = valueJson.array {
            return valueJsonArray.map { (requestJSON) -> ResourceArg in ResourceArg.fromJSON(requestJSON) }
        }
        return [ResourceArg]()
    }
    
    
}
