//
//  Request.swift
//  AndoniNetworking
//
//  Created by Andoni Da silva on 25/9/23.
//

import Foundation

public protocol URLSessionProtocol {
    func data(for: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

// MARK: - Service factory
/// Decouple session from URLSession
public protocol ServiceFactoryProtocol {
    var session: URLSessionProtocol { get set }

    func getData<T: DataEntity>(fromEndPoint endPoint: EndPoint) async throws -> T
}


public struct ServiceFactory: ServiceFactoryProtocol {
    public var session: URLSessionProtocol

    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    public  func getData<T: DataEntity>(fromEndPoint endPoint: EndPoint) async throws -> T {
        guard let request = generateRequest(fromEndpoint: endPoint) else {
            throw HTTPError.badRequest
        }

        let response = try await session.data(for: request)

        let result = try JSONDecoder().decode(T.self, from: response.0)

        return result
    }
}

// MARK: - Get request
private extension ServiceFactory {
    func generateRequest(fromEndpoint endpoint: EndPoint) -> URLRequest? {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.urlBase
        components.path = endpoint.path

        components.queryItems = endpoint.parametersUrl

        guard let url = components.url else { return nil }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = endpoint.body

        endpoint.headers.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        guard let contentType = endpoint.contentType else { return urlRequest }

        if case .json = contentType {
            urlRequest.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }

        return urlRequest
    }
}

public typealias DataEntity = Codable
