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
    
    private let homeFilmsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(
            HomeViewTableViewCell.self,
            forCellReuseIdentifier: HomeViewTableViewCell.identifier
        )
        table.backgroundColor = .blackBackgroundColor
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeFilmsTableView)
        
        homeFilmsTableView.delegate = self
        homeFilmsTableView.dataSource = self
        
        configurateNavBar()
        configureHeaderView()
        // TODO: check internet connection
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFilmsTableView.frame = view.bounds
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
    }
    
    private func setupHeaderBackground(navColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = navColor
        appearance.shadowColor = .clear
        appearance.backgroundEffect = UIBlurEffect(style: .dark)
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    // MARK: - Header View
    
    private func configureHeaderView() {
        headerView = HeroHeaderUIView(
            frame: CGRect(x: 0, y: -50, width: view.bounds.width, height: 500)
        )
        homeFilmsTableView.tableHeaderView = headerView
        featchMoviewForHeagerView()
    }
    
    func featchMoviewForHeagerView() { 
        viewModel.featchMoviewForHeagerView { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let titles):
                let randomTitle = titles.randomElement()
                self.randomTrandingMovie = randomTitle
                self.headerView?.configure(
                    with: TitleViewModel(
                        posterURL: randomTitle?.poster_path ?? " ",
                        posterLabel: randomTitle?.original_title ?? " -- "
                    ), complition: { result in
                        switch result {
                        case .success(let navColor):
                            self.setupHeaderBackground(navColor: navColor)
                        case .failure(let failure):
                            print(failure)
                        }
                    }
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
    func collectionViewTableViewCellDidTapCell(_ cell: HomeViewTableViewCell, model: MovieDetailsModel) {
        DispatchQueue.main.async { [weak self] in
            self?.coordinator?.showMovieDetailViewController(viewModel: MovieDetailsViewModel(), model: model)
        }
        
    }
    
    
}
