//
//  AnimeDetailsDTO.swift
//  Jutsu
//
//  Created by Алдияр on 17.12.2025.
//

import Foundation

struct AnimeDetailsResponse: Decodable {
    let data: AnimeDetailsDTO
}

struct AnimeDetailsDTO: Decodable {
    let mal_id: Int
    let title: String
    let synopsis: String?
    let images: ImagesDTO
    let trailer: TrailerDTO?
}

struct TrailerDTO: Decodable {
    let url: String?
    let embed_url: String?
}

extension AnimeDetailsDTO {

    func toDomain() -> Anime {
        print("MAL ID:", mal_id)
        print("FULL SYNOPSIS FROM API:", synopsis ?? "nil")
        print("TRAILER LINK:", trailer?.embed_url ?? "nil")

        return Anime(
            id: mal_id,
            title: title,
            posterURL: images.jpg.image_url,
            description: synopsis,
        )
    }
}
