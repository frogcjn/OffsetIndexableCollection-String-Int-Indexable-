//
//  ProxyIndices.swift
//  StringTest
//
//  Created by Cao, Jiannan on 2017/12/7.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

// MARK: - StringProtocol + OffsetIndexableCollection

extension String : OffsetIndexableCollection {
}

extension Substring : OffsetIndexableCollection {
}

extension String.UTF8View : OffsetIndexableCollection {
}

extension String.UTF16View : OffsetIndexableCollection {
}

extension String.UnicodeScalarView : OffsetIndexableCollection {
}

extension DefaultIndices: OffsetIndexableCollection {
    
}

#if swift(>=4.1)
#else
extension DefaultRandomAccessIndices: OffsetIndexableCollection {
    
}
extension DefaultBidirectionalIndices: OffsetIndexableCollection {
    
}
#endif

// MARK: - Range +

public extension Range {
    func map<T>(_ transform: (Bound) throws -> T) rethrows -> Range<T> {
        return try Range<T>(uncheckedBounds: (lower: transform(lowerBound), upper: transform(upperBound)))
    }
}

public extension Collection {
    var range: Range<Index> {
        return startIndex..<endIndex
    }
}

// MARK: - IndexProxyProtocol

public protocol IndexProxyProtocol {
    
    associatedtype Target : Collection
    associatedtype ProxyIndices : Collection = Self
    
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
    
    func proxyRange<R: RangeExpression>(_ targetRange: R) -> Range<ProxyIndex> where R.Bound == TargetIndex {
        return targetRange.relative(to: target).map(proxyIndex)
    }
    
    func proxyRange(_ targetRange: UnboundedRange) -> Range<ProxyIndex> {
        return target.range.map(proxyIndex)
    }
    
    func targetRange<R: RangeExpression>(_ proxyRange: R) -> Range<TargetIndex> where R.Bound == ProxyIndex {
        return proxyRange.relative(to: proxyIndices).map(targetIndex)
    }
    
    func targetRange(_ proxyRange: UnboundedRange) -> Range<TargetIndex> {
        return proxyIndices.range.map(targetIndex)
    }
}

public extension IndexProxyProtocol where ProxyIndices == Self {
    
    var proxyIndices: ProxyIndices {
        return self
    }
    
    var startIndex: Self.Index {
        return proxyIndex(target.startIndex)
    }
    
    var endIndex: Self.Index {
        return proxyIndex(target.endIndex)
    }
    
    func index(after i: Self.Index) -> Self.Index {
        let i = targetIndex(i)
        return proxyIndex(target.index(after: i))
    }
    
    subscript(i: Self.Index) -> Self.Index {
        return i
    }
    
    var indices: Self {
        return self
    }
}

// MARK: - OffsetIndices

public struct OffsetIndices<T: Collection> {
    
    private let _target: T
    
    public init(_ target: T) {
        _target = target
    }
    
}

extension OffsetIndices : IndexProxyProtocol, Collection {
    
    public typealias Index = T.IndexDistance
    public typealias Target = T
    
    #if swift(>=4.1)
    public typealias ProxyIndices = OffsetIndices<T>
    #endif
    
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

// MARK: - OffsetIndexableCollection

public protocol OffsetIndexableCollection : Collection {
    typealias OffsetIndex = OffsetIndices<Self>.Index
    typealias OffsetRange = Range<OffsetIndex>
    var offsetIndices: OffsetIndices<Self> { get }
}

public extension OffsetIndexableCollection {
    
    var offsetIndices: OffsetIndices<Self> {
        return OffsetIndices<Self>(self)
    }
    
    func offsetIndex(_ index: Index) -> OffsetIndex {
        return offsetIndices.proxyIndex(index)
    }
    
    func index(byOffset offsetIndex: OffsetIndex) -> Index {
        return offsetIndices.targetIndex(offsetIndex)
    }
    
    func offsetRange(_ : Range<Index>) -> OffsetRange {
        return offsetIndices.proxyRange(range)
    }
    
