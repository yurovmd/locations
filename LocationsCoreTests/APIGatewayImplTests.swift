//
//  APIGatewayImplTests.swift
//  LocationsCoreTests
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import XCTest
import Combine
@testable import LocationsCore

final class URLSessionAPIGatewayTests: XCTestCase {
    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable>!
    private var mockURLSession: MockURLSession!
    private var apiGateway: URLSessionAPIGateway!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockURLSession = MockURLSession()
        apiGateway = URLSessionAPIGateway(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        cancellables = nil
        mockURLSession = nil
        apiGateway = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchDataSuccess() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com"))
        let data = try XCTUnwrap("Test data".data(using: .utf8))
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: data.count, textEncodingName: nil)
        mockURLSession.result = .success((data: data, response: response))
        let expectation = self.expectation(description: "fetchData completes")
        var receivedData: Data?
        var receivedError: Error?
        apiGateway.fetchData(from: url)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { data in
                receivedData = data
            })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertNotNil(receivedData)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedData, data)
    }
    
    func testFetchDataFailure() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com"))
        let error = URLError(.notConnectedToInternet)
        mockURLSession.result = .failure(error)
        let expectation = self.expectation(description: "fetchData completes")
        var receivedData: Data?
        var receivedError: Error?
        apiGateway.fetchData(from: url)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { data in
                receivedData = data
            })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertNil(receivedData)
        XCTAssertNotNil(receivedError)
        XCTAssertEqual((receivedError as? URLError)?.code, error.code)
    }
}
