//
//  EndingView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 25/11/26.
//

import SwiftUI

struct EndingView: View {
    
    var onClose: (() -> Void)? = nil

    @AppStorage("username") var username = ""
    @State var isShown = false

    @Environment(\.dismiss) private var dismiss

    private func close() {
        if let onClose {
            onClose()
        } else {
            dismiss()
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                TextField("Enter your name", text: $username)
                    .padding()
                    .onSubmit {
                        print(username)
                    }
                
                Button("Confirm"){
                    isShown = true
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        close()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationDestination(isPresented: $isShown){
                ZStack{
                    CertificationView(username: $username, onClose: close)
                    ConfettiView()
                        .ignoresSafeArea()
                }
            }
        }
    }
}

struct CertificationView: View {
    
    @Binding var username: String
    var onClose: (() -> Void)? = nil

    let currentDate = getCurrentDate()

    @Environment(\.dismiss) private var dismiss

    private func close() {
        if let onClose {
            onClose()
        } else {
            dismiss()
        }
    }
    
    var body: some View{
        ZStack{
            Rectangle()
                .stroke(.black, lineWidth: 2)
            VStack{
                Text("Congratulations of Completion")
                    .bold()
                    .padding()
                Text("This certificate is proudly presented to")
                    .italic()
                    .padding()
                Text("\(username)")
                    .underline()
                    .padding()
                Text("Thank you for following along and remember to continue learning on your photography journey!")
                    .padding()
                
                HStack{
                    Image(systemName: "rosette")
                        .font(.largeTitle)
                    //                    Image(systemName: "checkmark.seal")
                    //                    Image(systemName: "seal")
                    Text("Date: \(currentDate)")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    close()
                }
                .bold()
            }
        }
    }
}

func getCurrentDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy"
    formatter.timeZone = .current
    formatter.locale = .current

    return formatter.string(from: Date())
}

#Preview {
    EndingView()
}
