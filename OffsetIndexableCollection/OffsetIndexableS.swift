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
        return 0
    }
    
    var endIndex: Int {
        var iterator = makeIterator()
        var i = 0
        while let _ = iterator.next() {
            i += 1
        }
        return i
    }
    
    func index(after i: Int) -> Int {
        return i + 1
    }
    
    subscript(position: Int) -> Self.Element {
        if (!(position >= 0)) {
            fatalError("Fatal error: Index out of range", file: #file, line: #line)
        }
        
        var iterator = makeIterator()
        var i = 0
        while let element = iterator.next() {
            if position == i { return element }
            i += 1
        }
        
        fatalError("Fatal error: Index out of range", file: #file, line: #line)
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

 extension MySequence: OffsetIndexableSequence {
    typealias Element = Void
}
*/
