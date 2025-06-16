//
//  ContentView.swift
//  MemoryCards
//
//  Created by Jessica Sun on 21/05/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cardModel: CardModel
    
    var body: some View {
        if cardModel.gameState == .initial {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                Image("card back")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .padding(50)
                    .shadow(radius: 20)
                    .opacity(0.7)
                
                VStack(spacing: 20) {
                    Button(action: {
                        cardModel.startGame(mode: .singlePlayer)
                    }) {
                        Label("1 Player", systemImage: "flag.pattern.checkered")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(width: 200, height: 60)
                            .background(Color.green)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                                
                    Button(action: {
                        cardModel.startGame(mode: .twoPlayer)
                    }) {
                        Label("2 Players", systemImage: "flag.pattern.checkered.2.crossed")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(width: 200, height: 60)
                            .background(Color.red)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                }
            }
        } else if cardModel.gameState == .finished {
            GameResult()
        } else {
            Game()
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(CardModel())
}


