//
//  AnimePosterCell.swift
//  Jutsu
//
//  Created by Rasul Turumov on 17.12.2025.
//

import UIKit
import Kingfisher

final class AnimePosterCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }

    func configure(with anime: Anime) {
        let url = URL(string: anime.posterURL)

        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo"),
            options: [
                .transition(.fade(0.25)),
                .cacheOriginalImage
            ]
        )
    }
}
