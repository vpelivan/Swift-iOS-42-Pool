import Foundation

class Card: NSObject {
    var color: Color
    var value: Value
    
    init(color: Color, value: Value) {
        self.color = color
        self.value = value
    }
    
    override var description: String {
        return "\(self.value) of \(self.color)"
    }
    
    override func isEqual(_ unit: Any?) -> Bool {
        if let unit = unit as? Card {
            return self.value == unit.value && self.color == unit.color
        } else {
            return false
        }
    }
}

func == (first: Card, second: Card) -> Bool {
    return first.color == second.color && first.value == second.value
}
