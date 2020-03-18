//
//  Result.swift
//  Test
//
//  Created by Cezhar Arévalo on 17-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct Result: Codable {
    let resultCount: Int
    let results: [Song]
}