    func range(byOffset offsetRange: OffsetRange) -> Range<Index> {
        return offsetIndices.targetRange(offsetRange)
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

// MARK: - StringProtocol API bridging from NSString

import typealias Foundation.ComparisonResult
import struct Foundation.Locale
import struct Foundation.CharacterSet
import class Foundation.NSLinguisticTagger
import class Foundation.NSOrthography

public extension OffsetIndexableCollection where Self : StringProtocol, Self.Index == String.Index {
    
    func compare<S: StringProtocol, R: RangeExpression>(_ aString: S, options mask: String.CompareOptions = [], range: R, locale: Locale? = nil) -> ComparisonResult where R.Bound == OffsetIndex {
        return compare(aString, options: mask, range: offsetIndices.targetRange(range), locale: locale)
    }
    
    func compare<S: StringProtocol>(_ aString: S, options mask: String.CompareOptions = [], range: UnboundedRange = (...), locale: Locale? = nil) -> ComparisonResult {
        return compare(aString, options: mask, range: offsetIndices.range, locale: locale)
    }
    
    func enumerateLinguisticTags<T: StringProtocol, R: RangeExpression>(in range: R, scheme tagScheme: T, options opts: NSLinguisticTagger.Options = [], orthography: NSOrthography? = nil, invoking body: (String, Range<OffsetIndex>, Range<OffsetIndex>, inout Bool) -> Void) where R.Bound == OffsetIndex {
        return enumerateLinguisticTags(in: offsetIndices.targetRange(range), scheme: tagScheme, options: opts, orthography: orthography) { (substring: String, substringRange: Range<Index>, enclosingRange: Range<Index>, stop: inout Bool) in
            return body(substring, offsetIndices.proxyRange(substringRange), offsetIndices.proxyRange(enclosingRange), &stop)
        }
    }
    
    func enumerateLinguisticTags<T: StringProtocol>(in range: UnboundedRange, scheme tagScheme: T, options opts: NSLinguisticTagger.Options = [], orthography: NSOrthography? = nil, invoking body: (String, Range<OffsetIndex>, Range<OffsetIndex>, inout Bool) -> Void) {
        return enumerateLinguisticTags(in: offsetIndices.range, scheme: tagScheme, options: opts, orthography: orthography, invoking: body)
    }
    
    func enumerateSubstrings<R: RangeExpression>(in range: R, options opts: String.EnumerationOptions = [], _ body: @escaping (String?, Range<OffsetIndex>, Range<OffsetIndex>, inout Bool) -> Void) where R.Bound == OffsetIndex {
        return enumerateSubstrings(in: offsetIndices.targetRange(range), options: opts) { [offsetIndices] (substring: String?, substringRange: Range<Index>, enclosingRange: Range<Index>, stop: inout Bool) in
            return body(substring, offsetIndices.proxyRange(substringRange), offsetIndices.proxyRange(enclosingRange), &stop)
        }
    }
    
    func enumerateSubstrings(in range: UnboundedRange = (...), options opts: String.EnumerationOptions = [], _ body: @escaping (String?, Range<OffsetIndex>, Range<OffsetIndex>, inout Bool) -> Void) {
        return enumerateSubstrings(in: offsetIndices.range, options: opts, body)
    }
    
    func getBytes<R: RangeExpression>(
        _ buffer: inout [UInt8],
        maxLength maxBufferCount: Int,
        usedLength usedBufferCount: UnsafeMutablePointer<Int>,
        encoding: String.Encoding,
        options: String.EncodingConversionOptions = [],
        range: R,
        remaining leftover: UnsafeMutablePointer<Range<OffsetIndex>>) -> Bool where R.Bound == OffsetIndex
    {
        let _leftover: UnsafeMutablePointer<Range<String.Index>> = UnsafeMutablePointer.allocate(capacity: 1)
        
        defer {
            leftover.pointee = offsetIndices.proxyRange(_leftover.pointee)
            _leftover.deinitialize(count: 1)
        }
        
        return getBytes(&buffer, maxLength: maxBufferCount, usedLength: usedBufferCount, encoding: encoding, options: options, range: offsetIndices.targetRange(range), remaining: _leftover)
    }
    
    func getBytes(
        _ buffer: inout [UInt8],
        maxLength maxBufferCount: Int,
        usedLength usedBufferCount: UnsafeMutablePointer<Int>,
        encoding: String.Encoding,
        options: String.EncodingConversionOptions = [],
        range: UnboundedRange = (...),
        remaining leftover: UnsafeMutablePointer<Range<OffsetIndex>>) -> Bool
    {
        return getBytes(&buffer, maxLength: maxBufferCount, usedLength: usedBufferCount, encoding: encoding, options: options, range: offsetIndices.range, remaining: leftover)
    }
    
    func getLineStart<R: RangeExpression>(_ start: UnsafeMutablePointer<OffsetIndex>, end: UnsafeMutablePointer<OffsetIndex>, contentsEnd: UnsafeMutablePointer<OffsetIndex>, for range: R) where R.Bound == OffsetIndex {
        let _start: UnsafeMutablePointer<String.Index> = UnsafeMutablePointer.allocate(capacity: 1)
        let _end: UnsafeMutablePointer<String.Index> = UnsafeMutablePointer.allocate(capacity: 1)
        let _contentsEnd: UnsafeMutablePointer<String.Index> = UnsafeMutablePointer.allocate(capacity: 1)
        
        defer {
            start.pointee = offsetIndices.proxyIndex(_start.pointee)
            end.pointee = offsetIndices.proxyIndex(_end.pointee)
            contentsEnd.pointee = offsetIndices.proxyIndex(_contentsEnd.pointee)
            
            _start.deinitialize(count: 1)
            _end.deinitialize(count: 1)
            _contentsEnd.deinitialize(count: 1)
        }
        
        return getLineStart(_start, end: _end, contentsEnd: _contentsEnd, for: offsetIndices.targetRange(range))
    }
    
    func getLineStart(_ start: UnsafeMutablePointer<OffsetIndex>, end: UnsafeMutablePointer<OffsetIndex>, contentsEnd: UnsafeMutablePointer<OffsetIndex>, for range: UnboundedRange = (...)) {
        return getLineStart(start, end: end, contentsEnd: contentsEnd, for: offsetIndices.range)
    }
    
    func getParagraphStart<R: RangeExpression>(_ start: UnsafeMutablePointer<OffsetIndex>, end: UnsafeMutablePointer<OffsetIndex>, contentsEnd: UnsafeMutablePointer<OffsetIndex>, for range: R) where R.Bound == OffsetIndex {
        
        let _start: UnsafeMutablePointer<String.Index> = UnsafeMutablePointer.allocate(capacity: 1)
        let _end: UnsafeMutablePointer<String.Index> = UnsafeMutablePointer.allocate(capacity: 1)
        let _contentsEnd: UnsafeMutablePointer<String.Index> = UnsafeMutablePointer.allocate(capacity: 1)
        
        defer {
            start.pointee = offsetIndices.proxyIndex(_start.pointee)
            end.pointee = offsetIndices.proxyIndex(_end.pointee)
            contentsEnd.pointee = offsetIndices.proxyIndex(_contentsEnd.pointee)
            
            _start.deinitialize(count: 1)
            _end.deinitialize(count: 1)
            _contentsEnd.deinitialize(count: 1)
        }
        
        return getParagraphStart(_start, end: _end, contentsEnd: _contentsEnd, for: offsetIndices.targetRange(range))
    }
    
    func getParagraphStart(_ start: UnsafeMutablePointer<OffsetIndex>, end: UnsafeMutablePointer<OffsetIndex>, contentsEnd: UnsafeMutablePointer<OffsetIndex>, for range: UnboundedRange = (...)) {
        return getParagraphStart(start, end: end, contentsEnd: contentsEnd, for: offsetIndices.range)
    }
    
    func lineRange<R: RangeExpression>(for aRange: R) -> OffsetRange where R.Bound == OffsetIndex {
        return offsetIndices.proxyRange(lineRange(for: offsetIndices.targetRange(aRange)))
    }
    
    func lineRange(for aRange: UnboundedRange) -> OffsetRange {
        return lineRange(for: offsetIndices.range)
    }
    
    func linguisticTags<T: StringProtocol, R: RangeExpression>(in range: R, scheme tagScheme: T, options opts: NSLinguisticTagger.Options = [], orthography: NSOrthography? = nil, tokenRanges: UnsafeMutablePointer<[Range<OffsetIndex>]>? = nil) -> [String] where R.Bound == OffsetIndex {
        guard let tokenRanges = tokenRanges else {
            return linguisticTags(in: offsetIndices.targetRange(range), scheme: tagScheme, options: opts, orthography: orthography)
        }
        
        let _tokenRanges: UnsafeMutablePointer<[Range<String.Index>]> = UnsafeMutablePointer.allocate(capacity: 1)
        defer {
            tokenRanges.pointee = _tokenRanges.pointee.map(offsetIndices.proxyRange)
            _tokenRanges.deinitialize(count: 1)
        }
        return linguisticTags(in: offsetIndices.targetRange(range), scheme: tagScheme, options: opts, orthography: orthography, tokenRanges: _tokenRanges)
    }
    
    func linguisticTags<T: StringProtocol>(in range: UnboundedRange = (...), scheme tagScheme: T, options opts: NSLinguisticTagger.Options = [], orthography: NSOrthography? = nil, tokenRanges: UnsafeMutablePointer<[Range<OffsetIndex>]>? = nil) -> [String] {
        return linguisticTags(in: offsetIndices.range, scheme: tagScheme, options: opts, orthography: orthography, tokenRanges: tokenRanges)
    }
    
    
    func localizedStandardRange<T: StringProtocol>(of string: T) -> OffsetRange? {
        return localizedStandardRange(of: string).map(offsetIndices.proxyRange)
    }
    
    
    // func padding<T>(toLength newLength: Int, withPad padString: T, startingAt padIndex: Int) -> String where T : StringProtocol
    
    
    func paragraphRange<R: RangeExpression>(for aRange: R) -> OffsetRange where R.Bound == OffsetIndex {
        return offsetIndices.proxyRange(paragraphRange(for: offsetIndices.targetRange(aRange)))
    }
    
    func paragraphRange(for aRange: UnboundedRange = (...)) -> OffsetRange {
        return paragraphRange(for: offsetIndices.range)
    }
    
    func range<T: StringProtocol, R: RangeExpression>(of aString: T, options mask: String.CompareOptions = [], range searchRange: R, locale: Locale? = nil) -> OffsetRange? where R.Bound == OffsetIndex {
        return range(of: aString, options: mask, range: offsetIndices.targetRange(searchRange), locale: locale).map(offsetIndices.proxyRange)
    }
    
    func range<T: StringProtocol>(of aString: T, options mask: String.CompareOptions = [], range searchRange: UnboundedRange = (...), locale: Locale? = nil) -> OffsetRange? {
        return range(of: aString, options: mask, range: offsetIndices.range, locale: locale)
    }
    
    func rangeOfCharacter<R: RangeExpression>(from searchSet: CharacterSet, options mask: String.CompareOptions = [], range aRange: R) -> OffsetRange? where R.Bound == OffsetIndex {
        return rangeOfCharacter(from: searchSet, options: mask, range: offsetIndices.targetRange(aRange)).map(offsetIndices.proxyRange)
    }
    
    func rangeOfCharacter(from searchSet: CharacterSet, options mask: String.CompareOptions = [], range aRange: UnboundedRange = (...)) -> OffsetRange? {
        return rangeOfCharacter(from: searchSet, options: mask, range: offsetIndices.range)
    }
    
    func rangeOfComposedCharacterSequence(at anIndex: OffsetIndex) -> OffsetRange {
        return offsetIndices.proxyRange(rangeOfComposedCharacterSequence(at: offsetIndices.targetIndex(anIndex)))
    }
    
    func rangeOfComposedCharacterSequences<R: RangeExpression>(for range: R) -> OffsetRange where R.Bound == OffsetIndex {
        return offsetIndices.proxyRange(rangeOfComposedCharacterSequences(for: offsetIndices.targetRange(range)))
    }
    
    func rangeOfComposedCharacterSequences(for range: UnboundedRange = (...)) -> OffsetRange {
        return rangeOfComposedCharacterSequences(for: offsetIndices.range)
    }
    
    func replacingCharacters<T: StringProtocol, R: RangeExpression>(in range: R, with replacement: T) -> String where R.Bound == OffsetIndex {
        return replacingCharacters(in: offsetIndices.targetRange(range), with: replacement)
    }
    
    func replacingCharacters<T: StringProtocol>(in range: UnboundedRange = (...), with replacement: T) -> String {
        return replacingCharacters(in: offsetIndices.range, with: replacement)
    }
    
    func replacingOccurrences<T: StringProtocol, R: StringProtocol, RE: RangeExpression>(of target: T, with replacement: R, options mask: String.CompareOptions = [], range searchRange: RE) -> String where RE.Bound == OffsetIndex {
        return replacingOccurrences(of: target, with: replacement, options: mask, range: offsetIndices.targetRange(searchRange))
    }
    
    func replacingOccurrences<T: StringProtocol, R: StringProtocol>(of target: T, with replacement: R, options mask: String.CompareOptions = [], range searchRange: UnboundedRange = (...)) -> String {
        return replacingOccurrences(of: target, with: replacement, options: mask, range: offsetIndices.range)
    }
}
