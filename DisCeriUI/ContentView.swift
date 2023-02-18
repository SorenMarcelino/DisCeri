//
//  ContentView.swift
//  IpodSwiftUI
//
//  Created by Shreyas Vilaschandra Bhike on 05/12/21.
//  The App Wizard
//  Instagram : theappwizard2408

import SwiftUI
import AVFoundation

extension Color {
    
    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topTrailing, endPoint: .bottomTrailing)
    }
}


struct ContentView: View {
    @State private var menutap = false
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                
                ZStack{
                    DisplayView()
                    DisplayContent()
                        .offset(x: 0, y: 50)
                    
                
//                     Not Used
//                    PlayerFooter()
//                        .offset(x: 0, y: 150)
                    
    ZStack{
        if menutap {
                Text("MENU")
                    .font(.title)
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .offset(y: 290)
                    }
                    
            Text("MENU")
                .font(.title)
                .fontWeight(.regular)
                .foregroundColor(.white)
                .offset(y: 290)
                .opacity(0.6)
                .gesture(
                    TapGesture()
                        .onEnded({
                        self.menutap.toggle()
                                })
                    
                            )
        
               if menutap {
                
                   ZStack{
                       CustomMenu()
                           .mask(AnimatedMask())
                          
                        }
                    }
                }
            }
            Spacer()
            
           // Wheel Result
            WheelView()
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DisplayView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.gray)
                .frame(width: 400, height: 400)
                .opacity(0.1)
            
        }
    }
}

//IPod Wheel
struct WheelView: View {
    @State private var backwardtap = false
    @State private var forwardtap = false
    @State private var menutap = false
    @State private var pauseplay = false
   
    @State var isRotating = false
    @State var showSiri = false
    @State var showButtonSiri = true
    
    @StateObject var speechRecognizer = SpeechRecognizer() // Speech

