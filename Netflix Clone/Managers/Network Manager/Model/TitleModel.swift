//
//  MovieModel.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 18.08.2022.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    
    let id: Int
    let media_type: String?
    let name: String?
    let origin_country: [String]?
    let original_language: String?
    let original_name: String?
    let original_title: String?
    let overview: String?
    let popularity: Double
    let poster_path: String?
    let vote_average: Float?
    let vote_count: Int
    
    
}
