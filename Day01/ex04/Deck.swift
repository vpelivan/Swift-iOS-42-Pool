import Foundation

class Deck: NSObject {
    static let allSpades: [Card] = Value.allValues.map{Card(color: Color.spades, value: $0)}
    static let allDiamonds: [Card] = Value.allValues.map{Card(color: Color.diamonds, value: $0)}
    static let allHearts: [Card] = Value.allValues.map{Card(color: Color.hearts, value: $0)}
    static let allClubs: [Card] = Value.allValues.map{Card(color: Color.clubs, value: $0)}
    static let allCards: [Card] = allSpades + allDiamonds + allHearts + allClubs
    var cards: [Card] = allCards
    var disards: [Card] = []
    var outs: [Card] = []
    
    init(arg: Bool) {
        if arg == true {
            self.cards = Deck.allCards
        } else {
            self.cards.randomize()
        }
    }
    
    override var description: String {
        return self.cards.description
    }
    
    func draw() -> Card? {
        var one: Card?
        
        one = self.cards.first
        self.outs.append(one!)
        self.cards.remove(at: 0)
        return one
    }
    
    func fold(c: Card) {
        var i = 0
        
        for elem in self.outs {
            if c == elem {
                self.disards.append(elem)
                self.outs.remove(at: i)
            }
            i += 1
        }
    }
}

extension Array {
    mutating func randomize() {
        var j = 0

        for i in 0 ..< self.count {
            j = Int(arc4random_uniform(UInt32(self.count)))
            if i != j {
                self.swapAt(i, j)
            }
        }
    }
}
