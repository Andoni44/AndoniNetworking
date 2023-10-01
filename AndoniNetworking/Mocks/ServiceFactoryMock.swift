//
//  ServiceFactoryMock.swift
//  AndoniNetworking
//
//  Created by Andoni Da silva on 1/10/23.
//

import Foundation

public final class ServiceFactoryMock: ServiceFactoryProtocol {
    public var session: URLSessionProtocol
    public var getDataCalled: Bool = false
    public var dataToReturn: DataEntity? = nil
    public var errorToThrow: Error? = nil

    public init(session: URLSessionProtocol = FakeSession()) {
        self.session = session
    }

    public func getData<T: DataEntity>(fromEndPoint endPoint: EndPoint) async throws -> T {
        getDataCalled = true

        if let error = errorToThrow {
            throw error
        }

        if let data = dataToReturn as? T {
            return data
        }

        fatalError("Mock return data is not set")
    }
}
