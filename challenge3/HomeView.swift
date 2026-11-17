//
//  HomeView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 13/11/26.
//

import SwiftUI
import UIKit
struct HomeView: View {
    @State private var assignmentImages: [String: UIImage] = [:]
    @State var pressedButton: String = ""
    @State private var showExplain = false
    @State private var showCamera = false
    @State private var showResult = false
    @State var explainedButtons: Set<String> = []
    @State private var cameraImage: UIImage?
    @State private var resultImage: UIImage?
    private var edgeInset: CGFloat {
        UIScreen.main.bounds.width / 4
    }
    private var edgeInsetForSpeechBubble: CGFloat {
        UIScreen.main.bounds.width / 1.5
    }
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    Spacer()
                    Spacer()
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                Color.black
                            )
                            .frame(width: 300, height: 90)
                            .shadow(color: Color.gray.opacity(0.7), radius: 20, y: 8)
                            .overlay {
                                HStack(spacing: 6) {
                                    Text("Angle")
                                        .foregroundColor(.white)
                                        .font(.largeTitle)
                                    Image(systemName: "angle")
                                        .font(.largeTitle.bold())
                                        .foregroundColor(.white)
                                }
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
                            }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        if explainedButtons.contains("0") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Button {
                            pressedButton = "0"
                            if explainedButtons.contains("0") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("0")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.red.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.red.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["0"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, edgeInset)
                    HStack {
                        Button {
                            pressedButton = "1"
                            if explainedButtons.contains("1") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("1")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.orange.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.orange.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["1"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("1") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                    HStack {
                        Spacer()
                        if explainedButtons.contains("2") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Button {
                            pressedButton = "2"
                            if explainedButtons.contains("2") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("2")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.yellow.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.yellow.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["2"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, edgeInset)
                    HStack {
                        Button {
                            pressedButton = "3"
                            if explainedButtons.contains("3") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("3")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.green.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.green.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["3"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("3") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                    HStack {
                        Spacer()
                        if explainedButtons.contains("4") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Button {
                            pressedButton = "4"
                            if explainedButtons.contains("4") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("4")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.blue.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.blue.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["4"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, edgeInset)
                    HStack {
                        Button {
                            pressedButton = "5"
                            if explainedButtons.contains("5") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("5")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.indigo.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.indigo.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["5"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("5") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                    VStack(spacing: 70) {
                        HStack {
                            Spacer()
                            if explainedButtons.contains("6") {
                                Button("Explain") {
                                    showExplain = true
                                }
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.cyan)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.white.opacity(0.12))
                                .clipShape(Capsule())
                            }
                            Button {
                                pressedButton = "6"
                                if explainedButtons.contains("6") {
                                    showCamera = true
                                } else {
                                    explainedButtons.insert("6")
                                    showExplain = true
                                }
                            } label: {
                                Circle()
                                    .fill(Color.purple.gradient)
                                    .frame(width: 100, height: 100)
                                    .shadow(color: Color.purple.opacity(0.8), radius: 12)
                                    .overlay {
                                        if let image = assignmentImages["6"] {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                        }
                                    }
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.trailing, edgeInset)
                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    Color.black
                                )
                                .frame(width: 300, height: 90)
                                .shadow(color: Color.gray.opacity(0.7), radius: 20, y: 8)
                                .overlay {
                                    HStack(spacing: 6) {
                                        Text("Composition")
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
                                        Image(systemName: "aspectratio")
                                            .font(.title3.bold())
                                            .foregroundColor(.white)
                                    }
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                                }
                            Spacer()
                        }
                    }
                    HStack {
                        Button {
                            pressedButton = "7"
                            if explainedButtons.contains("7") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("7")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.red.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.red.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["7"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("7") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                    HStack {
                        Spacer()
                        if explainedButtons.contains("8") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Button {
                            pressedButton = "8"
                            if explainedButtons.contains("8") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("8")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.orange.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.orange.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["8"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, edgeInset)
                    HStack {
                        Button {
                            pressedButton = "9"
                            if explainedButtons.contains("9") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("9")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.yellow.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.yellow.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["9"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("9") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                    HStack {
                        Spacer()
                        if explainedButtons.contains("10") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Button {
                            pressedButton = "10"
                            if explainedButtons.contains("10") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("10")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.green.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.green.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["10"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, edgeInset)
                    HStack {
                        Button {
                            pressedButton = "11"
                            if explainedButtons.contains("11") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("11")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.blue.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.blue.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["11"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("11") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                    HStack {
                        Spacer()
                        if explainedButtons.contains("12") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Button {
                            pressedButton = "12"
                            if explainedButtons.contains("12") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("12")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.indigo.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.indigo.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["12"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, edgeInset)
                    VStack(spacing: 70) {
                        HStack {
                            Spacer()
                            if explainedButtons.contains("13") {
                                Button("Explain") {
                                    showExplain = true
                                }
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.cyan)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.white.opacity(0.12))
                                .clipShape(Capsule())
                            }
                            Button {
                                pressedButton = "13"
                                if explainedButtons.contains("13") {
                                    showCamera = true
                                } else {
                                    explainedButtons.insert("13")
                                    showExplain = true
                                }
                            } label: {
                                Circle()
                                    .fill(Color.purple.gradient)
                                    .frame(width: 100, height: 100)
                                    .shadow(color: Color.purple.opacity(0.8), radius: 12)
                                    .overlay {
                                        if let image = assignmentImages["13"] {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                        }
                                    }
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.trailing, edgeInset)
                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    Color.black
                                )
                                .frame(width: 300, height: 90)
                                .shadow(color: Color.gray.opacity(0.7), radius: 20, y: 8)
                                .overlay {
                                    HStack(spacing: 6) {
                                        Text("Framing")
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
                                        Image(systemName: "photo.artframe")
                                            .font(.title3.bold())
                                            .foregroundColor(.white)
                                    }
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                                }
                            Spacer()
                        }
                    }
                    HStack {
                        Spacer()
                        if explainedButtons.contains("14") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Button {
                            pressedButton = "14"
                            if explainedButtons.contains("14") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("14")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.red.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.red.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["14"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, edgeInset)
                    HStack {
                        Button {
                            pressedButton = "15"
                            if explainedButtons.contains("15") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("15")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.orange.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.orange.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["15"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("15") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                    HStack {
                        Spacer()
                        if explainedButtons.contains("16") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Button {
                            pressedButton = "16"
                            if explainedButtons.contains("16") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("16")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.yellow.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.yellow.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["16"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, edgeInset)
                    HStack {
                        Button {
                            pressedButton = "17"
                            if explainedButtons.contains("17") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("17")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.green.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.green.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["17"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("17") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                    HStack {
                        Spacer()
                        if explainedButtons.contains("18") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Button {
                            pressedButton = "18"
                            if explainedButtons.contains("18") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("18")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.blue.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.blue.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["18"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, edgeInset)
                    HStack {
                        Button {
                            pressedButton = "19"
                            if explainedButtons.contains("19") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("19")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.indigo.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.indigo.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["19"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("19") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                    VStack(spacing: 70) {
                        HStack {
                            Spacer()
                            if explainedButtons.contains("20") {
                                Button("Explain") {
                                    showExplain = true
                                }
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.cyan)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.white.opacity(0.12))
                                .clipShape(Capsule())
                            }
                            Button {
                                pressedButton = "20"
                                if explainedButtons.contains("20") {
                                    showCamera = true
                                } else {
                                    explainedButtons.insert("20")
                                    showExplain = true
                                }
                            } label: {
                                Circle()
                                    .fill(Color.purple.gradient)
                                    .frame(width: 100, height: 100)
                                    .shadow(color: Color.purple.opacity(0.8), radius: 12)
                                    .overlay {
                                        if let image = assignmentImages["20"] {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                        }
                                    }
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.trailing, edgeInset)
                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    Color.black
                                )
                                .frame(width: 300, height: 90)
                                .shadow(color: Color.gray.opacity(0.7), radius: 20, y: 8)
                                .overlay {
                                    HStack(spacing: 6) {
                                        Text("Lighting")
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
                                        Image(systemName: "sun.max.fill")
                                            .font(.title3.bold())
                                            .foregroundColor(.white)
                                    }
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                                }
                            Spacer()
                        }
                    }
                    HStack {
                        Button {
                            pressedButton = "21"
                            if explainedButtons.contains("21") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("21")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.red.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.red.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["21"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("21") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                    HStack {
                        Spacer()
                        if explainedButtons.contains("22") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Button {
                            pressedButton = "22"
                            if explainedButtons.contains("22") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("22")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.orange.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.orange.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["22"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, edgeInset)
                    HStack {
                        Button {
                            pressedButton = "23"
                            if explainedButtons.contains("23") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("23")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.yellow.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.yellow.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["23"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("23") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                    HStack {
                        Spacer()
                        if explainedButtons.contains("24") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Button {
                            pressedButton = "24"
                            if explainedButtons.contains("24") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("24")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.green.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.green.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["24"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, edgeInset)
                    HStack {
                        Button {
                            pressedButton = "25"
                            if explainedButtons.contains("25") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("25")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.blue.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.blue.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["25"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("25") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                    HStack {
                        Spacer()
                        if explainedButtons.contains("26") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Button {
                            pressedButton = "26"
                            if explainedButtons.contains("26") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("26")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.indigo.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.indigo.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["26"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.trailing, edgeInset)
                    HStack {
                        Button {
                            pressedButton = "27"
                            if explainedButtons.contains("27") {
                                showCamera = true
                            } else {
                                explainedButtons.insert("27")
                                showExplain = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.purple.gradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.purple.opacity(0.8), radius: 12)
                                .overlay {
                                    if let image = assignmentImages["27"] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                                }
                        }
                        .buttonStyle(.plain)
                        if explainedButtons.contains("27") {
                            Button("Explain") {
                                showExplain = true
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.leading, edgeInset)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.902, green: 0.902, blue: 0.980))
            .fullScreenCover(isPresented: $showCamera, onDismiss: cameraClosed) {
                    CameraView(image: $cameraImage)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
//                        .overlay(Text("Hiiiiiii")
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 10)
//                            .background {
//                                ChatBubbleShape()
//                                    .fill(Color.black.opacity(0.1))
//                            }
//                            .fixedSize(horizontal: false, vertical: true)
//                            .padding(.top, edgeInsetForSpeechBubble))
//                    .overlay(OverlayOverlayView(explainedButtons: .constant(["0"])))
                    .overlay(OverlayOverlayView(pressedButton: $pressedButton))
            }
            .navigationDestination(isPresented: $showExplain) {
                ExplainView(pressedButton: $pressedButton)
            }
            .navigationDestination(isPresented: $showResult) {
                if let resultImage {
                    ResultView(
                        image: resultImage,
                        assignmentImages: $assignmentImages,
                        assignToSlotID: pressedButton
                    )
                }
            }
        }
    }
    private func cameraClosed() {
        guard let image = cameraImage else { return }
        allPhotos.insert(image, at: 0)
        cameraImage = nil
        resultImage = image
        showResult = true
    }
}
#Preview {
    HomeView()
}
