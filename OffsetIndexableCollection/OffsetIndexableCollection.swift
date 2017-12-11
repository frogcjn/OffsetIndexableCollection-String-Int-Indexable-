//
//  ProxyIndexableCollection.swift
//  StringTest
//
//  Created by Cao, Jiannan on 2017/12/7.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

public protocol OffsetIndexableCollection : Collection {
    typealias OffsetIndex = OffsetIndices<Self>.Index
    var offsetIndices: OffsetIndices<Self> { get }
}

public extension OffsetIndexableCollection {
    
    var offsetIndices: OffsetIndices<Self> {
        return OffsetIndices<Self>(self)
    }
}

// OffsetIndexableCollection where Self : Collection

public extension OffsetIndexableCollection {
    
    subscript(i: OffsetIndex) -> Self.Element {
        return self[offsetIndices.targetIndex(i)]
    }
    
    subscript<R: RangeExpression>(bounds: R) -> Self.SubSequence where R.Bound == OffsetIndex {
        return self[offsetIndices.targetRange(bounds)]
    }
    
    func prefix(through i: OffsetIndex) -> Self.SubSequence {
        return prefix(through: offsetIndices.targetIndex(i))
    }
    
    func prefix(upTo i: OffsetIndex) -> Self.SubSequence {
        return prefix(upTo: offsetIndices.targetIndex(i))
    }
    
    func suffix(from i: OffsetIndex) -> Self.SubSequence {
        return suffix(from: offsetIndices.targetIndex(i))
    }
    
    func index(where predicate: (Self.Element) throws -> Bool) rethrows -> OffsetIndex? {
        return try index(where: predicate).map(offsetIndices.proxyIndex)
    }
    
}

public extension OffsetIndexableCollection where Self.Element : Equatable {
    
    func index(of element: Self.Element) -> OffsetIndex? {
        return index(of: element).map(offsetIndices.proxyIndex)
    }
    
}

public extension OffsetIndexableCollection where Self : MutableCollection {
    subscript(i: OffsetIndex) -> Self.Element {
        get {
            return self[offsetIndices.targetIndex(i)]
        }
        mutating set {
            self[offsetIndices.targetIndex(i)] = newValue
        }
    }
    
    subscript<R: RangeExpression>(bounds: R) -> Self.SubSequence where R.Bound == OffsetIndex {
        get {
            return self[offsetIndices.targetRange(bounds)]
        }
        mutating set {
            self[offsetIndices.targetRange(bounds)] = newValue
        }
    }
    
    mutating func swapAt(_ i: OffsetIndex, _ j: OffsetIndex) {
        swapAt(offsetIndices.targetIndex(i), offsetIndices.targetIndex(j))
    }
    
    mutating func partition(by belongsInSecondPartition: (Self.Element) throws -> Bool) rethrows -> OffsetIndex {
        return offsetIndices.proxyIndex(try partition(by: belongsInSecondPartition))
    }
}

public extension OffsetIndexableCollection where Self : RangeReplaceableCollection {
 
    mutating func replaceSubrange<C : Collection, R : RangeExpression>(_ subrange: R, with newElements: C)
        where R.Bound == OffsetIndex, C.Element == Self.Element {
        return replaceSubrange(offsetIndices.targetRange(subrange), with: newElements)
    }
    
    mutating func insert(_ newElement: Self.Element, at i: OffsetIndex) {
        return insert(newElement, at: offsetIndices.targetIndex(i))
    }
    
    mutating func insert<C: Collection>(contentsOf newElements: C, at i: OffsetIndex)
        where C.Element == Self.Element {
        return insert(contentsOf: newElements, at: offsetIndices.targetIndex(i))
    }
    
    mutating func remove(at i: OffsetIndex) -> Self.Element {
        return remove(at: offsetIndices.targetIndex(i))
    }
    
    mutating func removeSubrange<R: RangeExpression>(_ bounds: R)
        where R.Bound == OffsetIndex {
        return removeSubrange(offsetIndices.targetRange(bounds))
    }
}
