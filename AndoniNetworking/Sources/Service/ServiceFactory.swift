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

/**
 `ServiceFactoryProtocol` is an abstraction for services responsible for network data fetching.

 This protocol defines a contract for fetching data from an API endpoint and can be used to implement concrete services or mocks for testing.

 - Properties:
 - `session`: An object conforming to `URLSessionProtocol`, responsible for executing the actual network requests.

 - Methods:
 - `getData(fromEndPoint:)`: Asynchronously fetches data from a given endpoint and decodes it into the specified data entity.

 - Parameters for methods:
 - `endPoint`: The `EndPoint` object defining the API endpoint to fetch data from.
 */
public protocol ServiceFactoryProtocol {
    var session: URLSessionProtocol { get set }

    func getData<T: DataEntity>(fromEndPoint endPoint: EndPoint) async throws -> T
}

/**
 `ServiceFactory` is a concrete implementation of the `ServiceFactoryProtocol`.

 It utilizes the provided session (or the default URLSession) to fetch data from an API endpoint and decodes it into the specified data entity.

 - Properties:
 - `session`: An object conforming to `URLSessionProtocol`, responsible for executing the actual network requests.

 - Initialization:
 - `init(session:)`: Initializes the `ServiceFactory` with a given session. If no session is provided, the default `URLSession.shared` is used.

 - Methods:
 - `getData(fromEndPoint:)`: Asynchronously fetches data from a given endpoint, decodes it into the specified data entity, and returns the decoded object. Throws appropriate errors for invalid requests or decoding issues.
 */
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
