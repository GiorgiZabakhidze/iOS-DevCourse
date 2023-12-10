//
//  ContentView.swift
//  YouAreAwesome
//
//  Created by zabakha on 29/11/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var messageString: String = ""
    @State private var soundIsOn: Bool = true
    @State private var imageNumber: Int = -1
    @State private var messageNumber: Int = -1
    @State private var soundNumber: Int = -1
    @State private var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        VStack {
                
            Text(messageString)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, maxHeight: 150)
                .padding()
            
            Spacer()
            
            Image("image\(imageNumber)")
                .resizable()
                .scaledToFit()
                .cornerRadius(25)
                .shadow(radius: 30)
                .padding()
                
            Spacer()
            
            HStack {
                Text("Sound is \(soundIsOn ? "On" : "Off")")
                
                Toggle("", isOn: $soundIsOn)
                    .labelsHidden()
                    .tint(.accentColor)
                    .onChange(of: soundIsOn, perform: { _ in
                        if audioPlayer != nil && audioPlayer.isPlaying {
                            audioPlayer.stop()
                        }else if audioPlayer != nil {
                            audioPlayer.play()
                        }
                    })
                
                Spacer()
                
                Button {
                    let messages = ["You Are Awesome!",
                                    "You Are Great!",
                                    "You Are Fantastic!",
                                    "Fabulous? That's You!"]
                    
                    messageString = messages[generateRandomNumber(lastNum: messageNumber, upperBound: 3)]
                    
                    imageNumber = generateRandomNumber(lastNum: imageNumber, upperBound: 9)
                    
                    soundNumber = generateRandomNumber(lastNum: soundNumber, upperBound: 5)
                    
                    if soundIsOn {
                        playSound(soundName: "sound\(soundNumber)")
                    }
                    
                } label: {
                    Text("Show Message")
                        
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)

            }
            .padding()

        }
        .padding()
    }
    
    func generateRandomNumber(lastNum: Int, upperBound: Int) -> Int {
        var newNumber: Int
        
        repeat {
            newNumber = Int.random(in: 0...upperBound)
        }while newNumber == lastNum
        
        return newNumber
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Couldn't find a Sound File in Asset Catalog")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        }catch {
            print("😡 Couldn't Play audioFile")
        }
    }
    
}

#Preview {
    ContentView()
}
