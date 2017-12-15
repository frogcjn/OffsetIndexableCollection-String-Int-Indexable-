//
//  MySequence.swift
//  OffsetIndexableCollection
//
//  Created by Cao, Jiannan on 2017/12/15.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

protocol OffsetIndexableSequence: Collection {
    
}

extension OffsetIndexableSequence {
    var startIndex: Int {
        return Array(self).startIndex
    }
    
    var endIndex: Int {
        return Array(self).endIndex
    }
    
    func index(after i: Int) -> Int {
        return i + 1
    }
    
    // start, end, index(after i: Int) -> indices: DefaultIndices
    
    subscript(position: Int) -> Self.Element {
        return Array(self)[position]
    }
}

/*
class MySequence : Sequence {
    
    func makeIterator() -> MyIterator {
        return MyIterator()
    }
    
    // required: Sequence.Iterator <- "makeIterator() -> Iterator"
    // required: Sequence.Element <- "Iterator.Element"
}

struct MyIterator: IteratorProtocol {
    func next() -> Void? {
        return nil
    }
    // required: IteratorProtocol.Element <- "next() -> Element?"
}

extension MySequence : OffsetIndexableSequence {
    typealias Element = Void
}
*/
