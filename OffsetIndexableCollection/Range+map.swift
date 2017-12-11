//
//  Range+map.swift
//  StringTest
//
//  Created by Cao, Jiannan on 2017/12/11.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

public extension Range {
    func map<T>(_ transform: (Bound) throws -> T) rethrows -> Range<T> {
        return try Range<T>(uncheckedBounds: (lower: transform(lowerBound), upper: transform(upperBound)))
    }
}
