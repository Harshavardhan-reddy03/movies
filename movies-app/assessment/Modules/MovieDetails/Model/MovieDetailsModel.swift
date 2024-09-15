//
//  MovieDetailsModel.swift
//  assessment
//
//  Created by Harsha on 09/09/24.
//

import Foundation

struct MovieDetailsModel:Codable{
    let genre:String
    let description:String
    let ratings : [RatingModel]
    enum CodingKeys: String, CodingKey {
        case genre = "Genre"
        case description = "Plot"
        case ratings = "Ratings"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        genre = try container.decode(String.self, forKey: .genre)
        description = try container.decode(String.self, forKey: .description)
        ratings = try container.decode([RatingModel].self, forKey: .ratings)
    }
}
struct RatingModel:Codable{
    let source:String
    let value:String
    enum CodingKeys: String, CodingKey{
        case source = "Source"
        case value = "Value"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source = try container.decode(String.self, forKey: .source)
        value = try container.decode(String.self, forKey: .value)
    }
}
