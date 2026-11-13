//
//  DescriptionView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 11/11/26.
//
import SwiftUI

struct ExplainView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Finish")
                        .font(.headline)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle("Name of Skill")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ExplainView()
    }
}
