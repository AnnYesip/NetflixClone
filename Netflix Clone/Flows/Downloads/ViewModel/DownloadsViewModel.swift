//
//  DownloadsViewModel.swift
//  Netflix Clone
//
//  Created by mac on 29.01.2023.
//

import Foundation

protocol DownloadsViewModelProtocol {
    func fetchLocalStorageFowDownloads(complition: @escaping (Result<[Movie], Error>) -> Void)
}

final class DownloadsViewModel: DownloadsViewModelProtocol {
    
    private let coreDataManager: CoreDataManagerProtocol = CoreDataManager()
    
    func fetchLocalStorageFowDownloads(
        complition: @escaping (Result<[Movie], Error>
        ) -> Void) {
        coreDataManager.fetchingMovieFromDataBase(complition: { result in
            complition(result)
        })
    }
    
 
    
}
