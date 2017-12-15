//
//  main.swift
//  OffsetIndexableCollection
//
//  Created by Cao, Jiannan on 2017/12/12.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

let s = "caféz"
print(s.count) // 4
print(s.index(of:"z")! )

print(s[s.count-1]) // é
let u = s.unicodeScalars
print(u.count) // 5
print(u[u.count-1]) //́
let ss = s[s.indices[1]...]
print(ss) // afé
print(s[s.offsetIndex(ss.startIndex) - 1]) // c
print(s[s.index(byOffset: 1)]) // a

let z = s.enumerated()

let a = "01234"
 
print(a[0]) // 0
print(a[0...4]) // 01234
print(a[...]) // 01234

print(a[..<2]) // 01
print(a[...2]) // 012
print(a[2...]) // 234
print(a[2..<3]) // 2
print(a[2...3]) // 23

if let number = a.index(of: "1") {
    print(number) // 1
    print(a[number...]) // 1234
}

if let number = a.index(where: { $0 > "1" }) {
    print(number) // 2
}

let b = a[1...]
print(b[0]) // 1
print(b[...]) // 1234
print(b[..<2]) // 12
print(b[...2]) // 123
print(b[2...]) // 34
print(b[2...3]) // 34
print(b[2...2]) // 3

if let number = b.index(of: "1") {
    print(number) // 0
}

if let number = b.index(where: { $0 > "1" }) {
    print(number) // 1
}

import Foundation

print(a.range(of: b)!) // 1..<5

let offsetIndices = a.offsetIndices
print(offsetIndices.range) // 0..<5
print(a.range) // Index(_compoundOffset: 0, _cache: Swift.String.Index._Cache.utf16)..<Index(_compoundOffset: 20, _cache: Swift.String.Index._Cache.utf16)
print(a.range == a.range(byOffset: offsetIndices.range)) // true
print(a.offsetRange(a.range) == offsetIndices.range) // true