    var body: some View {
        ZStack{
            
        ZStack{

           Circle()
                .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                .frame(width: 350, height: 350)
                .opacity(0.5)

            
            // MARK: BEGIN - SIRI Center Button
                ZStack{
                    Circle().fill(LinearGradient(Color.darkEnd, Color.darkStart)).frame(width: 130, height: 130).overlay {
                        Circle().stroke(.black, lineWidth: 2)
                    }
                    .opacity(0.5)
                    if showSiri{
                    ZStack {
                        //Image("shadow")
                        Image("icon-bg")
                        Image("pink-top")
                            .rotationEffect(.degrees(isRotating ? 320 : -260 ))
                            .hueRotation(.degrees(isRotating ? -270 : 60 ))
                        Image("pink-left")
                            .rotationEffect(.degrees(isRotating ? -360 : 180))
                            .hueRotation(.degrees(isRotating ? -220 : 300))
                        Image("blue-middle")
                            .rotationEffect(.degrees(isRotating ? -360 : 420))
                            .hueRotation(.degrees(isRotating ? -150 : 0))
                            .rotation3DEffect(.degrees(75), axis: (x: isRotating ? 1 : 5, y: 0, z: 0))
                        Image("blue-right")
                            .rotationEffect(.degrees(isRotating ? -360 : 420))
                            .hueRotation(.degrees(isRotating ? 720 : -50))
                            .rotation3DEffect(.degrees(75), axis: (x: 1, y: 0, z: isRotating ? -5 : 15))
                        /*Image("Intersect")
                         .rotationEffect(.degrees(isRotating ? 30 : -420))
                         .hueRotation(.degrees(isRotating ? 0 : 720))
                         .rotation3DEffect(.degrees(15), axis: (x: 1, y: 1, z: 1), perspective: isRotating ? 5 : -5)*/
                        Image("green-left")
                            .rotationEffect(.degrees(isRotating ? -300 : 360))
                            .hueRotation(.degrees(isRotating ? 300 : -15))
                            .rotation3DEffect(.degrees(15), axis: (x: 1, y: isRotating ? -1 : 1, z: 0), perspective: isRotating ? -1 : 1)
                        Image("green-left")
                            .rotationEffect(.degrees(isRotating ? 360 : -360))
                            .hueRotation(.degrees(isRotating ? 180 :50))
                            .rotation3DEffect(.degrees(75), axis: (x: 1, y:isRotating ? -5 : 15, z: 0))
                        Image("bottom-pink")
                            .rotationEffect(.degrees(isRotating ? 400 : -360))
                            .hueRotation(.degrees(isRotating ? 0 : 230))
                            .opacity(0.25)
                            .blendMode(.multiply)
                            .rotation3DEffect(.degrees(75), axis: (x: 5, y:isRotating ? 1 : -45, z: 0))
                    }.scaleEffect(0.326)
                    .blendMode(.hardLight)
                    
                    Image("highlight")
                        .rotationEffect(.degrees(isRotating ? 360 : 250))
                        .hueRotation(.degrees(isRotating ? 0 : 230))
                        .padding()
                        .onAppear(){
                            withAnimation(.easeInOut(duration: 15).repeatForever(autoreverses: true)) {
                                // print("Avant tap tap",isRotating) // To delete on prod
                                // print("Tap tap") // To delete on prod
                                isRotating = true
                                print("Apres tap tap",isRotating) // To delete on prod
                                
                                speechRecognizer.recordButtonTapped() // Speech

                            }
                        }.scaleEffect(0.326)
                            .onDisappear() {
                                speechRecognizer.recordButtonTapped() // Speech
                                isRotating = false
                                print("From Front : " + speechRecognizer.transcript) // Speech // To delete on prod
                            }
                }
                
                    if showButtonSiri {
                        Button("             \n\n\n\n\n\n") {
                            // let debugTestInstance = BasicFunctions() // To delete on prod
                            // print(debugTestInstance.debugTest()) // To delete on prod
                            // print("showSiri = ", showSiri) // To delete on prod
                            if showSiri == false {
                                showSiri = true
                            }
                            else {
                                showSiri = false
                            }
                        }.buttonStyle(.borderless).tint(.pink).controlSize(.large).clipShape(Circle())
                            .frame(width: 130, height: 130)
                        /*.overlay {
                         Circle().stroke(.black, lineWidth: 2)
                         }
                         .opacity(0.5)
                         .cornerRadius(100)*/
                    }

            // MARK: END - SIRI Center Button
        
                ZStack{
                    if pauseplay {
                        Image(systemName: "playpause.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .offset(y: 130)
                    }
                    
                Image(systemName: "playpause.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .offset(y: 130)
                    .opacity(0.2)
                    .gesture(
                        TapGesture()
                            .onEnded({
                                self.pauseplay.toggle()
                            })
                    
                    )
                }
                
                ZStack{
                
                if forwardtap{
                        Image(systemName: "forward.end.alt.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .offset(x: 130)
                    }
                Image(systemName: "forward.end.alt.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .offset(x: 130)
                    .opacity(0.2)
                    .gesture(
                        TapGesture()
                            .onEnded({
                                self.forwardtap.toggle()
                            })
                    
                    )
                }
                
                ZStack{
                if backwardtap{
                    Image(systemName: "backward.end.alt.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .offset(x: -130)
                    }
                    
                Image(systemName: "backward.end.alt.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .offset(x: -130)
                    .opacity(0.2)
                    .gesture(
                        TapGesture()
                            .onEnded({
                                self.backwardtap.toggle()
                            })
                    
                    )
                }
                
            }
          
        }
            
            
        }
    }
}



//Geometry Reader : Album View
struct DisplayContent: View {
     
    
   // Dummy Data
    var images : [UIImage]! = [
        UIImage(named: "album1")!,
        UIImage(named: "album2")!,
        UIImage(named: "album3")!,
        UIImage(named: "album4")!,
        UIImage(named: "album5")!,
        UIImage(named: "album6")!,
        UIImage(named: "album7")!,
    ]


    let albumName : [String] = ["Music To Be..",
                                "Justice",
                                "Dua Lipa",
                                "X",
                                "Natural Causes",
                                "Escape" ,
                                "Red"]
    
    let albumArtist : [String] = ["Eminem",
                                  "Justin Bieber",
                                  "Dua Lipa",
                                  "Ed Sheeran",
                                  "Skyler Grey",
                                  "Enrique Iglesias" ,
                                  "Taylor Swift"]
    
    var body: some View {
        
        
        ZStack{
        GeometryReader { fullView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (spacing: 100) {
                    ForEach(0..<20) { index in
                        GeometryReader { geo in
                            
                            VStack{
                            Image(uiImage:self.images[index % 7])
                                .resizable()
                                .frame(width: 260, height: 260)
                                .cornerRadius(15)
                                .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - fullView.size.width / 2) / 10), axis: (x: 0, y: 1, z: 0))
                            
                                
                                
                                
                                Text(self.albumArtist[index % 7])
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - fullView.size.width / 2) / 10), axis: (x: 0, y: 1, z: 0))
                                
                                
                                Text(self.albumName[index % 7])
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color.white)
                                    .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - fullView.size.width / 2) / 10), axis: (x: 0, y: 1, z: 0))
                           
                            }
                          
                        }
                        .frame(width: 150)
                    }
                }
                .padding(.horizontal, (fullView.size.width - 150) / 2)
            
            }
        }
        .ignoresSafeArea()
          
        
        }
    }
}


