//
//  UserProfileView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 12/11/26.
//

import SwiftUI

struct UserProfileView: View {
    
    @State var lightIsOn = false
    @State var darkIsOn = false
    @State var number = 0
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Preferences")) {
                    
                    Toggle("Light Photos", isOn: $lightIsOn)
                    
                    Toggle("Dark Photos", isOn: $darkIsOn)
                }
                Section(header: Text("Lessons Completed")) {
                    Text("\(number)/28")
                        .padding()
                        .font(.title)
                }
            }
            .navigationTitle("User Profiles")
        }
    }
}

#Preview {
    UserProfileView()
}
