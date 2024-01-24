//
//  WorldView.swift
//  GameOfLife
//
//  Created by Brad Heath on 1/20/24.
//

import SwiftUI

struct WorldView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @State private var viewModel = WorldViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 1) {
                Text("Generation: \(viewModel.generation)").padding(10)
                    .foregroundColor(.grayText)
                ForEach(0..<viewModel.gridDimension, id: \.self) { row in
                    HStack(spacing: 1) {
                        ForEach(0..<viewModel.gridDimension, id: \.self) { column in
                            CellView(cell: $viewModel.cells[row][column])
                        }
                    }
                }
                
                Spacer().frame(height: 10)
                
                // Controls
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
                            viewModel.reset(randomize: true)
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
                            viewModel.stopAutoStepping() : 
                            viewModel.startAutoStepping()
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
                        .frame(height: 15)
                    
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
                
                Spacer()
            }
            .navigationTitle("Game of Life")
//            .navigationBarItems(
//                trailing: 
//                    HStack {
//                        Button("", systemImage: "square.and.arrow.up") {
//                            // TODO: load
//                            print("==== load")
//                        }
//                        VStack {
//                            Spacer()
//                                .frame(height: 4)
//                            Button("", systemImage: "square.and.pencil") {
//                                // TODO: save
//                                print("==== save")
//                            }
//                        }
//                    }
//            )
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background, .inactive:
                print("=== background or inactive")
                viewModel.stopAutoStepping()
            case .active:
                break
            @unknown default:
                break
            }
            
        }
    }
}

#Preview {
    WorldView()
}
