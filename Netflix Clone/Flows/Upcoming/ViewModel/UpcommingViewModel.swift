//
//  UpcommingViewModel.swift
//  Netflix Clone
//
//  Created by mac on 29.01.2023.
//

import Foundation

protocol UpcommingViewModelProtocol {
    func featchMoviewForUpcomming(complition: @escaping (Result<[Title], Error>) -> Void)
}

final class UpcommingViewModel: UpcommingViewModelProtocol {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    func featchMoviewForUpcomming(
        complition: @escaping (Result<[Title], Error>
        ) -> Void) {
        networkManager.getMovies(for: .upcoming) { result in
            complition(result)
        }
    }
    
}
