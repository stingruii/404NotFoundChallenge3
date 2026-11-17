//
//  CompositionsView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 12/11/26.
//

import SwiftUI

struct TheRuleOfThirds: Shape{
    func path(in rect: CGRect) -> Path{
        var path = Path()
        
        //        Path { path in
        path.move(to: CGPoint(x: rect.width / 3, y: 0))
        path.addLine(to: CGPoint(x: rect.width / 3, y: rect.height))
        
        path.move(to: CGPoint(x: rect.width / 3 * 2, y: 0))
        path.addLine(to: CGPoint(x: rect.width / 3 * 2, y: rect.height))
        
        path.move(to: CGPoint(x: 0, y: rect.height / 3))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 3))
        
        path.move(to: CGPoint(x: 0, y: rect.height / 3 * 2))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 3 * 2))
        return path
    }
}

struct CentreComposition: Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return path
    }
}

struct Triangle: Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        
        return path
    }
}

struct NegativeSpace: Shape{
    func path(in rect: CGRect) -> Path{
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return path
    }
}

struct CompositionsView: View {
    
    @Binding var pressedButton: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                
                //                //
                TheRuleOfThirds()
                    .stroke(Color.black.opacity(0.5), lineWidth: 2)
                
                //                                CentreComposition()
                //                                    .stroke(Color.black.opacity(0.5), lineWidth: 2)
                //                                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 3.8)
                //                                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                //                                Triangle()
                //                                    .stroke(Color.black.opacity(0.5), lineWidth: 2)
                //                                    .frame(width: geometry.size.width / 4 * 3, height: geometry.size.height / 3)
                //                                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                //                HStack{
                //                    NegativeSpace()
                //                        .fill(.black.opacity(0.2))
                //                        .stroke(Color.black.opacity(0.5), lineWidth: 2)
                //                        .position(x: geometry.size.width / 4, y: geometry.size.height / 4)
                //
                //                    NegativeSpace()
                //                        .fill(.black.opacity(0.2))
                //                        .stroke(Color.black.opacity(0.5), lineWidth: 2)
                //                        .position(x: geometry.size.width / 2, y: geometry.size.height / 4)
                //                }
                
            }
        }
    }
}

#Preview {
    CompositionsView(pressedButton: .constant("0"))
}
