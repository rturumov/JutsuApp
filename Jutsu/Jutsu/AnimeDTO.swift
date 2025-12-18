//
//  AnimeDTO.swift
//  Jutsu
//
//  Created by Rasul Turumov on 17.12.2025.
//

import Foundation

struct AnimeResponse: Decodable {
    let data: [AnimeDTO]
}

struct AnimeDTO: Decodable {
    let mal_id: Int
    let title: String
    let images: ImagesDTO
}

struct ImagesDTO: Decodable {
    let jpg: JPGImageDTO
}

struct JPGImageDTO: Decodable {
    let image_url: String
}

extension AnimeDTO {
    func toDomain() -> Anime {
        Anime(
            id: mal_id,
            title: title,
            posterURL: images.jpg.image_url,
            description: nil,
        )
    }
}
