//
//  MoviesViewController.swift
//  Jutsu
//
//  Created by Rasul Turumov on 15.12.2025.
//

import UIKit

final class MoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var categories: [AnimeCategoryViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        loadFromAPI()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }


    private func loadFromAPI() {
        AnimeAPI.shared.fetchTopMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.buildCategories(from: movies)

            case .failure(let error):
                print("Movies API error:", error)
            }
        }
    }

    private func buildCategories(from movies: [Anime]) {
        guard !movies.isEmpty else { return }

        let titles = [
            "Popular",
            "Trending",
            "Top Rated",
            "New Releases",
            "Action",
            "Drama",
            "Fantasy"
        ]

        let itemsPerCategory = 10
        let total = movies.count

        categories = titles.enumerated().map { index, title in
            let offset = (index * 3) % total

            let rotated = Array(movies[offset...] + movies[..<offset])

            let shuffled = rotated.shuffled()

            return AnimeCategoryViewModel(
                title: title,
                items: Array(shuffled.prefix(itemsPerCategory))
            )
        }

        tableView.reloadData()
    }
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        235
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CategoryRowCell",
            for: indexPath
        ) as! CategoryRowCell

        cell.configure(category: categories[indexPath.section])
        return cell
    }
}
