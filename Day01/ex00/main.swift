#!/usr/bin/swift

var colorArray: [Color] = Color.allColors
var valueArray: [Value] = Value.allValues

for elem in colorArray {
    print("The raw value in \(elem) is: \(elem.rawValue)")
}
print("")
for elem in valueArray {
    print("The raw value in \(elem) is: \(elem.rawValue)")
}
