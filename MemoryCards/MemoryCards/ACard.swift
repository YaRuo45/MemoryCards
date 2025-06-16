//
//  ACard.swift
//  MemoryCards
//
//  Created by Jessica Sun on 28/05/25.
//

import SwiftUI

struct ACard: View {
    var card: Card
    
    var body: some View {
        ZStack {
            if card.isFaceUp || card.isMatched {
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.yellow, lineWidth: 2))
            } else {
                Image("card back")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
            }
        }
        .rotation3DEffect(
            .degrees(card.isFaceUp || card.isMatched ? 0 : 180),
            axis: (x: 0, y: 1, z: 0))
        .animation(
            .spring(response: 0.4, dampingFraction: 0.6), value: card.isFaceUp)
    }
}

#Preview {
    ACard(card: Card(id: UUID(), imageName: "card1"))
}
