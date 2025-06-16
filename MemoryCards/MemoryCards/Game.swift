//
//  Game.swift
//  MemoryCards
//
//  Created by Jessica Sun on 08/06/25.
//

import SwiftUI

struct Game: View {
    @EnvironmentObject var cardModel: CardModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .white, .black, .gray, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                if case .memorizing = cardModel.gameState {
                    VStack {
                        Text("Remember card locations!")
                            .font(.custom("American Typewriter", size: 25))
                            .foregroundColor(.red)
                        
                        Text("COUNTDOWN: \(cardModel.remainingTime)")
                            .font(.system(size: 40, weight: .bold, design: .monospaced))
                            .foregroundColor(.red)
                    }
                    .padding(.bottom, 20)
                }
                
                
                if case .playing(let player) = cardModel.gameState {
                    HStack {
                        VStack(alignment: .leading) {
                            if cardModel.gameMode == .singlePlayer {
                                Text("Remaining mistakes: \(cardModel.remainingMistakes)")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                            
                            if cardModel.gameMode == .twoPlayer {
                                Text("PLAYER \(player)")
                                    .font(.title.bold())
                                    .foregroundColor(player == 1 ? .blue : .red)
                            }
                            Text("Matched cards: \(cardModel.matchedCards)/\(cardModel.cards.count/2)")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding()
                }
                
                ScrollView(.horizontal) {
                    HStack {
                        Color.clear
                            .frame(minWidth: 0, maxWidth: .infinity)
                        
                        LazyHGrid(rows: Array(repeating: GridItem(.flexible(minimum: 180, maximum: 180)), count: 3), spacing: 15) {
                            ForEach(cardModel.cards) { card in
                                ACard(card: card)
                                    .scaleEffect(card.isMatched ? 1.02 : 1.0)
                                    .shadow(color: card.isMatched ? .yellow : .clear, radius: 3)
                                    .animation(
                                        .spring(response: 0.3, dampingFraction: 0.5).repeatCount(3, autoreverses: true),
                                        value: card.isMatched
                                    )
                                    .onTapGesture {
                                        cardModel.selectCard(card)
                                    }
                                    .disabled(card.isMatched || cardModel.gameState == .memorizing)
                            }
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        Color.clear
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .frame(minWidth: UIScreen.main.bounds.width)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
}

#Preview("memorizing") {
    let cardModel = CardModel()
    cardModel.gameState = .memorizing
    cardModel.remainingTime = 5
    
    return Game()
        .environmentObject(cardModel)
}

#Preview("Playing (1 Player)") {
    let cardModel = CardModel()
    cardModel.gameState = .playing(player: 1)
    cardModel.remainingMistakes = 2
    cardModel.matchedCards = 3
    
    return Game()
        .environmentObject(cardModel)
}

#Preview("Playing (2 Players)") {
    let cardModel = CardModel()
    cardModel.gameState = .playing(player: 1)
    cardModel.gameMode = .twoPlayer
    cardModel.matchedCards = 3
    
    return Game()
        .environmentObject(cardModel)
}
