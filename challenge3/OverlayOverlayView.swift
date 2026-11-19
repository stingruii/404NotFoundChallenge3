//
//  OverlayOverlayView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 13/11/26.
//

import SwiftUI

struct OverlayOverlayView: View {
    
//    @Binding var explainedButtons: Set<String>
    @Binding var pressedButton: String
    
    var body: some View {
        ZStack{
            CompositionsView(pressedButton: $pressedButton)
            
            //            ChatBubbleShapeView(/*explainedButtons: $explainedButtons*/)
            ChatBubbleShapeView(pressedButton: $pressedButton)
        }
    }
}

#Preview {
    ZStack {
//        Color.black
//            .ignoresSafeArea()

        OverlayOverlayView(pressedButton: .constant("0"))
    }
}
