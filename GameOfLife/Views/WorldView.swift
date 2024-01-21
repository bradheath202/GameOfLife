//
//  WorldView.swift
//  GameOfLife
//
//  Created by Brad Heath on 1/20/24.
//

import SwiftUI
import Combine

struct WorldView: View {
    @State private var cells: [[Bool]]
    @State private var generation = 0
    
    var gridDimension: Int
    
    private var cancellables = Set<AnyCancellable>()
    
    init(gridDimension: Int = 25) {
        self.gridDimension = gridDimension
        cells = Array(repeating: Array(repeating: false, count: gridDimension), count: gridDimension)
    }
    
    var body: some View {
        VStack(spacing: 1) {
            Text("Generation: \(generation)").padding(10)
            ForEach(0..<gridDimension, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(0..<gridDimension, id: \.self) { column in
                        CellView(isAlive: $cells[row][column])
//                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
            
            // Controls
            HStack {
                Button("Reset") {
                    cells = Array(repeating: Array(repeating: false, count: gridDimension), count: gridDimension)
                    generation = 0
                }
                .padding(10)
                Button("Randomize") {
                    cells = createRandomCells(gridDimension: gridDimension)
                    generation = 0
                }
                .padding(10)
                Spacer()
//                Button("▶️") {
//                     startTimerProgression()
//                }
//                .padding(10)
//                Button("⏹️") {
//                     stopTimerProgression()
//                }
//                .padding(10)
                Button("Step Forward") {
                    stepForward()
                }
                .padding(10)
            }
            
        }
        .aspectRatio(0.85, contentMode: .fit)
        .onAppear {
            cells = createRandomCells(gridDimension: gridDimension)
        }
    }
    
    private var cellSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding = 1 // Adjust as needed
        
        return (screenWidth - CGFloat(padding * 2)) / CGFloat(gridDimension)
    }
    
    private func stepForward() {
        var newCells = cells
        for row in 0..<gridDimension {
            for column in 0..<gridDimension {
                let adjacentCellCount = adjacentCellCountForRow(row, andColumn: column)
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
    
    private mutating func startTimerProgression() {
//        Timer.publish(every: 0.5, on: .main, in: .common)
//            .autoconnect()
//            .sink { [self] _ in
//                self.stepForward()
//            }
//            .store(in: &cancellables)
        
    }
    
    private mutating func stopTimerProgression() {
        cancellables.removeAll()
    }
}

#Preview {
    WorldView()
}
