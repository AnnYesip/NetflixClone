//
//  SearchResultViewController.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 27.09.2022.
//

import UIKit

final class SearchResultViewController: UIViewController {
    weak var coordinator: TabCoordinator?
    var titles: [Title] = [Title]()
    
    let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width / 3.2,
            height: 200
        )
        layout.minimumInteritemSpacing = 5
        let resultCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        resultCollectionView.register(
            TitleCollectionViewCell.self,
            forCellWithReuseIdentifier: TitleCollectionViewCell.identifier
        )
        resultCollectionView.backgroundColor = .blackBackgroundColor
        return resultCollectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultCollectionView)
        view.backgroundColor = .blackBackgroundColor
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
}
