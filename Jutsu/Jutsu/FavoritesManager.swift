//
//  FavoritesManager.swift
//  Jutsu
//
//  Created by Алдияр on 17.12.2025.
//

import Foundation

final class FavoritesManager {

    static let shared = FavoritesManager()
    private init() {}

    private let key = "favorites_anime"

    private var favorites: [Anime] = []

    func load() -> [Anime] {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Anime].self, from: data) {
            favorites = decoded
        }
        return favorites
    }

    func isFavorite(_ anime: Anime) -> Bool {
        favorites.contains { $0.id == anime.id }
    }

    func toggle(_ anime: Anime) {
        if isFavorite(anime) {
            favorites.removeAll { $0.id == anime.id }
        } else {
            favorites.append(anime)
        }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
