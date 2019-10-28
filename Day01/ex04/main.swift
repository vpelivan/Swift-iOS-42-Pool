import Foundation

var myDeck = Deck(arg: false)

print("\nBoolean constructor randomizer test:")
print(myDeck)

var x: Card?

x = myDeck.draw()
x = myDeck.draw()
x = myDeck.draw()
x = myDeck.draw()
x = myDeck.draw()
x = myDeck.draw()
x = myDeck.draw()
x = myDeck.draw()
x = myDeck.draw()
x = myDeck.draw()

print("\nOut, Disard, Fold deck tests:")
for i in myDeck.outs {
	    print("\(i)")
}
myDeck.fold(c: myDeck.outs[0])
myDeck.fold(c: myDeck.outs[1])
myDeck.fold(c: myDeck.outs[2])
myDeck.fold(c: myDeck.outs[3])

for i in myDeck.cards {
    print(i)
}

for i in myDeck.disards {
        print("disards[] = \(i)")
}

for i in myDeck.outs {
        print("outs[] = \(i)")
}
