//
//  AnimeAPI.swift
//  Jutsu
//
//  Created by Rasul Turumov on 17.12.2025.
//

import Foundation

final class AnimeAPI {

    static let shared = AnimeAPI()
    private init() {}

    func fetchTopMovies(completion: @escaping (Result<[Anime], Error>) -> Void) {

        let url = URL(string: "https://api.jikan.moe/v4/top/anime?type=movie")!

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data else { return }

            do {
                let decoded = try JSONDecoder().decode(AnimeResponse.self, from: data)
                let movies = decoded.data.map { $0.toDomain() }

                DispatchQueue.main.async {
                    completion(.success(movies))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

        }.resume()
    }
    
    func fetchTopSeries(completion: @escaping (Result<[Anime], Error>) -> Void) {

        let url = URL(string: "https://api.jikan.moe/v4/top/anime?type=tv")!

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data else { return }

            do {
                let decoded = try JSONDecoder().decode(AnimeResponse.self, from: data)
                let series = decoded.data.map { $0.toDomain() }

                DispatchQueue.main.async {
                    completion(.success(series))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

        }.resume()
    }

    func searchAnime(query: String,
                     completion: @escaping (Result<[Anime], Error>) -> Void) {

        guard !query.isEmpty else {
            completion(.success([]))
            return
        }

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = URL(string: "https://api.jikan.moe/v4/anime?q=\(encodedQuery)&limit=25")!

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data else { return }

            do {
                let decoded = try JSONDecoder().decode(AnimeResponse.self, from: data)
                let result = decoded.data.map { $0.toDomain() }

                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

        }.resume()
    }
    func fetchAnimeDetails(id: Int,
                           completion: @escaping (Result<Anime, Error>) -> Void) {

        let url = URL(string: "https://api.jikan.moe/v4/anime/\(id)/full")!

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data else { return }

            do {
                let decoded = try JSONDecoder().decode(AnimeDetailsResponse.self, from: data)
                let anime = decoded.data.toDomain()

                DispatchQueue.main.async {
                    completion(.success(anime))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

        }.resume()
    }

}


