//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 14.08.2022.
//

import UIKit

final class UpcomingViewController: UIViewController {
    weak var coordinator: TabCoordinator?
    var titles: [Title] = [Title]()
    private let viewModel: UpcommingViewModelProtocol = UpcommingViewModel()
    
    private var upcomingTable: UITableView = {
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
        configurateNavBar()
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        fetchUpcommingMovie()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }

    // MARK: - NavigationBar
    private func configurateNavBar() {
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationController?.navigationBar.barTintColor = .blackBackgroundColor

        navigationController?.navigationBar.largeTitleTextAttributes = [ .foregroundColor: UIColor.whiteColor]
        navigationController?.navigationBar.titleTextAttributes = [ .foregroundColor: UIColor.whiteColor]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationItem.hidesBackButton = false
        
    }

    func fetchUpcommingMovie() {
        viewModel.featchMoviewForUpcomming { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async { [weak self] in
                    self?.upcomingTable.reloadData()
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
