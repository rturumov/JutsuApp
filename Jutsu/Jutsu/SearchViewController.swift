//
//  SearchViewController.swift
//  Jutsu
//
//  Created by Rasul Turumov on 15.12.2025.
//

import UIKit

final class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!

    private var results: [Anime] = []

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearch()
        setupCollectionView()
    }

    private func setupSearch() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search anime"

        definesPresentationContext = true
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag
    }

    private func performSearch(query: String) {
        AnimeAPI.shared.searchAnime(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let anime):
                    self?.results = anime
                    self?.collectionView.reloadData()

                case .failure(let error):
                    print("❌ Search error:", error)
                }
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              query.count >= 2 else {
            results = []
            collectionView.reloadData()
            return
        }

        performSearch(query: query)
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        hideTitleInstant()
    }

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if searchText.isEmpty {
            showTitleAnimated()
        } else {
            hideTitleInstant()
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == true {
            showTitleAnimated()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        showTitleAnimated()
    }

    private func hideTitleInstant() {
        titleLabel.alpha = 0
    }

    private func showTitleAnimated() {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseInOut, .beginFromCurrentState],
            animations: {
                self.titleLabel.alpha = 1
            }
        )
    }
}

extension SearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        results.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "AnimePosterCell",
            for: indexPath
        ) as! AnimePosterCell

        cell.configure(with: results[indexPath.item])
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let columns: CGFloat = 2
        let spacing: CGFloat = 12
        let horizontalInsets: CGFloat = 32

        let totalSpacing = (columns - 1) * spacing + horizontalInsets
        let width = (collectionView.bounds.width - totalSpacing) / columns

        return CGSize(width: width, height: width * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        12
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
    }
}
