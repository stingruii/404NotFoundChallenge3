//
//  OverlayOverlayView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 13/11/26.
//

import SwiftUI

struct OverlayOverlayView: View {
    
    @State private var cameraImage: UIImage?
//    @Binding var explainedButtons: Set<String>
    @Binding var pressedButton: String
    
    var body: some View {
        VStack{
            ZStack{
                CameraView(image: $cameraImage)
                
                CompositionsView(pressedButton: .constant("0"))
                
                //            ChatBubbleShapeView(/*explainedButtons: $explainedButtons*/)
                ChatBubbleShapeView(pressedButton: $pressedButton)
                
            }
        }
    }
}

#Preview {
//    OverlayOverlayView(/*explainedButtons: .constant(["0"])*/)
    OverlayOverlayView(pressedButton: .constant("0"))
}
