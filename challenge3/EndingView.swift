//
//  EndingView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 25/11/26.
//

import SwiftUI

struct EndingView: View {
    
    @AppStorage("username") var username = ""
    @State var isShown = false
    
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
            .navigationDestination(isPresented: $isShown){
                ZStack{
                    CertificationView(username: $username)
                    ConfettiView()
                }
            }
        }
    }
}

struct CertificationView: View {
    
    @Binding var username: String
    let currentDate = getCurrentDate()
    
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
                Text("For completing the FlickerFox photo taking tutorial.")
                    .padding()
                
                HStack{
                    Image(systemName: "rosette")
                        .font(.largeTitle)
                    //                    Image(systemName: "checkmark.seal")
                    //                    Image(systemName: "seal")
                    Text("Date: \(currentDate)")
                }
            }

            ConfettiView()
                .ignoresSafeArea()
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
