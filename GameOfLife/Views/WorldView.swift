//
//  WorldView.swift
//  GameOfLife
//
//  Created by Brad Heath on 1/20/24.
//

import SwiftUI

struct WorldView: View {
    let gridDimension = 20
    @State private var cells = Array(repeating: Array(repeating: false, count: 20), count: 20)
    @State private var generation = 0
    
    var body: some View {
        VStack(spacing: 1) {
            Text("Generation: \(generation)").padding(10)
            ForEach(0..<gridDimension, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(0..<gridDimension, id: \.self) { column in
                        CellView(isAlive: $cells[row][column])
                    }
                }
            }
            HStack {
                Button("Reset") {
                    cells = Array(repeating: Array(repeating: false, count: 20), count: 20)
                }
                .padding(10)
                Spacer()
                Button("Step Forward") {
                    stepForward()
                }
                .padding(10)
            }
            
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
    
    private func stepForward() {
        var newCells = cells
        for row in 0..<gridDimension {
            for column in 0..<gridDimension {
                let adjacentCellCount = adjacentCellCountForRow(row, andColumn: column)
                if cells[row][column] { // cell is alive
                    if adjacentCellCount < 2 || adjacentCellCount > 3 {
                        newCells[row][column] = false // cell is dead
                    }
                } else { // cell is dead
                    if adjacentCellCount == 3 {
                        newCells[row][column] = true
                    }
                }
            }
        }
        
        cells = newCells
        generation += 1
    }
    
    private func adjacentCellCountForRow(_ row: Int, andColumn column: Int) -> Int {
        var count = 0
        for rowIndex in -1...1 {
            for columnIndex in -1...1 {
                let adjustedRow = row + rowIndex
                let adjustedColumn = column + columnIndex
                
                if adjustedRow >= 0 && adjustedRow < gridDimension && adjustedColumn >= 0 && adjustedColumn < gridDimension {
                    if cells[adjustedRow][adjustedColumn] && !(rowIndex == 0 && columnIndex == 0) {
                        count += 1
                    }
                }
            }
        }
        
        return count
    }
}

#Preview {
    WorldView()
}
