//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 14.08.2022.
//

import UIKit

final class SearchViewController: UIViewController {
    weak var coordinator: TabCoordinator?
    var titles: [Title] = [Title]()
    let viewModel: SearchViewModelProtocol = SearchViewModel()
    
    private var discoverTable: UITableView = {
        let table = UITableView()
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        table.backgroundColor = .blackBackgroundColor
        return table
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(
            searchResultsController: SearchResultViewController()
        )
        searchController.searchBar.placeholder = "Search for Movie or a TV show"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barStyle = .black
        return searchController
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blackBackgroundColor
        configurateNavBar()
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        fetchDiscoverMoview()
        
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    // MARK: - NavigationBar
    private func configurateNavBar() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.barTintColor = .blackBackgroundColor
        navigationController?.navigationBar.tintColor = .blackBackgroundColor
        navigationController?.navigationBar.largeTitleTextAttributes = [ .foregroundColor: UIColor.whiteColor]
        navigationController?.navigationBar.titleTextAttributes = [ .foregroundColor: UIColor.whiteColor]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationItem.hidesBackButton = false
        
    }
    
    // MARK: - fetchDiscoverMoview
    func fetchDiscoverMoview() {
        viewModel.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    //MARK: - deinited
    deinit {
        print("\(self) deinited")
    }
    
}


extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else { return }
        viewModel.search(query: query) { result in
            //            DispatchQueue.main.async {
            switch result {
            case .success(let title):
                resultController.titles = title
                DispatchQueue.main.async {
                    resultController.searchResultCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            //            }
        }
    }
    
}
