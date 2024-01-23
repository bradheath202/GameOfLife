//
//  Cell.swift
//  GameOfLife
//
//  Created by Brad Heath on 1/22/24.
//

import Foundation

struct Cell: Equatable {
    var state: State

    enum State: Int, CaseIterable {
        case dead
        case alive
    }
    
    init(state: State = .dead) {
        self.state = state
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.state == rhs.state
    }
}
