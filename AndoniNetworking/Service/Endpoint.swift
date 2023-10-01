//
//  Service.swift
//  AndoniNetworking
//
//  Created by Andoni Da silva on 25/9/23.
//

import Foundation

public protocol EndPoint {
    var scheme: String { get }
    var urlBase: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parametersUrl: [URLQueryItem]? { get }
    var body: Data? { get }
    var contentType: ContentType? { get }
    var headers: [String: String] { get }
}

public enum ContentType: String {
    case json = "application/json"
}
