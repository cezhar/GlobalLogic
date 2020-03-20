//
//  StoredSong.swift
//  Test
//
//  Created by Cezhar Arévalo on 20-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import Foundation
import RealmSwift

class StoredSong: Object {
    
    @objc dynamic var wrapperType = ""
    @objc dynamic var kind = ""
    @objc dynamic var artistID = 0
    @objc dynamic var collectionID = 0
    @objc dynamic var trackID = 0
    @objc dynamic var artistName = ""
    @objc dynamic var collectionName = ""
    @objc dynamic var trackName = ""
    @objc dynamic var collectionCensoredName = ""
    @objc dynamic var trackCensoredName = ""
    @objc dynamic var previewURL = ""
    @objc dynamic var artworkUrl30 = ""
    @objc dynamic var artworkUrl100 = ""
    @objc dynamic var trackNumber = 0
    
}
