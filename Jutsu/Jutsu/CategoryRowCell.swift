//
//  MoviesCategoryCell.swift
//  Jutsu
//
//  Created by Rasul Turumov on 17.12.2025.
//

import UIKit

final class CategoryRowCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private var items: [Anime] = []

        override func awakeFromNib() {
            super.awakeFromNib()
            setupCollection()
        }

        private func setupCollection() {
            collectionView.dataSource = self
            collectionView.delegate = self

            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.minimumLineSpacing = 12
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
            }
        }

        func configure(category: AnimeCategoryViewModel) {
            titleLabel.text = category.title
            items = category.items
            collectionView.reloadData()
        }
    }

    extension CategoryRowCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView,
                            numberOfItemsInSection section: Int) -> Int {
            items.count
        }

        func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AnimePosterCell",
                for: indexPath
            ) as! AnimePosterCell

            cell.configure(with: items[indexPath.item])
            return cell
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {

            CGSize(width: 120, height: 180)
        }
}
