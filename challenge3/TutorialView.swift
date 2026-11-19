//
//  DescriptionView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 11/11/26.
//
import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var pressedButton: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if pressedButton == "0"{
                        Text("What makes a good photo?")
                            .padding()
                            .font(.title2)
                            .bold()
                        
                        //                            .navigationTitle("Angles")
                        //                            .padding()
                        
                        Text(" - A good photo makes use of different angles to create a unique photo from a different perspective - ")
                        
                        Text("Eye Level Photos")
                            .padding()
                            .font(.title2)
                            .bold()
                        
                        Text("Eye level photo is a shot where the camera lens is placed at the exact same height as the subject's eyes. The viewer feels equal to the subject being take.")
                        
                        Text("When to Use Eye Level Photos")
                            .padding()
                            .font(.title2)
                            .bold()
                        
                        Text("Portraits, children, pets and product.")
                        
                        Text("Example")
                            .padding()
                            .bold()
                        
                        //                    Image(.jeremyHynesLESPVEW8OUnsplash)
                        //                        .resizable()
                        //                        .scaledToFit()
                        //                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        //                        .padding()
                        
                    } else if pressedButton == "1"{
                        Text("Close ups")
                            .padding()
                            .font(.title2)
                            .bold()
                        
                        Text("In a close up, imagine how far you will stand if you have a one on one conversation with the subject.")
                            .padding()
                        
                        Text("When to use")
                            .padding()
                            .font(.title2)
                            .bold()
                        
                        Text("Example")
                            .padding()
                            .bold()
                        //                    Image(.alexandraLawrenceJF1K0AMVCSMUnsplash)
                        //                        .resizable()
                        //                        .scaledToFit()
                        //                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        //                        .padding()
                    } else if pressedButton == "2"{
                        
                        Text("Long Shot photos:")
                            .padding()
                            .font(.title2)
                            .bold()
                        Text("In a long shot, show the entire body / background of the surrounding environment")
                            .padding()
                        Text("Example")
                            .padding()
                            .bold()
                        //                    Image(.E_226831_B_EEBE_49_D_6_975_B_1_B_586_C_6_A_1_C_1_E)
                        //                        .resizable()
                        //                        .scaledToFit()
                        //                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        //                        .padding()
                    } else if pressedButton == "3"{
                        Text("Low Angle photos:")
                            .padding()
                            .font(.title2)
                            .bold()
                        Text("To take a low angle shot, hold the camera down / flip your phone upside down such that the camera lens is near and angled upwards toward the object. This allows for the object to be larger with more exaggerated proportions, creating a more intense and dramatic photo")
                            .padding()
                        Text("Example")
                            .padding()
                            .bold()
                        //                    Image(.theGraphicSpaceSwKlahTeKtEUnsplash)
                        //                        .resizable()
                        //                        .scaledToFit()
                        //                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        //                        .padding()
                        //                    Image(.image)
                        //                        .resizable()
                        //                        .scaledToFit()
                        //                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        //                        .padding()
                    } else if pressedButton == "4"{
                        
                        Text("High Angle photos:")
                            .padding()
                            .font(.title2)
                            .bold()
                        Text("To take a high angle photo, hold the camera above eye level, pointing downwards at the object. This allows for a top view /  bird's eye view perspective, as well as more background")
                            .padding()
                        Text("Example")
                            .padding()
                            .bold()
                        //                    Image(.nicolasHoizeyZ3VZzp22UUnsplash1)
                        //                        .resizable()
                        //                        .scaledToFit()
                        //                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        //                        .padding()
                        //                    Image(._46_FFC_0_FF_479_C_4800_86_C_6_80_E_6067_D_5_E_68)
                        //                        .resizable()
                        //                        .scaledToFit()
                        //                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        //                        .padding()
                    } else if pressedButton == "5"{
                        
                        Text("Dutch Angle photos:")
                            .padding()
                            .font(.title2)
                            .bold()
                        Text("To take a dutch angle shot, physically tilt the camera or phone such that the subject is tilted at an angle. This shot is more adventurous, and is useful for fashion and street photography")
                            .padding()
                        Text("Example")
                            .padding()
                            .bold()
                        //                    Image(.BF_9299_E_2_8408_4_E_6_F_98_E_2_7_E_0_EF_5_A_78_E_87)
                        //                        .resizable()
                        //                        .scaledToFit()
                        //                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        //                        .padding()
                    } else if pressedButton == "6"{
                        Text("Wide Angle photos:")
                            .padding()
                            .font(.title2)
                            .bold()
                        Text("To take a wide angle shot, use a wide angle lens with a focal length of 35mm or more / use 0.5x magnification on a phone camera. Anchor the shot with a foreground object, to guide viewers to the background. Wide angle shots are useful for landscape photography, architectural photography and street photography.")
                            .padding()
                        Text("Example")
                            .padding()
                            .bold()
                        //                    Image(.EAB_8_CB_31_02_E_0_4_D_49_9618_A_91147_C_39_E_46)
                        //                        .resizable()
                        //                        .scaledToFit()
                        //                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        //                        .padding()
                    } else if pressedButton == "7"{
                        Text("The Rule Of Thirds")
                            .padding()
                            .font(.title2)
                            .bold()
                        Text("The rule of thirds enhances a photo by creating a balanced composition. By placing the main subject along the vertical thirds or at their intersections, or placing the horizon along the horizontal thirds, the photo becomes more visually interesting.")
                            .padding()
                        Text("Example")
                            .padding()
                            .bold()
                        //                    Image(.EAB_8_CB_31_02_E_0_4_D_49_9618_A_91147_C_39_E_46)
                        //                        .resizable()
                        //                        .scaledToFit()
                        //                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        //                        .padding()
                    } else if pressedButton == "8"{
                        Text("Center Composition")
                            .padding()
                            .font(.title2)
                            .bold()
                        Text("Center composition draws attention to the subject in the centre of the photo. Center composition is useful for symmetrical environments, where both sides mirror each other.")
                            .padding()
                        Text("Example")
                            .padding()
                            .bold()
                        //                    Image(.EAB_8_CB_31_02_E_0_4_D_49_9618_A_91147_C_39_E_46)
                        //                        .resizable()
                        //                        .scaledToFit()
                        //                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        //                        .padding()
                    } else if pressedButton == "9"{
                        Text("Frame Within A Frame")
                            .padding()
                            .font(.title2)
                            .bold()
                        Text("Use surrounding objects such as doorways, windows, arches or branches to create a natural border around your subject. This draws attention towards the subject in the background while adding depth to the photo.")
                            .padding()
                        Text("Example")
                            .padding()
                            .bold()
                    } else if pressedButton == "10"{
                        Text("Negative Space")
                            .padding()
                            .font(.title2)
                            .bold()
                        Text("Negative space allows for a minimalist style photo. By leaving large areas of empty space around the subject, this allows the subject to stand out. However, negative space can be difficult to master, as the negative space has to complement the subject, while every element has to be intentional. Poor balance can cause the frame to feel empty or lopsided.")
                            .padding()
                        Text("Example")
                            .padding()
                            .bold()
                    } else if pressedButton == "11"{
                        Text("")
                    }
                }
            }
        }
    }
}
#Preview {
    TutorialView(pressedButton: .constant("0"))
}

//
//#Preview {
//    NavigationStack {
//        ExplainView(pressedButton: .constant("0"))
//    }
//}
