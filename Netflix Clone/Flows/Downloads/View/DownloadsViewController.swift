//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 14.08.2022.
//

import UIKit

final class DownloadsViewController: UIViewController {
    weak var coordinator: TabCoordinator?
    var titles: [Movie] = [Movie]()
    private let viewModel: DownloadsViewModelProtocol = DownloadsViewModel()
    
    private var downloadsTable: UITableView = {
        let table = UITableView()
        table.register(
            UpcomingTableViewCell.self,
            forCellReuseIdentifier: UpcomingTableViewCell.identifier
        )
        table.backgroundColor = .blackBackgroundColor
        table.separatorStyle = .singleLine
        table.separatorColor = .lightGray
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blackBackgroundColor
        configurateNavBar()
        view.addSubview(downloadsTable)
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
        fetchLocalStorageFowDownloads()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("downloaded"),
            object: nil,
            queue: nil) { _ in
                self.fetchLocalStorageFowDownloads()
            }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTable.frame = view.bounds
    }
    
    // MARK: - NavigationBar
    private func configurateNavBar() {
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationController?.navigationBar.barTintColor = .blackBackgroundColor

        navigationController?.navigationBar.largeTitleTextAttributes = [ .foregroundColor: UIColor.whiteColor]
        navigationController?.navigationBar.titleTextAttributes = [ .foregroundColor: UIColor.whiteColor]
        
 
        navigationController?.navigationItem.hidesBackButton = false
        
    }
    
    // MARK: - fetch data
    private func fetchLocalStorageFowDownloads() {
        viewModel.fetchLocalStorageFowDownloads { [weak self] result in
            switch result {
            case .success(let success):
                self?.titles = success
                DispatchQueue.main.async {
                    self?.downloadsTable.reloadData()
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
