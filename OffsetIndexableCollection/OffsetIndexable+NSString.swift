//
//  NSString+subscript<Offset>.swift
//  OffsetIndexableCollection
//
//  Created by Cao, Jiannan on 2017/12/12.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

// StringProtocol API bridging from NSString

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
