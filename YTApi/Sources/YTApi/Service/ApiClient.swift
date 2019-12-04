//
//  ApiClient.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 24/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import Foundation

public enum ApiError: Error {
    case generic
}

public typealias DecodableCompletionHandler<T:Decodable> = (Result<T,ApiError>) -> ()

public protocol ApiClientContract {
    func get<T:Decodable>(from url: URL, type: T.Type, completionHandler: @escaping DecodableCompletionHandler<T>) -> URLSessionTask?
    func get<T:Decodable>(from url: URL, type: T.Type, queryItems: [String:Any], completionHandler: @escaping DecodableCompletionHandler<T>) -> URLSessionTask?
}

public class ApiClient: ApiClientContract {
    public static let shared = ApiClient()
    
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json; charset=utf-8"]
        
        return URLSession(configuration: configuration)
    }()
    
    private init() {}
    
    public func get<T:Decodable>(from url: URL, type: T.Type, completionHandler: @escaping DecodableCompletionHandler<T>) -> URLSessionTask? {
        let request = URLRequest(url: url)
        return self.get(from: request, type: type, completionHandler: completionHandler)
    }
    
    public func get<T:Decodable>(from url: URL, type: T.Type, queryItems: [String:Any], completionHandler: @escaping DecodableCompletionHandler<T>) -> URLSessionTask? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completionHandler(Result.failure(ApiError.generic))
            return nil
        }
        
        components.queryItems = queryItems.map({ URLQueryItem(name: $0.key, value: "\($0.value)") })
        
        guard let url = components.url else {
            completionHandler(Result.failure(ApiError.generic))
            return nil
        }
        
        let request = URLRequest(url: url)
        
        return self.get(from: request, type: type, completionHandler: completionHandler)
    }
    
    
    private func get<T:Decodable>(from request: URLRequest, type: T.Type, completionHandler: @escaping DecodableCompletionHandler<T>) -> URLSessionTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let rawData = data, let result = try? JSONDecoder().decode(type, from: rawData) else {
                completionHandler(Result.failure(ApiError.generic))
                return
            }
            
            completionHandler(Result.success(result))
        }
        
        task.resume()
        
        return task
    }
}
