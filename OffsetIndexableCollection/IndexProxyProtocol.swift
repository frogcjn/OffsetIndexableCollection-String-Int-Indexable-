//
//  ProxyIndices.swift
//  StringTest
//
//  Created by Cao, Jiannan on 2017/12/7.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

public protocol IndexProxyProtocol {
    
    associatedtype Target : Collection
    associatedtype ProxyIndices : Collection
    
    typealias TargetIndex = Target.Index
    typealias ProxyIndex = ProxyIndices.Index
    typealias TargetRange = Range<TargetIndex>
    typealias ProxyRange = Range<ProxyIndex>
    
    var target: Target { get }
    var proxyIndices: ProxyIndices { get }
    
    // TargetIndex -> ProxyIndex
    // ProxyIndex -> TargetIndex
    func proxyIndex(_ targetIndex: TargetIndex) -> ProxyIndex
    func targetIndex(_ proxyIndex: ProxyIndex) -> TargetIndex
    
    // TargetRange -> ProxyRange
    // ProxyRange -> TargetRange
    func proxyRange<R: RangeExpression>(_ targetRange: R) -> Range<ProxyIndex> where R.Bound == TargetIndex
    func proxyRange(_ targetRange: UnboundedRange) -> Range<ProxyIndex>
    func targetRange<R: RangeExpression>(_ proxyRange: R) -> Range<TargetIndex> where R.Bound == ProxyIndex
    func targetRange(_ proxyRange: UnboundedRange) -> Range<TargetIndex>
}

public extension IndexProxyProtocol {
    public func proxyRange<R: RangeExpression>(_ targetRange: R) -> Range<ProxyIndex> where R.Bound == TargetIndex {
        return targetRange.relative(to: target).map(proxyIndex)
    }
    
    public func proxyRange(_ targetRange: UnboundedRange) -> Range<ProxyIndex> {
        return (target.startIndex...).relative(to: target).map(proxyIndex)
    }
    
    public func targetRange<R: RangeExpression>(_ proxyRange: R) -> Range<TargetIndex> where R.Bound == ProxyIndex {
        return proxyRange.relative(to: proxyIndices).map(targetIndex)
    }
    
    public func targetRange(_ proxyRange: UnboundedRange) -> Range<TargetIndex> {
        return (proxyIndices.startIndex...).relative(to: proxyIndices).map(targetIndex)
    }
}

extension IndexProxyProtocol {
    public var proxyIndices: Self {
        return self
    }
}

extension IndexProxyProtocol where ProxyIndices == Self {
    public var startIndex: Self.Index {
        return proxyIndex(target.startIndex)
    }
    
    public var endIndex: Self.Index {
        return proxyIndex(target.endIndex)
    }
    
    public func index(after i: Self.Index) -> Self.Index {
        let i = targetIndex(i)
        return proxyIndex(target.index(after: i))
    }
    
    public subscript(i: Self.Index) -> Self.Index {
        return i
    }
    
    var indices: Self {
        return self
    }
}
