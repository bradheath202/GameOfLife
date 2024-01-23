//
//  GameOfLifeTests.swift
//  GameOfLifeTests
//
//  Created by Brad Heath on 1/20/24.
//

import XCTest
@testable import GameOfLife

final class GameOfLifeTests: XCTestCase {

    /// Test the simplest oscillator - Blinker
    func testBlinker() throws {
        let blinkerCells = [
            [Cell(), Cell(state: .alive), Cell()],
            [Cell(), Cell(state: .alive), Cell()],
            [Cell(), Cell(state: .alive), Cell()],
        ]
        
        let blinkerCellsSteps = [
            [Cell(), Cell(), Cell()],
            [Cell(state: .alive), Cell(state: .alive), Cell(state: .alive)],
            [Cell(), Cell(), Cell()],
        ]
        
        let worldViewModel = WorldViewModel(gridDimension: blinkerCells.count)
        
        worldViewModel.cells = blinkerCells
        worldViewModel.stepForwardBy(11)
        
        XCTAssertEqual(worldViewModel.cells, blinkerCellsSteps)
        
        worldViewModel.stepForwardBy(19)
        
        XCTAssertEqual(worldViewModel.cells, blinkerCells)
    }
       
    /// Test the simplest spaceship - Glider
    ///
    /// After 4 iterations, this glider's initial shape will reappear, and it will be translated
    /// down one row and over one column.
    func testGlider() throws {
        let gliderCells = [
            [Cell(state: .alive), Cell(),               Cell(state: .alive), Cell()],
            [Cell(),              Cell(state: .alive),  Cell(state: .alive), Cell()],
            [Cell(),              Cell(state: .alive),  Cell(),              Cell()],
            [Cell(),              Cell(),               Cell(),              Cell()]
        ]
        
        let gliderCellsAfter4Steps = [
            [Cell(),              Cell(),               Cell(),              Cell()],
            [Cell(),              Cell(state: .alive),  Cell(),              Cell(state: .alive)],
            [Cell(),              Cell(),               Cell(state: .alive), Cell(state: .alive)],
            [Cell(),              Cell(),               Cell(state: .alive),              Cell()]
        ]
        
        let worldViewModel = WorldViewModel(gridDimension: gliderCells.count)
        
        worldViewModel.cells = gliderCells
        worldViewModel.stepForwardBy(4)
        
        XCTAssertEqual(worldViewModel.cells, gliderCellsAfter4Steps)
    }

}