//Footerr : Not Used
struct PlayerFooter: View {
    @State private var backward = false
    var body: some View {
     
            HStack{
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 27, height: 30)
                    .foregroundColor(.white)
                    .opacity(0.1)
                
                Spacer()
               
                Image(systemName: "backward.end.alt")
                    .resizable()
                    .frame(width: 38, height: 28)
                    .foregroundColor(.white)
                    .opacity(0.1)
                    .gesture(
                        TapGesture()
                            .onEnded({
                                self.backward.toggle()
                            })
                    
                    )
                
                
                Spacer()

                Image(systemName: "play")
                    .resizable()
                    .frame(width: 27, height: 30)
                    .foregroundColor(.white)
                    .opacity(0.1)
                
                Spacer()
                Image(systemName: "forward.end.alt")
                    .resizable()
                    .frame(width: 38, height: 28)
                    .foregroundColor(.white)
                    .opacity(0.1)
                
                Spacer()

                Image(systemName: "shuffle")
                    .resizable()
                    .frame(width: 30, height: 28)
                    .foregroundColor(.white)
                    .opacity(0.1)

            }
        
    }
}


//Custom Menu
struct CustomMenu: View {
    @State private var Music = false
    @State private var Photos = false
    @State private var Videos = false
    @State private var Extras = false
    @State private var Settings = false
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.white)
                .frame(width: 400, height: 400)
                .opacity(1)
         
            VStack{
                
                HStack{
                    
                Image(systemName: "applelogo")
                        .foregroundColor(.black.opacity(0.8))
                Text("IPod")
                    .font(.title2)
                }
                
                
                
                ZStack{
              
                    MenuContent(textinput: "Music",bgColor: Color.black.opacity(0.8))
                        .gesture(
                            TapGesture()
                                .onEnded({
                                    self.Music.toggle()
                                })
                        
                        )
                    
                    if Music{
                        MenuContent(textinput: "Music",bgColor: Color.blue)
                    }
                }
                Divider()
                
                ZStack{
                    MenuContent(textinput: "Photos" , bgColor: Color.black.opacity(0.8))
                        .gesture(
                            TapGesture()
                                .onEnded({
                                    self.Photos.toggle()
                                })
                        
                        )
                    
                    if Photos{
                        MenuContent(textinput: "Photos",bgColor: Color.blue)
                    }
                }
                Divider()
                
                ZStack{
                MenuContent(textinput: "Videos" ,bgColor: Color.black.opacity(0.8))
                        .gesture(
                            TapGesture()
                                .onEnded({
                                    self.Videos.toggle()
                                })
                        
                        )
                    
                    
                    if Videos{
                        MenuContent(textinput: "Videos",bgColor: Color.blue)
                    }
                }
                Divider()
                
                ZStack{
                MenuContent(textinput: "Extras",bgColor: Color.black.opacity(0.8))
                        .gesture(
                            TapGesture()
                                .onEnded({
                                    self.Extras.toggle()
                                })
                        
                        )
                    
                    if Extras{
                        MenuContent(textinput: "Extras",bgColor: Color.blue)
                    }
                }
                   
                Divider()
                
                ZStack{
                MenuContent(textinput: "Settings",bgColor: Color.black.opacity(0.8))
                        .gesture(
                            TapGesture()
                                .onEnded({
                                    self.Settings.toggle()
                                })
                        
                        )
                    
                    if Settings{
                        MenuContent(textinput: "Settings",bgColor: Color.blue)
                    }
                    
                }
            }
        }
    }
}



//Menu Content
struct MenuContent: View {
    @State var textinput : String = "Hello"
    @State var bgColor : Color = Color.blue
   
    
   
    
    var body: some View {
        HStack{
            Text(textinput)
                .font(.title)
            
            Spacer()
            
            Image(systemName: "chevron.forward")
        }.foregroundColor(bgColor)
            .padding(10)
    }
}


//Animate White Mask
struct AnimatedMask: View {
    @State private var animatemask = false
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.white)
                .offset(x: -400, y: 0)
                .rotationEffect(.degrees(45))
                .frame(width: animatemask ? 1500 : 0, height: 1200)
                .animation(Animation.easeInOut(duration: 1))
                .onAppear() {
                    self.animatemask.toggle()
                    }
        }
    }
}

