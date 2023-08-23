//
//  RequestTool.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/20.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import Alamofire

typealias ActivityClientResponse = (Any?) -> Void

class ActivityClient: NSObject {
    
    static let shared = ActivityClient()
    
    private override init() {
        
    }
    
    func request(_ url: URL,
                 method: HTTPMethod,
                 headers: [String: String]?,
                 parameters: Parameters?,
                 completion: @escaping HttpClientResponse,
                 failure: ((Error) -> Void)? = nil) {
        
        var requestHeaders: [String: String]
        
        if headers != nil {
            requestHeaders = headers!
        } else {
            requestHeaders = [String: String]()
        }
        
        if let token = UserItemTool.defaultItem().token {
            requestHeaders["Authorization"] = "Bearer \(token)"
        }
        
        print(requestHeaders)
        
            
        AF.request(url, method: method, parameters: parameters ?? nil, encoding: JSONEncoding.default, headers: HTTPHeaders(requestHeaders)).responseJSON { (response) in
            
            switch response.result {
    
                case let .success(data):
                    completion(data)
                    break
    
                case let .failure(error):
                    failure?(error)
                    completion(nil)
                    print(error)
                    break
                    
            }
            
        }
        
    }

}
