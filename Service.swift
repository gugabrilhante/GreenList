//
//  Service.swift
//  GreenList
//
//  Created by Gustavo Belo Brilhante on 21/03/17.
//  Copyright © 2017 Gustavo. All rights reserved.
//

import Foundation
import SwiftyJSON

class Service : BaseServices {

    class func genericGetRequest(path:String, callBack: @escaping (JSON?, Int?) -> Void){
        
        APIRequest(method: .get, apiPath: path , parameters: nil, callback: { (jsonResponse, statusCode) in
            if let Json = jsonResponse {
                callBack(Json, statusCode)
            }else {
                callBack(nil, statusCode)
            }
        })
    }
}
