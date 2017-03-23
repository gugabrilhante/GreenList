//
//  File.swift
//  GreenList
//
//  Created by Gustavo Belo Brilhante on 21/03/17.
//  Copyright © 2017 Gustavo. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON

let API_BASE_ADDRESS = "http://portal.greenmilesoftware.com/get_resources_since"

class BaseServices {
    
    static var sessionToken:String? = nil
    
    static let manager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "": .disableEvaluation
        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
    
    class func getSessionToken() -> String {
        if let sessionToken = BaseServices.sessionToken {
            return sessionToken
        }
        let userDefaults = UserDefaults.standard
        if let sessionToken:String = userDefaults.object(forKey: "sessionToken") as? String {
            BaseServices.sessionToken = sessionToken
            return sessionToken
        }
        return ""
        
    }
    
    
    class func APIRequest(method:Alamofire.HTTPMethod, apiPath:String, parameters:[String : Any]?, callback: ((JSON?, Int?) -> Void)?) {
        
        let apiRequestAddress = API_BASE_ADDRESS + apiPath
        
        Alamofire.request(apiRequestAddress, method: method, parameters: parameters, encoding: JSONEncoding.prettyPrinted, headers:nil).responseJSON { (response) in
            if response.result.isSuccess || response.result.isFailure {
                
                if let value = response.result.value {
                    
                    let serviceResponse = JSON(value)
                    if let callback = callback {
                        callback(serviceResponse, response.response?.statusCode)
                    }
                    return
                }
            }
            if let callback = callback {
                callback(nil, response.response?.statusCode)
            }
        }
    }
    
    class func APIRequestListing(method:Alamofire.HTTPMethod, apiPath:String, data:JSON, callback: ((JSON?, Int?) -> Void)?) {
        
        let urlRequest = NSURL(string: API_BASE_ADDRESS + apiPath)! as URL
        
        var methodString = "GET"
        switch(method) {
        case Alamofire.HTTPMethod.post:
            methodString =  "POST"
            break
        case Alamofire.HTTPMethod.put:
            methodString =  "PUT"
            break
        case Alamofire.HTTPMethod.delete:
            methodString =  "DELETE"
            break
        default:
            break
        }
        
        var request = URLRequest(url: urlRequest)
        request.httpMethod = methodString
        print(data.description)
        let body = data.description.data(using: String.Encoding.utf8)
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(body!.count.description, forHTTPHeaderField: "Content-Length")
        
        Alamofire.request(request).responseJSON(options: .allowFragments) { (response) -> Void in
            if response.result.isSuccess || response.result.isFailure {
                print(response.result.error.debugDescription)
                print("Request did return")
                if let value = response.result.value {
                    print(JSON(value))
                    if let callback = callback {
                        callback(JSON(value), response.response?.statusCode)
                    }
                    return
                }
            }
            if let callback = callback {
                callback(nil, response.response?.statusCode)
            }
        }
    }
}
