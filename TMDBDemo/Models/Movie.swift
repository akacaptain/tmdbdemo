//
//  Movie.swift
//  TMDBDemo
//
//  Created by Captain on 4/14/19.
//  Copyright © 2019 Captain. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let title: String
    let overview: String
    let poster_path: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case poster_path
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        poster_path = try container.decode(String.self, forKey: .poster_path)
    }
    
}

