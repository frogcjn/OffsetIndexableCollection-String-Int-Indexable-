# OffsetIndexableCollection-String-Int-Indexable-
OffsetIndexableCollection (String Int Indexable)

The protocol   `OffsetIndexableCollection` will extend any collection with offset index (int index).
For example:

```Swift
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

```
Then you can use String, Substring, String.UTF8View, String.UTF16View, String.UnicodeScalarView with offset indices
```Swift

let s = "café"
print(s.count) // 4
print(s[s.count-1]) // é
let u = s.unicodeScalars
print(u.count) // 5
print(u[u.count-1]) //́

let u = s.unicodeScalars
print(u.count)
for i in 0..<u.count {
    print(u[i])
}

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

```

You could use NSString API with offset index.

```Swift
import Foundation

print(a.range(of: b)!) // 1..<5
```

You could also munually transfer a Collection.Index to the offset index:

```Swift
let offsetIndices = a.offsetIndices
print(offsetIndices.range) // 0..<5
print(a.range) // Index(_compoundOffset: 0, _cache: Swift.String.Index._Cache.utf16)..<Index(_compoundOffset: 20, _cache: Swift.String.Index._Cache.utf16)
print(a.range == offsetIndices.targetRange(offsetIndices.range)) // true
print(offsetIndices.proxyRange(a.range) == offsetIndices.range) // true
```

