//
//  apimanager.swift
//  RFinder
//
//  Created by abhilash uday on 11/25/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import SwiftyJSON


typealias ServiceResponse = (JSON, NSError?) -> Void

class apimanager: NSObject {
    static let sharedInstance = apimanager()
    
    let baseURL = "http://api.v3.factual.com/"
    
    func getRandomUser(onCompletion: (JSON) -> Void) {
        let route = baseURL
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
}

    private func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }
}