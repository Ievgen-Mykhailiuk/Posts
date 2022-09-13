//
//  EndPoint.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import Foundation

enum EndPoint {
    case postList
    case post(id: Int)
}

extension EndPoint {
    var domainComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "raw.githubusercontent.com"
        components.path = path
        return components
    }
    
    var path: String {
        switch self {
        case .postList:
            return "/anton-natife/jsons/master/api/main.json"
        case .post(let id):
            return "/anton-natife/jsons/master/api/posts/\(id).json"
        }
    }
    
    var url: URL? {
        let components = domainComponents
        return components.url
    }
}
