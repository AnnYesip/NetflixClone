//
//  TabBarCoordinator.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 23.10.2022.
//

import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func showMovieDetailViewController(
        viewModel: MovieDetailsViewModel,
        model: MovieDetailsModel
    )
    
    func showProfileViewController()
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}

class TabCoordinator: NSObject, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
        
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController

    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = .whiteColor
        self.tabBarController = .init()
    }

    func start() {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.home, .upcoming, .search, .downloads]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    deinit {
        print("TabCoordinator deinit")
    }
    
    private func prepareTabBarController(
        withTabControllers tabControllers: [UIViewController]
    ) {
        /// Set delegate for UITabBarController
        tabBarController.delegate = self
        /// Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: true)
        /// Let set index
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        /// Styling
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = .whiteColor
        tabBarController.tabBar.barTintColor = .tabBarBlackColor
        /// In this step, we attach tabBarController to navigation controller associated with this coordanator
        navigationController.viewControllers = [tabBarController]
    }
      
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()

        navController.tabBarItem = UITabBarItem.init(
            title: page.pageTitleValue(),
            image: UIImage(systemName: page.pageTabBarImageName()),
            tag: page.pageOrderNumber()
        )
        navController.navigationItem.hidesBackButton = false
        

        switch page {
        case .home:
            // If needed: Each tab bar flow can have it's own Coordinator.
            let homeVC = HomeViewController()
            homeVC.coordinator = self
            navController.pushViewController(homeVC, animated: true)
        case .upcoming:
            let upcomingVC = UpcomingViewController()
            upcomingVC.coordinator = self
            navController.pushViewController(upcomingVC, animated: true)
        case .search:
            let searchVC = SearchViewController()
            searchVC.coordinator = self
            navController.pushViewController(searchVC, animated: true)
            
        case .downloads:
            let downloadVC = DownloadsViewController()
            downloadVC.coordinator = self
            navController.pushViewController(downloadVC, animated: true)
        }
        
        return navController
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func showMovieDetailViewController(
        viewModel: MovieDetailsViewModel,
        model: MovieDetailsModel
    ) {
        let detailVC = MovieDetailsViewController(viewModel: viewModel, model: model)
        detailVC.coordinator = self
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    
    func showProfileViewController() {
        let detailVC = ProfileViewController()
        detailVC.coordinator = self
        navigationController.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
    }
}
