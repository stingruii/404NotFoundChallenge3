//
//  ChatBubbleShapeView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 12/11/26.
//

import SwiftUI

struct ChatBubbleShapeView: View {
    
    //    @Binding var tutorial1: String?
    
    //    @Binding var explainedButtons: Set<String>
    @Binding var pressedButton: String
    @State var notedButton = false
    
    //    private var edgeInset: CGFloat {
    //        UIScreen.main.bounds.width / 2
    //    }
    
    var body: some View {
        if !notedButton, let text = message {
            bubble(text)
        }
    }
    
    private var message: String? {
        switch pressedButton {
        case "0":
            return "Take pictures from direct eye level with the object you want to take."
        case "1":
            return "Take a close up picture. Imagine how far you will stand if you have one on one conversation with the object."
        case "2":
            return "Take a picture that shows the entire body and background/ surrounding"
        case "3":
            return "Hold the camera down, angled upwards at the object"
        case "4":
            return "Hold the camera above eye level, downwards at the object"
        case "5":
            return "Physically tilt your camera."
        case "6":
            return "Physically position yourself, find distorted objects to get an interesting perspective."
        case "7":
            return "Place main subject along the lines or at the intersection points of the grid."
        case "8":
            return "Place your subject in most center. Look out for a place where both sides mirror each other."
        case "9":
            return "Uses environmental elements that can act as a natural border around your main subject."
        case "10":
            return "Leave large, empty areas around your subject."
        case "11":
            return "Use repeating shapes, objects, or structures to create visual rhythms."
        case "12":
            return "Include slanted lines and triangular structures in the picture."
        case "13":
            return "Use portrait mode to blur out a messy background, greatly increasing the sharpness of the main subject."
        case "14":
            return "Using man-made structures like doorways, windows, arches, or tunnels to frame the main subject."
        case "15":
            return "Using tree branches, leaves, dense bushes, vines, or flower clusters to frame the main subject."
        case "16":
            return "Positioning shoulders, arms, hands, or other people or animals in the foreground to frame a secondary subject."
        case "17":
            return "Shooting outward or inward from under a bridge, train tunnel, or concrete overpass."
        case "18":
            return "Using repeating patterns like gates or balcony railings."
        case "19":
            return "Enclosing the main subject on only one, two, or three sides rather than a full 360-degree border."
        case "20":
            return "Use a shiny or mirrored surface, such as water, a glass window, a puddle, or a metal object, to create a natural frame around the main subject."
        case "21":
            return "Look for light source that is pointed directly at the subject."
        case "22":
            return "Move the light source closer to your subject or add a barrier to scatter the light."
        case "23":
            return "Place the light directly in front of you/ the object."
        case "24":
            return "Position the light source between 45° and 90° angle to the side of your subject."
        case "25":
            return "Place the light source behind the object."
        case "26":
            return "Use the natural light."
        case "27":
            return "Place the light source slightly above the camera."
        default:
            return nil
        }
    }
    
    private func bubble(_ text: String) -> some View {
        VStack {
            Text(text)
            Button("OK") {
                notedButton = true
            }
            .padding(.leading, 300)
        }
//        .padding(.horizontal, 15)
//        .padding(.vertical, 10)
        .padding()
        .glassEffect(in: .rect(cornerRadius: 16.0))
//        .fixedSize(horizontal: false, vertical: true)
    }
}


#Preview {
    //    ChatBubbleShapeView(/*explainedButtons: .constant(["0"])*/)
    ChatBubbleShapeView(pressedButton: .constant("0"))
}

