//
//  CellView.swift
//  GameOfLife
//
//  Created by Brad Heath on 1/20/24.
//

import SwiftUI

struct CellView: View {
    @Binding var isAlive: Bool
    
    var body: some View {
        Rectangle()
            .foregroundColor(isAlive ? .blue : .dead)
            .animation(.easeInOut(duration: 0.15), value: isAlive)
            .aspectRatio(1.0, contentMode: .fit)
            .onTapGesture {
                isAlive.toggle()
            }
        
    }
}

#Preview {
    CellView(isAlive: .constant(true))
}
