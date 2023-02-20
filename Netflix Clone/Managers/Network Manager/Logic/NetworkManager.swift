//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 18.08.2022.
//

import Foundation
import Alamofire

struct Constant {
    static let API_key = "d4002f7f35e936fa688a9feadd46d8e3"
    static let baseURL = "https://api.themoviedb.org"
    static let youtubeAPI_KEY = "AIzaSyCiAupocmtUNTOxLCvFy54ExTg8foo1L3M"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum NetworkManagerError: Error {
    case failedToGetData
}

enum MovieSection: CaseIterable {
    case movie
    case tv
    case upcoming
    case popular
    case top_rated
    case discover
    
    var name: String {
        switch self {
        case .movie:
            return "trending/movie/day"
        case .tv:
            return "trending/tv/day"
        case .upcoming:
            return "movie/upcoming"
        case .popular:
            return "movie/popular"
        case .top_rated:
            return "movie/top_rated"
        case .discover:
            return "discover/movie"
        }
        
    }
    
    var sectionNumder: Int {
        switch self {
        case .movie:
            return 0
        case .tv:
            return 1
        case .upcoming:
            return 2
        case .popular:
            return 3
        case .top_rated:
            return 4
        case .discover:
            return 5
        }
    }
    
}

protocol NetworkManagerProtocol {
    
    func getMovies(for section: MovieSection, complition: @escaping (Result<[Title], Error>) -> Void)
    func getMovieDetails(id: Int, complition: @escaping (Result<MovieDetails, Error>) -> Void)
    func search(with query: String, complition: @escaping (Result<[Title], Error>) -> Void)
    func getMovieTrailer(with query: String, complition: @escaping (Result<VideoElement, Error>) -> Void)
    
}

final class NetworkManager: NetworkManagerProtocol {
    private let queue = DispatchQueue(label: "download_queue", qos: .utility)
    static let shared = NetworkManager()
    
    func getMovies(for section: MovieSection, complition: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(
            string: "\(Constant.baseURL)/3/\(section.name)?api_key=\(Constant.API_key)"
        ) else {
            return
        }
        
        queue.async {
            AF.request(url)
                .responseData { response in
                    guard let data = response.data else { return }
                    if let result = try? JSONDecoder().decode(TrendingTitleResponse.self, from: data) {
                        complition(.success(result.results))
                    } else {
                        complition(.failure(NetworkManagerError.failedToGetData))
                    }
                }
        }
    }

    func getMovieDetails(id: Int, complition: @escaping (Result<MovieDetails, Error>) -> Void) {
        guard let url = URL(
            string:
            "\(Constant.baseURL)/3/movie/\(id)?api_key=\(Constant.API_key)&language=en-US"
        ) else { return }
        
        queue.async {
            AF.request(url)
                .responseData { response in
                    guard let data = response.data else { return }
                    if let result = try? JSONDecoder().decode(MovieDetails.self, from: data) {
                        complition(.success(result))
                    } else {
                        complition(.failure(NetworkManagerError.failedToGetData))
                    }
                }
        }
    }
    
    func search(with query: String, complition: @escaping (Result<[Title], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(
            withAllowedCharacters: .urlHostAllowed
        ) else { return }
        guard let url = URL(
            string: "\(Constant.baseURL)/3/search/movie?api_key=\(Constant.API_key)&query=\(query)"
        ) else { return }
        
        queue.async {
            AF.request(url)
                .responseData { response in
                    guard let data = response.data else { return }
                    if let result = try? JSONDecoder().decode(TrendingTitleResponse.self, from: data) {
                        complition(.success(result.results))
                    } else {
                        complition(.failure(NetworkManagerError.failedToGetData))
                    }
                }
        }
    }
    
    func getMovieTrailer(with query: String, complition: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(
            withAllowedCharacters: .urlHostAllowed
        ) else { return }
        
        guard let url = URL(
            string: "\(Constant.youtubeBaseURL)q=\(query)&key=\(Constant.youtubeAPI_KEY)"
        ) else { return }
    
        queue.async {
            AF.request(url)
                .responseData { response in
                    guard let data = response.data else { return }
                    if let result = try? JSONDecoder().decode(YouTubeSearchResponse.self, from: data) {
                        complition(.success(result.items[0]))
                    } else {
                        complition(.failure(NetworkManagerError.failedToGetData))
                    }
                }
        }
    }
    
    
}




