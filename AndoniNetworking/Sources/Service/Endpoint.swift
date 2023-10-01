//
//  Service.swift
//  AndoniNetworking
//
//  Created by Andoni Da silva on 25/9/23.
//

import Foundation

/**
 An `EndPoint` protocol provides a structured representation for defining API endpoints.
 This protocol abstracts out all the required and optional components needed to form a network request.

 - Properties:
 - `scheme`: Represents the URL scheme, usually either "http" or "https".
 - `urlBase`: The base URL or domain of the API.
 - `path`: The path to a specific resource or endpoint. For example: "/users".
 - `method`: HTTP method to be used for the request. Defined by `HTTPMethod`.
 - `parametersUrl`: An array of URL query items to be added as parameters in the request URL.
 - `body`: Optional data payload for the request. Typically used for `POST`, `PUT`, etc.
 - `contentType`: The content type of the request. Defined by `ContentType`.
 - `headers`: A dictionary containing any additional headers to be set for the request.
 */
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

/**
 `ContentType` is an enumeration that lists common content types used in API requests and responses.
 These content types are used in the HTTP headers to indicate the nature of the request or response data.

 - Case:
 - `json`: Represents the MIME type for JSON (JavaScript Object Notation) data format. Commonly used for sending and receiving data in web applications.
 */
public enum ContentType: String {
    case json = "application/json"
}
