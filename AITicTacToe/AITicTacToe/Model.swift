//
//  Model.swift
//  AITicTacToe
//
//  Created by Michael Moore on 1/11/22.
//

import Foundation

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    var indicator: String {
        return player == .human ? "drop.fill" : "flame"
    }
}
