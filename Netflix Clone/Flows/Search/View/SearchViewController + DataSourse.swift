//
//  SearchViewController + DataSourse.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 18.09.2022.
//

import UIKit

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UpcomingTableViewCell.identifier,
            for: indexPath
        ) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(
            with: TitleViewModel(
                posterURL: title.poster_path ?? " ------- ",
                posterLabel: title.original_title ?? " ---- "
            )
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        
        let model = MovieDetailsModel(
            id: title.id,
            title: titleName,
            titleOverView: title.overview ?? " "
        )
        coordinator?.showMovieDetailViewController(viewModel: MovieDetailsViewModel(), model: model)
    }
    
}
