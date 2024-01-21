//
//  WorldView.swift
//  GameOfLife
//
//  Created by Brad Heath on 1/20/24.
//

import SwiftUI

struct WorldView: View {
    @State private var viewModel = WorldViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 1) {
                Text("Generation: \(viewModel.generation)").padding(10)
                    .foregroundColor(.grayText)
                ForEach(0..<viewModel.gridDimension, id: \.self) { row in
                    HStack(spacing: 1) {
                        ForEach(0..<viewModel.gridDimension, id: \.self) { column in
                            CellView(isAlive: $viewModel.cells[row][column])
                        }
                    }
                }
                Spacer().frame(height: 10)
                /// Controls
                VStack {
                    HStack {
                        Button {
                            viewModel.reset()
                        } label: {
                            Label("Reset", systemImage: "arrow.clockwise.circle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .padding(.leading, 10)
                        
                        Spacer()
                        
                        Button {
                            viewModel.randomReset()
                        } label: {
                            Label("Randomize", systemImage: "shuffle.circle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .padding(.trailing, 10)
                    }
                    // Automatic progression controls
                    HStack {
                        
                        Button {
                            viewModel.startAutomaticProgression()
                        } label: {
                            Label("Play", systemImage: "play.circle")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(viewModel.isAutomaticallyProgressing ? .darkGreen : .accentColor)
                        }
                        .padding([.leading], 10)
                        .buttonStyle(.bordered)
                        
                        Button {
                            viewModel.stopAutomaticProgression()
                        } label: {
                            Label("Pause", systemImage: "pause.circle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button {
                            viewModel.randomReset()
                        } label: {
                            Label("Step", systemImage: "playpause.circle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .padding(.trailing, 10)
                    }
                    .padding([.top, .bottom], 5)
                    
                    // Speed controls
                    HStack {
                        VStack {
                           
                            Slider(value: $viewModel.timerSpeed, in: 1...10)
                                .onChange(of: viewModel.timerSpeed) {
                                    if viewModel.isAutomaticallyProgressing {
                                        viewModel.restartAutomaticProgression()
                                    }
                                }
                                .padding([.leading, .trailing])
                            
                            Text("Speed: \(Int(viewModel.timerSpeed))")
                                .foregroundColor(.grayText)
                        }
                    }
                }
                
                
            }
            .navigationTitle("Game of Life")
        }
        
    }
}

#Preview {
    WorldView()
}
