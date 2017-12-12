//
//  StringSub.swift
//  StringTest
//
//  Created by Cao, Jiannan on 2017/12/6.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//


extension String : OffsetIndexableCollection {
}

extension Substring : OffsetIndexableCollection {
}


// StringProtocol API bridging from NSString

import Foundation

public extension OffsetIndexableCollection where Self : StringProtocol, Self.Index == String.Index {
    
    func compare<S: StringProtocol, R: RangeExpression>(_ aString: S, options mask: String.CompareOptions = [], range rangeOfReceiverToCompare: R, locale: Locale? = nil) -> ComparisonResult where R.Bound == OffsetIndex {
        return compare(aString, options: mask, range: offsetIndices.targetRange(rangeOfReceiverToCompare), locale: locale)
    }
    
    func compare<S: StringProtocol>(_ aString: S, options mask: String.CompareOptions = [], range rangeOfReceiverToCompare: UnboundedRange = (...), locale: Locale? = nil) -> ComparisonResult {
        return compare(aString, options: mask, range: offsetIndices.targetRange(rangeOfReceiverToCompare), locale: locale)
    }
    
    func localizedStandardRange<T: StringProtocol>(of string: T) -> OffsetRange? {
        return localizedStandardRange(of: string).map(offsetIndices.proxyRange)
    }
    
    func range<S: StringProtocol, R: RangeExpression>(of searchString: S, options mask: NSString.CompareOptions = [], range rangeOfReceiverToSearch: R, locale: Locale? = nil) -> OffsetRange? where R.Bound == OffsetIndex {
        return range(of: searchString, options: mask, range: offsetIndices.targetRange(rangeOfReceiverToSearch), locale: locale).map(offsetIndices.proxyRange)
    }
    
    func range<S: StringProtocol>(of searchString: S, options mask: NSString.CompareOptions = [], range rangeOfReceiverToSearch: UnboundedRange = (...), locale: Locale? = nil) -> OffsetRange? {
        return range(of: searchString, options: mask, range: offsetIndices.targetRange(rangeOfReceiverToSearch), locale: locale).map(offsetIndices.proxyRange)
    }
    
    func rangeOfCharacter<R: RangeExpression>(from searchSet: CharacterSet, options mask: NSString.CompareOptions = [], range rangeOfReceiverToSearch: R) -> OffsetRange? where R.Bound == OffsetIndex {
        return rangeOfCharacter(from: searchSet, options: mask, range: offsetIndices.targetRange(rangeOfReceiverToSearch)).map(offsetIndices.proxyRange)
    }
    
    func rangeOfCharacter(from searchSet: CharacterSet, options mask: NSString.CompareOptions = [], range rangeOfReceiverToSearch: UnboundedRange = (...)) -> OffsetRange? {
        return rangeOfCharacter(from: searchSet, options: mask, range: offsetIndices.targetRange(rangeOfReceiverToSearch)).map(offsetIndices.proxyRange)
    }
}
