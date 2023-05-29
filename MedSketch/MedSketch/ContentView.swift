//
//  ContentView.swift
//  MedSketch
//
//  Created by 村上由侑 on 2023/05/29.
//

import SwiftUI


struct DrawLine: Identifiable {
    static var idCount: Int = 0
    var id: String
    var points: [CGPoint]
    var lineWidth: CGFloat // ペンの太さ
    
    static func makeDrawLine(points: [CGPoint], lineWidth: CGFloat) -> DrawLine {
        let line = DrawLine(id: "\(DrawLine.idCount)", points: points, lineWidth: lineWidth)
        DrawLine.idCount += 1
        return line
    }
}

struct ContentView: View {
    // すでに描いたLine
    @State private var lines: [DrawLine] = []
    // いまドラッグ中のLine
    @State private var currentLine: DrawLine?
    // ペンの太さ
    @State private var lineWidth: CGFloat = 1.0
    
    var body: some View {
        VStack {
            // リセットボタン
            Button(action: {
                lines = []
            }, label: {
                Text("Clear")
            })
            
            HStack {
                // ペンの太さ変更ボタン
                Button(action: {
                    lineWidth = 1.0
                }, label: {
                    Text("Small")
                })
                Button(action: {
                    lineWidth = 3.0
                }, label: {
                    Text("Medium")
                })
                Button(action: {
                    lineWidth = 5.0
                }, label: {
                    Text("Large")
                })
            }
            .padding()
            
            ZStack {
                // Canvas部分
                Rectangle()
                    .fill(Color.white)
                    .border(Color.black, width: 1)
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ value in
                                if currentLine == nil {
                                    currentLine = DrawLine.makeDrawLine(points: [], lineWidth: lineWidth)
                                }
                                guard var line = currentLine else { return }
                                line.points.append(value.location)
                                currentLine = line
                            })
                            .onEnded({ value in
                                guard var line = currentLine else { return }
                                line.points.append(value.location)
                                lines.append(line)
                                // リセット
                                currentLine = nil
                            })
                    )
                
                // 追加ずみのLineの描画
                ForEach(lines) { line in
                    Path { path in
                        path.addLines(line.points)
                    }
                    .stroke(Color.red, lineWidth: line.lineWidth)
                }
                .clipped()
                
                // ドラッグ中のLineの描画
                Path { path in
                    guard let line = currentLine else { return }
                    path.addLines(line.points)
                }
                .stroke(Color.red, lineWidth: lineWidth)
                .clipped()
            }
            .padding(20)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
