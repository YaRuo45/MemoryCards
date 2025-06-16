//
//  GameResult.swift
//  MemoryCards
//
//  Created by Jessica Sun on 08/06/25.
//

import SwiftUI

struct GameResult: View {
    @EnvironmentObject var cardModel: CardModel
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                if cardModel.gameMode == .singlePlayer {
                    Text(cardModel.matchedCards == cardModel.cards.count/2 ? "🎉 Win!" : "❌ LOSE")
                        .font(.largeTitle.bold())
                        .foregroundColor(cardModel.matchedCards == cardModel.cards.count/2 ? .green : .red)
                } else {
                    if cardModel.playerScores[0] > cardModel.playerScores[1] {
                        Text("🏆 Player 1 wins!")
                            .font(.largeTitle.bold())
                            .foregroundColor(.green)
                    } else if cardModel.playerScores[1] > cardModel.playerScores[0] {
                        Text("🏆 Player 2 wins!")
                            .font(.largeTitle.bold())
                            .foregroundColor(.green)
                    } else {
                        Text("🤝 No winner!")
                            .font(.largeTitle.bold())
                            .foregroundColor(.yellow)
                    }
                    
                    HStack(spacing: 30) {
                        Label(" \(cardModel.playerScores[0])", systemImage: "p1.button.horizontal.fill")
                        Spacer()
                        Label(" \(cardModel.playerScores[1])", systemImage: "p2.button.horizontal.fill")
                    }
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding()
                }
                
                Button(action: {
                    cardModel.resetGame()
                }) {
                    Label("Restart", systemImage: "restart.circle.fill")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                .padding(.top, 100)
                   
            }
        }
    }
}

#Preview("1 Player") {
    let cardModel = CardModel()
    cardModel.matchedCards = 5
    
    return GameResult()
        .environmentObject(cardModel)
}

#Preview("2 Player") {
    let cardModel = CardModel()
    cardModel.gameMode = .twoPlayer
    cardModel.playerScores[0] = 5
    cardModel.playerScores[1] = 5
    
    return GameResult()
        .environmentObject(cardModel)
}
