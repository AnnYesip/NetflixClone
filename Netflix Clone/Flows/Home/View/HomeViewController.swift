//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 14.08.2022.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private var randomTrandingMovie: Title?
    private var headerView: HeroHeaderUIView?
    weak var coordinator: TabCoordinator?
    let viewModel: HomeViewModelProtocol = HomeViewModel()
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(
            CollectionViewTableViewCell.self,
            forCellReuseIdentifier: CollectionViewTableViewCell.identifier
        )
        table.backgroundColor = .blackBackgroundColor
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configurateNavBar()
        configureHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    // MARK: - NavigationBar
    private func configurateNavBar() {
        var logoImage = UIImage(named: "netflixLogo")
        logoImage = logoImage?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: logoImage,
            style: .done,
            target: self,
            action: nil
        )
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "person"),
                style: .done,
                target: self,
                action: #selector(openProfile)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "play.rectangle"),
                style: .done,
                target: self,
                action: nil
            )
        ]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance.backgroundColor = .blackBackgroundColor
        navigationController?.navigationItem.hidesBackButton = false
        
    }
    
    // MARK: - Header View
    
    private func configureHeaderView() {
        headerView = HeroHeaderUIView(
            frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450)
        )
        homeFeedTable.tableHeaderView = headerView
        featchMoviewForHeagerView()
    }
    
    func featchMoviewForHeagerView() { 
        viewModel.featchMoviewForHeagerView { [weak self] result in
            switch result {
            case .success(let titles):
                let randomTitle = titles.randomElement()
                self?.randomTrandingMovie = randomTitle
                self?.headerView?.configure(
                    with: TitleViewModel(
                        posterURL: randomTitle?.poster_path ?? " ",
                        posterLabel: randomTitle?.original_title ?? " -- "
                    )
                )
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func openProfile() {
        coordinator?.showProfileViewController()
    }
    
    //MARK: - deinited
    deinit {
        print("\(self) deinited")
    }
}

// MARK: - extension
extension HomeViewController: CollectionViewTableViewCellProtocol {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, model: MovieDetailsModel) {
        DispatchQueue.main.async { [weak self] in
            self?.coordinator?.showMovieDetailViewController(viewModel: MovieDetailsViewModel(), model: model)
        }
        
    }
    
    
}
