//
//  DefaultIndices.swift
//  StringTest
//
//  Created by Cao, Jiannan on 2017/12/7.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

public struct OffsetIndices<T: Collection> {
    
    private let _target: T
    
    public init(_ target: T) {
        _target = target
    }
    
}

extension OffsetIndices : IndexProxyProtocol, Collection {
    
    public typealias Target = T
    public typealias Index = T.IndexDistance

    public var target: Target {
        return _target
    }

    // TargetIndex -> ProxyIndex
    // ProxyIndex -> TargetIndex
    public func proxyIndex(_ targetIndex: TargetIndex) -> ProxyIndex {
        let offset = target.distance(from: target.startIndex, to: targetIndex)
        return offset
    }
    
    public func targetIndex(_ proxyIndex: ProxyIndex) -> TargetIndex {
        let offset = proxyIndex
        return target.index(target.startIndex, offsetBy: offset)
    }
}
