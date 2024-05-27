//
//  APIGateway.swift
//  LocationsCore
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Combine
import Foundation

protocol APIGateway {
    func fetchData(from url: URL) -> AnyPublisher<Data, Error>
}

final class URLSessionAPIGateway: APIGateway {
    // MARK: - Properties
    
    private let urlSession: URLSessionProtocol
    
    // MARK: - Initializer
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    // MARK: - APIGateway
    
    func fetchData(from url: URL) -> AnyPublisher<Data, Error> {
        return urlSession.abstractDataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

protocol URLSessionProtocol {
    func abstractDataTaskPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSession: URLSessionProtocol {
    func abstractDataTaskPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return dataTaskPublisher(for: url).eraseToAnyPublisher()
    }
}
