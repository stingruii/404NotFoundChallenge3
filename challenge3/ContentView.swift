import SwiftUI

struct ContentView: View {
    
    //    @Binding var name: String
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingCamera = false
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                
                HomeView()
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
            }
            Tab("Profile", systemImage: "person.crop.circle") {
                UserProfileView()
            }
        }
    }
}

#Preview {
    ContentView()
}
