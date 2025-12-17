//
//  LocalVideoManager.swift
//  Jutsu
//
//  Created by Алдияр on 18.12.2025.
//

import Foundation

enum LocalVideoManager {

    private static let videosByMalId: [Int: String] = [
        59192: "aot_trailer",
        57555: "jjk_trailer",
        60098: "ds_trailer"
    ]

    static func localURL(for malID: Int) -> URL? {
        guard let name = videosByMalId[malID] else {
            return nil
        }

        return Bundle.main.url(
            forResource: name,
            withExtension: "mp4"
        )
    }
}
