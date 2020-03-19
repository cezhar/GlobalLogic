//
//  MyError.swift
//  Test
//
//  Created by Cezhar Arévalo on 18-03-20.
//  Copyright © 2020 Cezhar Arévalo. All rights reserved.
//

import Foundation

public enum MyError: Error {
    case offlineError
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .offlineError:
            return NSLocalizedString("The Internet connection appears to be offline...", comment: "offline")
        }
    }
}
