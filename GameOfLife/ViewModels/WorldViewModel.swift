//
//  WorldViewModel.swift
//  GameOfLife
//
//  Created by Brad Heath on 1/21/24.
//

import SwiftUI
import Combine

@Observable
class WorldViewModel {
    var cells: [[Bool]]
    var gridDimension: Int
    
    var generation = 0
    var timerSpeed = 5.5
    var isAutoStepOn = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(gridDimension: Int = 3) {
        self.gridDimension = gridDimension
        cells = Array(repeating: Array(repeating: false, count: gridDimension), count: gridDimension)
    }
    
    func adjacentLiveCellCountForRow(_ row: Int, andColumn column: Int) -> Int {
        var count = 0
        for adjacentGridRowIndex in -1...1 { // Row above, current row, row below
            for adjacentGridColumnIndex in -1...1 { // Column to the left, current column, column to the right
                let adjustedRow = row + adjacentGridRowIndex
                let adjustedColumn = column + adjacentGridColumnIndex
                
                // Only include cells within the world
                if adjustedRow >= 0 && adjustedRow < gridDimension && 
                    adjustedColumn >= 0 && adjustedColumn < gridDimension {
                    // Only count a cell if it is alive and isn't the current cell being evaluated
                    if cells[adjustedRow][adjustedColumn] && (adjacentGridRowIndex != 0 || adjacentGridColumnIndex != 0) {
                        count += 1
                    }
                }
            }
        }
        
        return count
    }
}

/// Actions

extension WorldViewModel {
    func stepForward() {
        var newCells = cells
        for row in 0..<gridDimension {
            for column in 0..<gridDimension {
                let adjacentCellCount = adjacentLiveCellCountForRow(row, andColumn: column)
                if cells[row][column] == true { // cell is alive
                    // Any live cell with two to three neighbors survives.
                    if adjacentCellCount < 2 || adjacentCellCount > 3 {
                        newCells[row][column] = false // cell is dead
                    }
                } else { // cell is dead
                    // Any dead cell with three live neighbors becomes a live cell.
                    if adjacentCellCount == 3 {
                        newCells[row][column] = true // cell is alive
                    }
                }
            }
        }
        
        cells = newCells
        generation += 1
    }
    
    func reset() {
        cells = Array(repeating: Array(repeating: false, count: gridDimension), count: gridDimension)
        generation = 0
    }
    
    func randomReset() {
        cells = createRandomCells(gridDimension: gridDimension)
        generation = 0
    }
    
    private func createRandomCells(gridDimension: Int) -> [[Bool]] {
        var randomCells = [[Bool]]()
        
        for _ in 0..<gridDimension {
            var row = [Bool]()
            for _ in 0..<gridDimension {
                row.append(Int.random(in: 0...1) == 1)
            }
            randomCells.append(row)
        }
        
        return randomCells
    }
    
    // Automatically update state at a varying rate
    func startAutoStepping() {
        isAutoStepOn = true
        Timer.publish(every: 1.0 / timerSpeed, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.stepForward()
            }
            .store(in: &cancellables)
        
    }
    
    func stopAutoStepping() {
        isAutoStepOn = false
        cancellables.removeAll()
    }
    
    func restartAutoStepping() {
        stopAutoStepping()
        startAutoStepping()
    }
}
