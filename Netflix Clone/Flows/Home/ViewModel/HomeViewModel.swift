//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by mac on 29.01.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var sectionTitle: [String] { get }
    func featchMoviewForHeagerView(complition: @escaping (Result<[Title], Error>) -> Void)
    func getMovies(for categori: MovieSection, complition: @escaping (Result<[Title], Error>) -> Void)
}

final class HomeViewModel: HomeViewModelProtocol {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    let sectionTitle = ["Trending Movies", "Trending TV",
                        "Popular", "Upcoming Movies", "Top Rated"]
    
    func featchMoviewForHeagerView(
        complition: @escaping (Result<[Title], Error>
        ) -> Void) {
        networkManager.getMovies(for: .movie) { result in
            complition(result)
        }
    }
    
    func getMovies(for categori: MovieSection, complition: @escaping (Result<[Title], Error>) -> Void) {
        networkManager.getMovies(for: categori) { result in
            complition(result)
        }
    }
    
}



