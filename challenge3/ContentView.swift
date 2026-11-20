import SwiftUI

struct ContentView: View {
    
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingCamera = false
    @StateObject private var photoLibrary = PhotoLibrary()
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                
                HomeView(/*explainedButtons: .constant("0")*/)
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
    }
}

#Preview {
    ContentView()
}
