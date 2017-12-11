//
//  main.swift
//  OffsetIndexableCollection
//
//  Created by Cao, Jiannan on 2017/12/12.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

let a = "01234"

print(a[0]) // 0
print(a[0...4]) // 01234
print(a[...]) // 01234

print(a[..<2]) // 01
print(a[...2]) // 012
print(a[2...]) // 234
print(a[2...3]) // 23
print(a[2...2]) // 2

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
