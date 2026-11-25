import SwiftUI

struct ContentView: View {
    
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingCamera = false
    @StateObject private var photoLibrary = PhotoLibrary()
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var isShowingOnboarding = false
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                
//                HomeView(/*explainedButtons: .constant("0")*/)
//                    .environmentObject(photoLibrary)
                TestView(onShowOnboarding: {
                    isShowingOnboarding = true
                })
                .environmentObject(photoLibrary)
//                Button("Take photo"){
//                    isShowingCamera = true
////                }
//                .fullScreenCover(isPresented: $isShowingCamera){
//                    ZStack{
//                        CameraView(image: $selectedImage)
//
//                        CompositionsView()
//                            .allowsHitTesting(false)
//                    }
//                }
            }
            Tab("Gallery", systemImage: "photo.stack") {
                GalleryView()
                    .environmentObject(photoLibrary)
            }
//            Tab("Profile", systemImage: "person.crop.circle") {
//                UserProfileView()
//            }
        }
        .fullScreenCover(isPresented: $isShowingOnboarding) {
            OnboardingView {
                hasCompletedOnboarding = true
                isShowingOnboarding = false
            }
        }
        .onAppear {
            if !hasCompletedOnboarding {
                isShowingOnboarding = true
            }
        }
    }
}

#Preview {
    ContentView()
}
