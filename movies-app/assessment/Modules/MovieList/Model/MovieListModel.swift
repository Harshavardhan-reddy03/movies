//
//  MovieListModel.swift
//  assessment
//
//  Created by Harsha on 05/09/24.
//

import Foundation

struct MovieListModel:Codable{
    let totalResults: String
    var Search:[MovieModel]
    let Response:String
}
struct MovieModel:Codable{
    let id:String
    let title:String
    let posterImage:String
    let releaseYear:String
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case posterImage = "Poster"
        case releaseYear = "Year"
        case id = "imdbID"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decode(String.self, forKey: .title)
        posterImage = try container.decode(String.self, forKey: .posterImage)
        releaseYear = try container.decode(String.self, forKey: .releaseYear)
        id = try container.decode(String.self, forKey: .id)
    }
}

