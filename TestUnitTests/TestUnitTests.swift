//
//  TestUnitTests.swift
//  TestUnitTests
//
//  Created by Cezhar Arévalo on 20-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import XCTest
@testable import Test

class TestUnitTests: XCTestCase {

    
    func testAPI() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let song = "Overture 1928"
        let page = 0
        API.fetchSongs(with: song, offset: page){result, error in
            assert(error == nil)
            assert(result!.count > 0)
        }
        let bad = "asdfasdfasdfasdf"
        API.fetchSongs(with: bad, offset: page){result, error in
            assert(error == nil)
            assert(result!.count == 0)
        }
        let badpage = -1234
        API.fetchSongs(with: bad, offset: badpage){result, error in
            assert(error != nil)
            assert(result == nil)
        }
        let id = 282694467
        API.fetchAlbum(id: id){result, error in
            assert(error == nil)
            assert(result!.count > 0)
        }
        let badId = -12345
        API.fetchAlbum(id: badId){result, error in
            assert(error != nil)
            assert(result == nil)
        }
    }

}
