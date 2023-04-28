//
//  ContentView.swift
//  IpodSwiftUI
//
//  Created by Shreyas Vilaschandra Bhike on 05/12/21.
//  The App Wizard
//  Instagram : theappwizard2408

import SwiftUI
import AVFoundation
import MobileVLCKit
import Ice
import Combine

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
    @State private var scrollToAlbumTitle: String? = nil
    @StateObject private var albumViewModel = AlbumViewModel()
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                
                ZStack{
                    DisplayView()
                    DisplayContent(viewModel: albumViewModel)
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
            WheelView(viewModel: albumViewModel)
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*class PlayerVLC: NSObject, VLCMediaPlayerDelegate {
    
    let ipSoren = "192.168.1.154"
    let ipCERI = "10.126.1.179"
    let player = VLCMediaPlayer()

    override init() {
        super.init()
        self.player.delegate = self
        let media = VLCMedia(url: URL(string: "rstp://\(ipSoren):5000/music")!)
        player.media = media
    }
}*/

struct DisplayView: View {
    @State var playMusic = MusicPlayerManager()
    @State var speechTest = SpeechRecognizer()
    @State var lyrics = ""
    
    var body: some View {
        ZStack{
            Text(lyrics)

            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.gray)
                .frame(width: 400, height: 400)
                .opacity(0.1)
                .onAppear(){
                    // speechTest.recordButtonTapped() // MARK: Si SpeechKit lancé au démarrage de l'app
                    // playMusic.playMusic() // MARK: Joue la musique au démarrage de l'application
                }
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
        
    @StateObject var speechRecognizer = SpeechRecognizer() // MARK: Speech
    @State var tokenizer = Tokenisation() // MARK: Tokentisation
    @State var asrRequest = ASRSoapRequest()
    @State var playMusic = MusicPlayerManager()
    @State var recordAudio = AudioRecorder()
    
    @State var playAudio = ClientVLC()
    @State var isMusicPlaying = false
    @State var isMusicPaused = false
    @State var timeBeforePause = VLCTime()
    
    @State var nlpResponse = NLPSoapRequest()
            
    class PlayerVLC: NSObject, VLCMediaPlayerDelegate {
        let ipSoren = "192.168.1.154"
        let ipCERI = "10.126.1.179"
        var player = VLCMediaPlayer()
        var isPaused = false
        var pausedTime: VLCTime?
        let ipAddress = BasicFunctions().getWifiIpAdress()
        
        func play() {
            print("Je suis là")
            player.delegate = self
            let media = VLCMedia(url: URL(string: "rtsp://\(ipAddress):5777/music")!)
            player.media = media
            player.play()
            print(player.state)
        }
        
        func pause() {
            player.pause()
            //print(player.state)
        }
        
        func resume() {
            let media = VLCMedia(url: URL(string: "rtsp://\(ipAddress):5777/music")!)
            player.media = media
            player.play()
            //print(player.state)
        }
        
        func stop() {
            player.stop()
            //print(player.state)
        }
    }
    
    @State var playerVLC = PlayerVLC()
    @State private var showAlert = false
    @ObservedObject var viewModel: AlbumViewModel
    
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
    }

    func presentPopupNotification() {
        showAlert = true
    }
    
    func reloadLib() {
        self.viewModel.fetchAlbums()
    }

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
                                isRotating = true
                                print("Apres tap tap",isRotating) // To delete on prod
                                //speechRecognizer.recordButtonTapped() // Speech
                                recordAudio.startRecording()
                                //asrRequest.requestASR()
                            }
                        }.scaleEffect(0.326)
                            .onDisappear() {
                                //speechRecognizer.recordButtonTapped() // Speech
                                var finalActionData: String = ""
                                let semaphore = DispatchSemaphore(value: 0)
                                DispatchQueue.global().sync {
                                    let audioURL = recordAudio.stopRecording() // Arrêt de l'enregistrement
                                    print(audioURL)
                                    
                                    let finalTranscriptionData = ASRSoapRequest().requestASR(audioURL: audioURL)
                                    print("Final TranscriptionData : \(finalTranscriptionData)")
                                    
                                    finalActionData = NLPSoapRequest().requestNLP(text: finalTranscriptionData)
                                    print("Final ActionData : \(finalActionData)")
                                    
                                    semaphore.signal()
                                }
                                
                                semaphore.wait()
                                
                                isRotating = false
                                do {
                                    let communicator = try Ice.initialize(CommandLine.arguments)
                                    defer {
                                        communicator.destroy()
                                    }
                                    print("Je suis là 2 : \(finalActionData)")
                                    let ipAddress = BasicFunctions().getWifiIpAdress()
                                    let printer = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipAddress) -p 10000")!, type: PrinterPrx.self)
                                        
                                    if finalActionData == "PlayMusic" || finalActionData == "PlaySong" || finalActionData == "PlayArtist" || finalActionData == "PlaySongAndArtist" {
                                        print("Je suis là 3 : \(try printer.isPlaying())")
                                        
                                        if try printer.isPlaying() == false {
                                            var cpt = 50
                                            while try printer.isPlaying() == false && cpt != 0 {
                                                print(cpt)
                                                cpt -= 1
                                            }
                                            if cpt == 0 {
                                                print("ALERT : Pas de musique correspondant à la demande")
                                            } else {
                                                print("Je suis là 4")
                                                playerVLC.play()
                                            }
                                        } else {
                                            print("Je suis là 4")
                                            playerVLC.play()
                                        }
                                    } else if finalActionData == "Stop" {
                                        if try printer.isPlaying() == true {
                                            playerVLC.stop()
                                        }
                                    } else if finalActionData == "Pause" {
                                        //if try printer.isPlaying() == true {
                                            playerVLC.pause()
                                        //}
                                    } else if finalActionData == "Resume" {
                                        //if try printer.isPlaying() == true {
                                            playerVLC.resume()
                                        //}
                                    }
                                    
                                } catch {
                                    print("Error: \(error)\n")
                                    exit(1)
                                }
                                
                                //playMusic.playMusic()
                                //print("From Front : " + speechRecognizer.transcript) // Speech // To delete on prod
                                //tokenizer.tokentizer(transcription: speechRecognizer.transcript)

                                print("Fini")
                                //sleep(5)
                                //playerVLC.play(
                                
                            }
                }
                
                        Button("             \n\n\n\n\n\n") {
                            if showSiri == false {
                                showSiri = true
                            }
                            else {
                                showSiri = false
                            }
                        }.buttonStyle(.borderless).tint(.pink).controlSize(.large).clipShape(Circle())
                            .frame(width: 130, height: 130)

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
                                presentPopupNotification()
                                /*switch (isPlaying, isPaused) {
                                case (false, false):
                                    print("Play")
                                    isPlaying = true
                                    playAudio.play(songData: "Trop Beau", artistData: "")
                                    //playerVLC.player.play()
                                    playerVLC.play()
                                case (true, false):
                                    print("Pause")
                                    isPlaying = false
                                    isPaused = true
                                    //timeBeforePause = playerVLC.player.time
                                    //playerVLC.player.pause()
                                    playerVLC.pause()
                                case (false, true):
                                    print("Resume")
                                    isPlaying = true
                                    isPaused = false
                                    //print(timeBeforePause.intValue)
                                    //playerVLC.player.jumpForward(timeBeforePause.intValue)
                                    //playerVLC.player.play()
                                    playerVLC.resume()
                                case (true, true):
                                    print("🤨")
                                }
                                print("isPlaying : \(isPlaying) - isPaused : \(isPaused)")*/
                            })
                    ).onLongPressGesture {
                        self.pauseplay.toggle()
                        /*if isPlaying == true || isPaused == true {
                            print("Stop")
                            isPlaying = false
                            isPaused = false
                            playAudio.stop()
                            playerVLC.player.stop()
                        }*/
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Nouvelle musique ajouté"),
                          message: Text("Veuillez recharger la liste des musiques"),
                          dismissButton: .default(Text("OK"), action: {
                              reloadLib()
                          }))
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


