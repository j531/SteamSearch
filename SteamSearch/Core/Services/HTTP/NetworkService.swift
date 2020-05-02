//
//  NetworkService.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 09/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import Combine

struct NetworkService {
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func get<T: Decodable>(
        path: String,
        query: [String: String?]? = nil,
        mappingTo: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        guard let url = buildURL(path: path, query: query) else {
            fatalError("Can't build URL.")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .verify()
            .data()
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                switch error {

                case let error as NetworkError:
                    return error

                case _ as DecodingError:
                    return .decodingError

                default:
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }

    private func buildURL(path: String, query: [String: String?]? = nil) -> URL? {
        let urlWithPath = baseURL.appendingPathComponent(path)

        guard var urlComponents = URLComponents(url: urlWithPath, resolvingAgainstBaseURL: false) else {
            return nil
        }
        urlComponents.queryItems = query?.map(URLQueryItem.init(name:value:))
        
        return urlComponents.url
    }
}
