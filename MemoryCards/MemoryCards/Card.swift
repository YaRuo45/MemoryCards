//
//  Card.swift
//  MemoryCards
//
//  Created by Jessica Sun on 21/05/25.
//

import Foundation
import SwiftUI

struct Card: Identifiable {
    var id: UUID
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    var imageName: String
}

class CardModel: ObservableObject {
    enum GameState: Equatable {
        case initial, memorizing, playing(player: Int), finished
    }
    enum GameMode {
        case singlePlayer, twoPlayer
    }
        
    @Published var cards: [Card] = []
    @Published var gameState: GameState = .initial
    @Published var gameMode: GameMode = .singlePlayer
    @Published var remainingTime = 5
    @Published var matchedCards = 0
    @Published var remainingMistakes = 3
    @Published var currentPlayer = 1
    @Published var playerScores: [Int] = [0, 0]
    private var timer: Timer?
    
    init() {
        resetGame()
    }
    
    func resetGame() {
        timer?.invalidate()
        let images = (1...9).map { "card\($0)" }
        var newCards: [Card] = []
        for name in images {
            newCards.append(Card(id: UUID(), imageName: name))
            newCards.append(Card(id: UUID(), imageName: name))
        }
        cards = newCards.shuffled()
        gameState = .initial
        remainingTime = 5
        matchedCards = 0
        remainingMistakes = 3
        currentPlayer = 1
        playerScores = [0, 0]
    }
    
    func startGame(mode: GameMode) {
        gameMode = mode
        gameState = .memorizing
        flipAllCards(faceUp: true)
        remainingTime = 5
        
        // [weak self]: avoid memory leak
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.remainingTime -= 1
            if self.remainingTime == 0 {
                self.timer?.invalidate()
                self.flipAllCards(faceUp: false)
                self.gameState = .playing(player: 1)
            }
        }
    }
    
    func flipAllCards(faceUp: Bool) {
        for index in cards.indices {
            cards[index].isFaceUp = faceUp
        }
    }
    
    func selectCard(_ card: Card) {
        guard
            case .playing = gameState,
            !card.isMatched,
            !card.isFaceUp,
            cards.filter({ $0.isFaceUp && !$0.isMatched }).count < 2
        else { return }
        
        
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards[index].isFaceUp = true
        }
            
        checkMatches()
    }
    
    private func checkMatches() {
        let faceUpCards = cards.filter { $0.isFaceUp && !$0.isMatched }
        guard faceUpCards.count == 2 else { return }
        let card1 = faceUpCards[0]
        let card2 = faceUpCards[1]
         
        // Delays the card matching check by 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if card1.imageName == card2.imageName {
                self.handleMatchSuccess(card1: card1, card2: card2)
            } else {
                self.handleMatchFailure(card1: card1, card2: card2)
            }
        }
    }
    
    private func handleMatchSuccess(card1: Card, card2: Card) {
        if let index1 = cards.firstIndex(where: { $0.id == card1.id }),
           let index2 = cards.firstIndex(where: { $0.id == card2.id }) {
            cards[index1].isMatched = true
            cards[index2].isMatched = true
            matchedCards += 1
            
            if case .playing(let player) = gameState {
                playerScores[player-1] += 1
            }
            
            if matchedCards == cards.count / 2 {
                gameState = .finished
            }
        }
    }
    
    private func handleMatchFailure(card1: Card, card2: Card) {
        if let index1 = cards.firstIndex(where: { $0.id == card1.id }),
           let index2 = cards.firstIndex(where: { $0.id == card2.id }) {
            
            cards[index1].isFaceUp = false
            cards[index2].isFaceUp = false
            
            switch gameMode {
            case .singlePlayer:
                remainingMistakes -= 1
                if remainingMistakes == 0 {
                    gameState = .finished
                }
            case .twoPlayer:
                if case .playing(let current) = gameState {
                    let nextPlayer = current == 1 ? 2 : 1
                    gameState = .playing(player: nextPlayer)
                }
            }
        }
    }
    
}
