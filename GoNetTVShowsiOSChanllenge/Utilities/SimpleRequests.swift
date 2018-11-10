//
//  SimpleRequests.swift
//  ApplaudoStudiosHomeWorkAnilist
//
//  Created by Leon Yannik Lopez Rojas on 11/10/17.
//  Copyright © 2017 Leon Yannik Lopez Rojas. All rights reserved.
//

import Foundation

class Request {
    
    class func fromURL(mainAddress: String, call: String) -> URLRequest {
        let postEndpointForEvent = mainAddress + call
        let url = URL(string: postEndpointForEvent)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    class func formURLWithVariables(mainAddress: String, call: String, variables: [String:Any]) -> URLRequest {
        let postEndpointForEvent = mainAddress + call
        var rawData = ""
        for (key,value) in variables {
            rawData += key + "="
            rawData += value as! String + "&"
        }
        let url = URL(string: postEndpointForEvent)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = rawData.data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        return request
    }
    
    class func fromURLWithHeaders(mainAddress: String, call: String, headers: [String: String]) -> URLRequest {
        let postEndpointForEvent = mainAddress + call
        let url = URL(string: postEndpointForEvent)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        for (header, value) in headers{
            request.setValue(value, forHTTPHeaderField: header)
        }
        return request
    }
}
