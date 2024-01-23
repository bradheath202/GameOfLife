//
//  CellView.swift
//  GameOfLife
//
//  Created by Brad Heath on 1/20/24.
//

import SwiftUI

struct CellView: View {
    @Binding var cell: Cell
    
    var body: some View {
        Rectangle()
            .foregroundColor(cell.state == .alive ? .blue : .dead)
            .animation(.easeInOut(duration: 0.15), value: cell.state)
            .aspectRatio(1.0, contentMode: .fit)
            .onTapGesture {
                if cell.state == .alive {
                    cell.state = .dead
                } else {
                    cell.state = .alive
                }
            }
        
    }
}

#Preview {
    CellView(cell: .constant(Cell()))
}
