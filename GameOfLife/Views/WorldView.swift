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
                        .padding(.trailing, 2.5)
                        
                        Spacer()
                        
                        Button {
                            viewModel.randomReset()
                        } label: {
                            Label("Randomize", systemImage: "shuffle.circle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .padding(.trailing, 10)
                        .padding(.leading, 2.5)
                    }
                    // Automatic progression controls
                    HStack {
                        
                        Button {
                            viewModel.isAutoStepOn ?
                            viewModel.stopAutoStepping() : viewModel.startAutoStepping()
                        } label: {
                            Label(viewModel.isAutoStepOn ? "Pause" : "Play",
                                  systemImage: viewModel.isAutoStepOn ?
                                  "pause.circle" : "play.circle")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(viewModel.isAutoStepOn ? .darkGreen : .accentColor)
                        }
                        .padding(.leading, 10)
                        .padding(.trailing, 2.5)
                        .animation(.easeInOut(duration: 0.15), value: viewModel.isAutoStepOn)
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button {
                            viewModel.stepForward()
                        } label: {
                            Label("Step", systemImage: "playpause.circle")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(viewModel.isAutoStepOn)
                        .animation(.easeInOut(duration: 0.15), value: viewModel.isAutoStepOn)
                        .buttonStyle(.bordered)
                        .padding(.trailing, 10)
                        .padding(.leading, 2.5)
                    }
                    .padding([.top, .bottom], 5)
                    
                    Spacer()
                    
                    // Speed controls
                    HStack {
                        VStack {
                           
                            Slider(value: $viewModel.timerSpeed, in: 1...10)
                                .onChange(of: viewModel.timerSpeed) {
                                    if viewModel.isAutoStepOn {
                                        viewModel.restartAutoStepping()
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
