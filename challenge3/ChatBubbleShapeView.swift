//
//  ChatBubbleShapeView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 12/11/26.
//

import SwiftUI

//struct ChatBubbleShape: Shape {
//
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//
//        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
//        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//
//        return path
//    }
//}


struct ChatBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        let scale = min(width, height) / 100

        let corner = 20 * scale
        let inset = 4 * scale
        let tailStart = 25 * scale
        let tailEnd = 11 * scale

        return Path { p in
            p.move(to: CGPoint(x: tailStart, y: height))

            p.addLine(to: CGPoint(x: width - corner, y: height))
            p.addCurve(
                to: CGPoint(x: width, y: height - corner),
                control1: CGPoint(x: width - 8 * scale, y: height),
                control2: CGPoint(x: width, y: height - 8 * scale)
            )

            p.addLine(to: CGPoint(x: width, y: corner))
            p.addCurve(
                to: CGPoint(x: width - corner, y: 0),
                control1: CGPoint(x: width, y: 8 * scale),
                control2: CGPoint(x: width - 8 * scale, y: 0)
            )

            p.addLine(to: CGPoint(x: corner + scale, y: 0))
            p.addCurve(
                to: CGPoint(x: inset, y: corner),
                control1: CGPoint(x: 12 * scale, y: 0),
                control2: CGPoint(x: inset, y: 8 * scale)
            )

            p.addLine(to: CGPoint(x: inset, y: height - tailEnd))

            p.addCurve(
                to: CGPoint(x: 0, y: height),
                control1: CGPoint(x: inset, y: height - scale),
                control2: CGPoint(x: 0, y: height)
            )

            p.addLine(to: CGPoint(x: -0.05 * scale, y: height - 0.01 * scale))

            p.addCurve(
                to: CGPoint(x: tailEnd, y: height - 4 * scale),
                control1: CGPoint(x: 4 * scale, y: height + 0.5 * scale),
                control2: CGPoint(x: 8 * scale, y: height - scale)
            )

            p.addCurve(
                to: CGPoint(x: tailStart, y: height),
                control1: CGPoint(x: 16 * scale, y: height),
                control2: CGPoint(x: 20 * scale, y: height)
            )

            p.closeSubpath()
        }
    }
}


struct ChatBubbleShapeView: View {
    
//    @Binding var tutorial1: String?
    private var edgeInset: CGFloat {
        UIScreen.main.bounds.width / 1.5
    }
    
    var body: some View {
        
        Text("Hiiiiiii")
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background {
                ChatBubbleShape()
                    .fill(Color.black.opacity(0.1))
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.trailing, edgeInset)
        
//        ChatBubbleShape()
//            .stroke(Color.black.opacity(0.5), lineWidth: 3)
//            .frame(width: 100, height: 100)

    }
}



#Preview {
    ChatBubbleShapeView()
}

