//
//  TMDBClient.swift
//  TMDBDemo
//
//  Created by Captain on 4/14/19.
//  Copyright © 2019 Captain. All rights reserved.
//

import Foundation

enum QueryType: String {
    case now_playing
    case popular
    case upcoming
    case top_rated
}

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}

enum DataResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self
        {
            case .network:
                return "An error occurred while fetching data"
            case .decoding:
                return "An error occurred while decoding data"
        }
    }
}

struct APIResponse: Decodable {
    let movies: [Movie]
    let total_pages: Int
    let total_results: Int
    let page: Int
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case total_results
        case total_pages
        case page
    }
}

final class TMDBClient {
    
    let baseURL = URL(string: "https://api.themoviedb.org/3/movie/")
    var params = ["api_key":"f10d44638c115f51bea8135f4bd998b1", "region":"US"]
    let query_type: QueryType
    let session: URLSession
    
    init (query_type: QueryType)
    {
        self.query_type = query_type
        self.session = URLSession.shared
    }
    
    func getMovieData(page: Int, completion: @escaping (Result<APIResponse, DataResponseError>) -> Void)
    {
        params["page"] = "\(page)"
        var components = URLComponents(url: (baseURL?.appendingPathComponent(query_type.rawValue))!, resolvingAgainstBaseURL: false)!
        let queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        components.queryItems = queryItems
        
        session.dataTask(with: components.url!, completionHandler: { data, response, error in
            guard error == nil, let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode, let data = data
                else {
                    completion(Result.failure(DataResponseError.network))
                    return
            }
            guard let decodedResponse = try? JSONDecoder().decode(APIResponse.self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            completion(Result.success(decodedResponse))
            
        }).resume()
    }
}

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
