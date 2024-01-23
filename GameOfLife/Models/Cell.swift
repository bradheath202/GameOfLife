//
//  Cell.swift
//  GameOfLife
//
//  Created by Brad Heath on 1/22/24.
//

import Foundation

struct Cell {
    var state: State

    enum State: Int, CaseIterable {
        case dead
        case alive
    }
    
    init(state: State = .dead) {
        self.state = state
    }
}
