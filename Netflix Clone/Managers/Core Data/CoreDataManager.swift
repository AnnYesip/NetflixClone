//
//  CoreDataManager.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 03.10.2022.
//

import UIKit
import CoreData

protocol CoreDataManagerProtocol {
    func downloadMovie(with model: Title, completion: @escaping(Result<Void, Error>) -> Void)
    func fetchingMovieFromDataBase(complition: @escaping (Result<[Movie], Error>) -> Void)
    func deleteMovieFromDataBase(movie: Movie ,complition: @escaping (Result<Void, Error>) -> Void)
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    enum DataBaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = CoreDataManager()
    
    func downloadMovie(with model: Title, completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let contex = appDelegate.persistentContainer.viewContext
        
        let item = Movie(context: contex)
        
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.name = model.name
        item.origin_country = model.origin_country?.first
        item.original_language = model.original_language
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.overview = model.overview
        item.popularity = model.popularity
        item.poster_path = model.poster_path
        item.vote_average = model.vote_average ?? 0
        item.vote_count = Int64(model.vote_count)
        
        do {
            try contex.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    func fetchingMovieFromDataBase(complition: @escaping (Result<[Movie], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let contex = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Movie>
        
        request = Movie.fetchRequest()
        
        do {
            let movies = try contex.fetch(request)
            complition(.success(movies))
        } catch  {
            complition(.failure(DataBaseError.failedToFetchData))
        }
    }
    
    func deleteMovieFromDataBase(movie: Movie ,complition: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let contex = appDelegate.persistentContainer.viewContext
        
        contex.delete(movie)
        
        do {
            try contex.save()
            complition(.success(()))
        } catch {
            complition(.failure(DataBaseError.failedToDeleteData))
        }
    }
}