/*struct Album: Identifiable {
    let id: Int
    let name: String
    let artist: String
    let image: UIImage
}*/

struct Album: Identifiable, Hashable {
    let title: String
    let cover: UIImage
    let id: String
}

class AlbumViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var albumsTemp: [String] = []
    
    func fetchAlbums() {
        let musicHandler = MusicListHandler()
        var image: UIImage?
        
        albums = []
        
        albumsTemp = musicHandler.getMusic()
        for album in albumsTemp {
            let components = album.components(separatedBy: "|")
            if let imageUrl = URL(string: components[1]) {
                do {
                    let imageData = try Data(contentsOf: imageUrl)
                    image = UIImage(data: imageData)
                } catch {
                    print("Error downloading image: \(error.localizedDescription)")
                }
            }
            let album = Album(title: components[0], cover: image!, id: components[2])
            albums.append(album)
        }
        print(albums)
    }
}


//Geometry Reader : Album View
struct DisplayContent: View {
    //@StateObject var viewModel = AlbumViewModel()
    @ObservedObject var viewModel: AlbumViewModel
    @State var scrollToAlbumTitle: String?
    @State var ipAddress = BasicFunctions().getWifiIpAdress()
    @State var stateDelete = false
    @State var stateEdit = false
    @State private var textFieldValue = ""
    @State private var isShowingPopup = false
    @State private var albumSelectedId: String = ""
    
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
    }
    
    func rename(arg: String) {
        do {
            let communicator = try Ice.initialize(CommandLine.arguments)
            defer {
                communicator.destroy()
            }
        
            let printer = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipAddress) -p 10000")!, type: PrinterPrx.self)
            stateEdit = try printer.renameFile(filename: albumSelectedId, newName: textFieldValue) // MARK: TODO
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                viewModel.fetchAlbums()
            }
            print("Musique modifiée : \(stateEdit)")
        } catch {
            print("Error: \(error)\n")
            exit(1)
    }
        print("Text field value: (arg)")
    }

    var body: some View {
        ZStack {
            GeometryReader { fullView in
                ScrollViewReader { scrollViewProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 125) {
                            ForEach(viewModel.albums.indices, id: \.self) { index in
                                let album = viewModel.albums[index]
                                GeometryReader { geo in
                                    VStack {
                                        Text(album.title)
                                            .id(album.title) // Set the id to the title of the album
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                            .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - fullView.size.width / 2) / 20), axis: (x: 0, y: 1, z: 0))
                                        Image(uiImage: album.cover)
                                            .resizable()
                                            .frame(width: 260, height: 260)
                                            .cornerRadius(15)
                                            .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - fullView.size.width / 2) / 30), axis: (x: 0, y: 1, z: 0))
                                    }
                                    .contextMenu{
                                        Group {
                                            Button("Modifier le titre", action: {
                                                self.isShowingPopup = true
                                                albumSelectedId = album.id
                                                })
                                            Button(action: {
                                                do {
                                                    let communicator = try Ice.initialize(CommandLine.arguments)
                                                    defer {
                                                        communicator.destroy()
                                                    }
                                                
                                                    let printer = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipAddress) -p 10000")!, type: PrinterPrx.self)
                                                    stateDelete = try printer.deleteFile(album.id + "_" + album.title)
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                                        viewModel.fetchAlbums()
                                                    }
                                                    print("Musique supprimée : \(stateDelete)")
                                                } catch {
                                                    print("Error: \(error)\n")
                                                    exit(1)
                                            }}) {
                                                Text("Supprimer la musique")
                                                .foregroundColor(.red) // set the text color to red
                                            }
                                        }
                                    }
                                }
                                .frame(width: 150)
                                .padding(.trailing, index == viewModel.albums.count - 1 ? 100 : 0) // Add 100-pixel padding to the last element
                            }
                        }
                        .padding(.horizontal, (fullView.size.width - 100) / 4)
                        
                    }
                    .onAppear{
                        print("oui : \(String(describing: scrollToAlbumTitle))")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if let albumTitle = scrollToAlbumTitle {
                                scrollViewProxy.scrollTo(albumTitle, anchor: .center)
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .sheet(isPresented: $isShowingPopup, content: {
                        VStack {
                            TextField("Entrez le nouveau titre ici", text: $textFieldValue)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal)

                            Button("Enregistrer") {
                                rename(arg: textFieldValue)
                                isShowingPopup = false
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    })
        }
        .onAppear {
            viewModel.fetchAlbums()
            print(scrollToAlbumTitle as Any)
        }
        .onChange(of: stateDelete) { newValue in
            if newValue {
                print("stateDelete changé ! nouvelle valeur : \(newValue)")
                viewModel.fetchAlbums()
            }
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
    
    @State var importAudio = ImportAudioViewController()
    @State var helloWorldIce = ClientVLC()
    @State var uploadAudioFile = ClientVLC()
    
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
                Text("DisCERI")
                    .font(.title2)
                }
                
                
                
                ZStack{
              
                    MenuContent(textinput: "Upload music",bgColor: Color.black.opacity(0.8))
                        .gesture(
                            TapGesture()
                                .onEnded({
                                    // self.Music.toggle()
                                    // helloWorldIce.helloWorld()
                                    importAudio.importTapped()
                                })
                        )
                    
                    if Music{
                        MenuContent(textinput: "Music",bgColor: Color.blue)
                    }
                }
                Divider()
                
                ZStack{
                    MenuContent(textinput: "Edit music" , bgColor: Color.black.opacity(0.8))
                        .gesture(
                            TapGesture()
                                .onEnded({
                                    //self.Photos.toggle()
                                    print("Tap tap")
                                    //uploadAudioFile.uploadAudioFile()
                                })
                        
                        )
                    
                    if Photos{
                        MenuContent(textinput: "Photos",bgColor: Color.blue)
                    }
                }
                Divider()
                
                ZStack{
                MenuContent(textinput: "Delete music" ,bgColor: Color.black.opacity(0.8))
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

