//
//  FakeURLSession.swift
//  AndoniNetworkingTests
//
//  Created by Andoni Da silva on 28/9/23.
//

import Foundation

@testable import AndoniNetworking

final class FakeSession: URLSessionProtocol {
    var data: Data?
    var fakeResponse: URLResponse?
    var error: Error?
    var generatedRequest: URLRequest?

    func data(for: URLRequest) async throws -> (Data, URLResponse) {
        if let error {
            throw error
        }

        guard let data, let fakeResponse else {
            return (Data(), URLResponse())
        }

        return (data, fakeResponse)
    }
}

enum FakeEndpoint: EndPoint {
    case fakeAPI(FakeDTO)

    var scheme: String {
        "https"
    }

    var urlBase: String {
        "www.fake.com"
    }

    var path: String {
        "/fake-path"
    }

    var method: AndoniNetworking.HTTPMethod {
        .GET
    }

    var parametersUrl: [URLQueryItem]? {
        nil
    }

    var body: Data? {
        guard case .json = contentType else { return nil }

        if case .fakeAPI(let dto) = self {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return try! encoder.encode(dto)
        } else {
            return nil
        }
    }

    var contentType: AndoniNetworking.ContentType? {
        .json
    }

    var headers: [String : String] {
        [: ]
    }
}
