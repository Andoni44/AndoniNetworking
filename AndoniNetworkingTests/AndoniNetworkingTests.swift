//
//  AndoniNetworkingTests.swift
//  AndoniNetworkingTests
//
//  Created by Andoni Da silva on 25/9/23.
//

import XCTest
@testable import AndoniNetworking

final class ServiceFactoryTests: XCTestCase {
    var sut: ServiceFactory!

    override func setUp() {
        super.setUp()
        sut = ServiceFactory(session: FakeSession())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testGenerateRequest() {
        XCTAssertNotNil(sut)
    }

    func testGetDataSuccess() async throws {
        let mockData = "{\"name\":\"I am a fake DTO\"}".data(using: .utf8)!
        let mockResponse = URLResponse()
        let mockSession = FakeSession()
        mockSession.data = mockData
        mockSession.fakeResponse = mockResponse

        let serviceFactory = ServiceFactory(session: mockSession)

        let result: FakeDTO = try await serviceFactory.getData(fromEndPoint: FakeEndpoint.fakeAPI(FakeDTO()))

        XCTAssertEqual(result.name, "I am a fake DTO")
    }

    func testGetDataFailure() async throws {
        let mockData = "{\"name\":\"I am a fake DTO\"}".data(using: .utf8)!
        let mockResponse = URLResponse()
        let mockSession = FakeSession()
        mockSession.data = mockData
        mockSession.fakeResponse = mockResponse
        mockSession.error = HTTPError.badRequest

        let serviceFactory = ServiceFactory(session: mockSession)

        do {
            let _: FakeDTO = try await serviceFactory.getData(fromEndPoint: FakeEndpoint.fakeAPI(FakeDTO()))
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertEqual(error as? HTTPError, HTTPError.badRequest)
        }
    }
}
