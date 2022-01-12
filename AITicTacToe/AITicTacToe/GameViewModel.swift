//
//  GameViewModel.swift
//  AITicTacToe
//
//  Created by Michael Moore on 1/11/22.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        guard !spaceIsOccupied(at: position, in: moves) else { return }
        
        // human move
        moves[position] = Move(player: .human, boardIndex: position)
        
        if checkWinCondition(for: .human) {
            alertItem = AlertContext.humanWin
            return
        } else if checkDrawCondition() {
            alertItem = AlertContext.draw
            return
        }
        
        isBoardDisabled = true
        
        // computer move
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputersNextPosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isBoardDisabled = false
            
            if checkWinCondition(for: .computer) {
                alertItem = AlertContext.computerWin
                return
            } else if checkDrawCondition() {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func spaceIsOccupied(at index: Int, in moves: [Move?]) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputersNextPosition(in moves: [Move?]) -> Int {
        // If AI can win, then win
        // If it can't win, this also checks to see if it can block
        if let powerPosition = checkComputerWinOrBlock(with: .computer, moves: moves) {
            return powerPosition
        }
        
        // If AI can't block, then take center square
        let centerSquare = 4
        if !spaceIsOccupied(at: centerSquare, in: moves) {
            return centerSquare
        }
        
        // If AI can't take middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        while spaceIsOccupied(at: movePosition, in: moves) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkComputerWinOrBlock(with player: Player, moves: [Move?]) -> Int? {
        let playedMoves = moves.compactMap{ $0 }.filter{ $0.player == player }
        let playerPositions = Set(playedMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(playerPositions)
            if winPositions.count == 1 {
                let isAvailable = !spaceIsOccupied(at: winPositions.first!, in: moves)
                if isAvailable {
                    return winPositions.first!
                }
            }
        }
        
        // if we've reached this point on the first go around, the computer can't win, so we check to see if we can block
        // if we've reached this point on the second go around, the computer can't block either
        return player == .human ? nil : checkComputerWinOrBlock(with: .human, moves: moves)
    }
    
    func checkWinCondition(for player: Player) -> Bool {
        let playerMoves = moves.compactMap{ $0 }.filter{ $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        
        return false
    }
    
    func checkDrawCondition() -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}

