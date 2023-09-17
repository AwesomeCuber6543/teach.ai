//
//  Endpoints.swift
//  HackMIT
//
//  Created by yahia salman on 9/16/23.
//

import Foundation

enum Endpoint {
    
   
    case getStudents(path: String = "/get_students")
    case addStudents(path: String = "/add_object")
    
    var request: URLRequest? {
        guard let url = self.url else {return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.addValues(for: self)
        request.httpBody = self.httpBody
        return request
    }
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.port = Constants.port
        components.path = self.path
        return components.url
    }
    
    private var path: String {
        switch self {
        case .getStudents(let path),
                .addStudents(let path):
            return path
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .addStudents:
            return HTTP.Method.post.rawValue
        case .getStudents:
            return HTTP.Method.get.rawValue
        }
    }
    
    private var httpBody: Data? {
        switch self {

        case .getStudents:
            return nil
            
        case .addStudents:
            return nil
        
        }
    
        
    }
}

extension URLRequest {
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint{
        case .addStudents,
                .getStudents:
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
        }
        
    }
}
