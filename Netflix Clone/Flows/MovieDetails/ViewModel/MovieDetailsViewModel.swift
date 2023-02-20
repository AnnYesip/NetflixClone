//
//  MovieDetailsViewModel.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 12.10.2022.
//

import Foundation

protocol MovieDetailsViewModelProtocol {
    func fetchMovieDetails(id: Int, complition: @escaping (Result<MovieDetails, Error>) -> Void)
    func searchTrailer(movie name: String, complition: @escaping (Result<URL, Error>) -> Void)
}

final class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    //MARK: - fetchMovieDetails
    func fetchMovieDetails(
        id: Int,
        complition: @escaping (Result<MovieDetails, Error>
        ) -> Void) {
        networkManager.getMovieDetails(id: id) { result in
            switch result {
            case .success(let title):
                print(title)
                complition(.success(title))
            case .failure(let error):
                print(error.localizedDescription)
                complition(.failure(error))
            }
        }
    }
    
    //MARK: - fetch Movie trailer
    func searchTrailer(
        movie name: String,
        complition: @escaping (Result<URL, Error>
        ) -> Void) {
        
        networkManager.getMovieTrailer(with: name + " trailer") { result in
            switch result {
            case .success(let videoElement):
                guard let url = URL(
                    string: "https://www.youtube.com/embed/\(videoElement.id.videoId)"
                ) else { return }

                complition(.success(url))
                
            case .failure(let error):
                print(error.localizedDescription)
                complition(.failure(error))
            }
        }
        
        
    }
    
    
}
