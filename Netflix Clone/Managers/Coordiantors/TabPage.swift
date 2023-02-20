//
//  TabCoordiantor.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 23.10.2022.
//
import Foundation

enum TabBarPage {
    case home
    case upcoming
    case search
    case downloads

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .upcoming
        case 2:
            self = .search
        case 3:
            self = .downloads
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "Home"
        case .upcoming:
            return "Coming Soon"
        case .search:
            return "Top Search"
        case .downloads:
            return "Downloads"
        }
    }
    
    func pageTabBarImageName() -> String {
        switch self {
        case .home:
            return "house"
        case .upcoming:
            return "play.circle"
        case .search:
            return "magnifyingglass"
        case .downloads:
            return "arrow.down.to.line"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .upcoming:
            return 1
        case .search:
            return 2
        case .downloads:
            return 3
        }
    }
    
}
