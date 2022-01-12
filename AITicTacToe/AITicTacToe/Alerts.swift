//
//  Alerts.swift
//  AITicTacToe
//
//  Created by Michael Moore on 1/11/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                                    message: Text("You're smarter than the computer"),
                                    buttonTitle: Text("Hell yeah!"))
    
    static let computerWin = AlertItem(title: Text("You Lost. Wah wah wah"),
                                       message: Text("You programmed a super AI"),
                                       buttonTitle: Text("Rematch?"))
    
    static let draw = AlertItem(title: Text("Draw"),
                                message: Text("A true battle of wits"),
                                buttonTitle: Text("Try again"))
}
