//
//  AnimeDetailsViewController.swift
//  Jutsu
//
//  Created by Алдияр on 17.12.2025.
//

import UIKit
import Kingfisher
import AVKit

final class AnimeDetailsViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var watchButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

    var anime: Anime!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInitial()
        loadDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLikeButton()
    }

    private func configureInitial() {
        titleLabel.text = anime.title
        descriptionLabel.text = anime.description ?? "Loading..."

        if let url = URL(string: anime.posterURL) {
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: url)
        }
    }

    private func loadDetails() {
        AnimeAPI.shared.fetchAnimeDetails(id: anime.id) { [weak self] result in
            switch result {
            case .success(let fullAnime):
                self?.anime = fullAnime
                self?.descriptionLabel.text = fullAnime.description
                self?.updateWatchButton()

            case .failure(let error):
                print("Details error:", error)
            }
        }
    }


    private func updateWatchButton() {
           if LocalVideoManager.localURL(for: anime.id) != nil {
               watchButton.setTitle("Watch", for: .normal)
               watchButton.alpha = 1
           } else {
               watchButton.setTitle("Coming soon", for: .normal)
               watchButton.alpha = 0.6
           }
       }



    @IBAction func watchTapped(_ sender: UIButton) {
        if let url = LocalVideoManager.localURL(for: anime.id) {
                    playLocalVideo(url)
                    return
                }

                showComingSoonAlert()
    }
    
    @IBAction func likeTapped(_ sender: UIButton) {
        FavoritesManager.shared.toggle(anime)
        updateLikeButton()
    }

    private func playLocalVideo(_ url: URL) {
            let player = AVPlayer(url: url)
            let vc = AVPlayerViewController()
            vc.player = player

            present(vc, animated: true) {
                player.play()
            }
        }

        private func showComingSoonAlert() {
            let alert = UIAlertController(
                title: "Coming soon",
                message: "This anime does not have a trailer yet.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    
    private func updateLikeButton() {
        let isLiked = FavoritesManager.shared.isFavorite(anime)
        let imageName = isLiked ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        likeButton.tintColor = .systemBlue
    }

}
