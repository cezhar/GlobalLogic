//
//  Song.swift
//  Test
//
//  Created by Cezhar Arévalo on 17-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import Foundation

struct Song: Codable {
    let wrapperType, kind: String?
    let artistID, collectionID:Int?
    let trackID: Int?
    let artistName, collectionName, trackName, collectionCensoredName: String?
    let trackCensoredName: String?
    let previewURL: String?
    let artworkUrl30, artworkUrl100: String?
    let trackNumber: Int?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case previewURL = "previewUrl"
        case artworkUrl30,artworkUrl100
        case trackNumber
    }
}
