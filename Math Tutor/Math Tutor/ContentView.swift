//
//  ContentView.swift
//  Math Tutor
//
//  Created by zabakha on 27/12/23.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    
    @State private var firstNumberEmojis = ""
    @State private var secondNumberEmojis = ""
    
    @State private var answer = ""
    @State private var message = ""
    
    @State private var textFieldAndButtonDisabled: Bool = false
    
    @FocusState private var textFieldFocused: Bool
    @State private var audioPlayer: AVAudioPlayer!
    
    private let emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    
    var body: some View {
        VStack {
            Group {
                Text(firstNumberEmojis)
                
                Text("+")
                
                Text(secondNumberEmojis)
            }
            .font(.system(size: 80))
            .minimumScaleFactor(0.5)
            .multilineTextAlignment(.center)
            
            Spacer()
            
            Text("\(firstNumber) + \(secondNumber) =")
                .font(.largeTitle)
            
            TextField("", text: $answer)
                .font(.largeTitle)
                .textFieldStyle(.roundedBorder)
                .frame(width: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 2)
                )
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .focused($textFieldFocused)
                .disabled(textFieldAndButtonDisabled)
            
            Button("Guess") {
                textFieldFocused = false
                
                if Int(answer) == firstNumber + secondNumber {
                    
                    playSound(soundName: "correct")
                    
                    message = "Correct!"
                    
                }else {
                    playSound(soundName: "wrong")
                    
                    message = "Sorry, Correct Answer is \(firstNumber + secondNumber)"
                }
                
                textFieldAndButtonDisabled = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty || textFieldAndButtonDisabled)
            
            Spacer()
            
            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundStyle(message == "Correct!" ? .green : .red)
            
            if(textFieldAndButtonDisabled) {
                Button("Play Again?") {
                    
                    message = ""
                    answer = ""
                    
                    generateNewEquation()
                    
                    textFieldAndButtonDisabled = false
                    
                }
            }
        }
        .padding()
        .onAppear(perform: {
            generateNewEquation()
        })
    }
    
    func generateNewEquation() {
        firstNumber = Int.random(in: 1...9)
        secondNumber = Int.random(in: 1...9)
        
        firstNumberEmojis = String(repeating: "\(emojis.randomElement()!)", count: firstNumber)
        secondNumberEmojis = String(repeating: "\(emojis.randomElement()!)", count: secondNumber)
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Counldn't Find a File named \(soundName) in an Asset Catalog")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        }catch {
            print("😡 ERROR: \(error.localizedDescription) playing audioPlayer")
        }
    }
    
}

#Preview {
    ContentView()
}
