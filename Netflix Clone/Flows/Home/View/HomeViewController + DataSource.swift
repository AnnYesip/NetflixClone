//
//  HomeViewController + DataSource.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 16.08.2022.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionViewTableViewCell.identifier,
            for: indexPath
        ) as? CollectionViewTableViewCell else { return UITableViewCell()  }
        
        cell.delegate = self
        let section = indexPath.section
        
        let currentСategory = MovieSection.allCases.first { $0.sectionNumder == section }
        
        guard let currentСategory = currentСategory else { return UITableViewCell() }
        
        viewModel.getMovies(for: currentСategory) { result in
            switch result {
            case .success(let titles):
                cell.configure(with: titles)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
       
        return cell
                                                
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(
            x: header.bounds.origin.x + 20 ,
            y: header.bounds.origin.y,
            width: 100,
            height: header.bounds.height
        )
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitle[section]
    }
    
    
}
