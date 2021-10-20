//
//  Expiry.swift
//  LWNetwork
//
//  Created by luowen on 2021/10/9.
//

public enum Expiry {
    /// Object will be expired in the nearest future
    case never
    /// Object will be expired in the specified amount of seconds
    case seconds(TimeInterval)
    /// Object will be expired on the specified date
    case date(Date)

    /// Returns the appropriate date object
    public var date: Date {
        switch self {
        case .never:
            return Date(timeIntervalSince1970: 60 * 60 * 24 * 365 * 68)
        case .seconds(let seconds):
            return Date().addingTimeInterval(seconds)
        case .date(let date):
            return date
        }
    }

    /// Checks if cached object is expired according to expiration date
    public var isExpired: Bool {
        return date.timeIntervalSinceNow < 0
    }
}

public extension Expiry {

    enum Error: Swift.Error {
        case noCache
        case expired(Date)
    }
}
