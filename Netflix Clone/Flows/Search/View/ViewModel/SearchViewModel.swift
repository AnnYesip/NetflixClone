//
//  SearchViewModel.swift
//  Netflix Clone
//
//  Created by mac on 29.01.2023.
//

import Foundation

protocol SearchViewModelProtocol {
    func getDiscoverMovies(complition: @escaping (Result<[Title], Error>) -> Void)
    func search(query: String, complition: @escaping (Result<[Title], Error>) -> Void)
}

final class SearchViewModel: SearchViewModelProtocol {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    func getDiscoverMovies(
        complition: @escaping (Result<[Title], Error>
        ) -> Void) {
        networkManager.getMovies(for: .discover, complition: { result in
            complition(result)
        })
    }
    
    func search(query: String, complition: @escaping (Result<[Title], Error>) -> Void) {
        networkManager.search(with: query) { result in
            complition(result)
        }
    }
    
}
