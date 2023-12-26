//
//  ContentView.swift
//  WordGarden
//
//  Created by zabakha on 15/12/23.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    
    @State private var gameStatusMessage = "How Many Guesses To Uncover The Hidden Word?"
    
    @State private var guessesRemaining = 0
    
    @State private var characterToGuess = ""
    @State private var revealedWord = ""
    @State private var wordToGuess = ""
    @State private var lettersTried = ""
    
    @State private var playAgainHidden = true
    @FocusState private var textfieldFocused: Bool
    @State private var audioPlayer: AVAudioPlayer!
    
    @State private var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    @State private var imageName = "flower8"
    
    @State private var wordsInGame = 0
    private let maximumGuesses = 8
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Words Guessed: \(wordsGuessed)")
                    
                    Text("Words Missed: \(wordsMissed)")
                }
                
                Spacer()
                
                VStack(alignment: .leading, content: {
                    Text("Words Left: \(wordsToGuess.count)")
                    
                    Text("Words in Game: \(wordsInGame)")
                })
                
            }
            
            Spacer()
            
            Text(gameStatusMessage)
                .font(.title2)
                .multilineTextAlignment(.center)
                .frame(height: 80)
                .minimumScaleFactor(0.5)
                .padding()
            
            Spacer()
            
            Text(revealedWord)
                .font(.title)
            
            Spacer()
            
            HStack {
                if(playAgainHidden) {
                    TextField("", text: $characterToGuess)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .onSubmit {
                            guard characterToGuess != "" else {
                                return
                            }
                            
                            guessALetter(wordToGuess)
                        }
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: characterToGuess) {
                            characterToGuess = characterToGuess.trimmingCharacters(in: .letters.inverted)
                            
                            guard let lastChar = characterToGuess.last else {
                                return
                            }
                            
                            characterToGuess = lastChar.uppercased()
                        }
                        .focused($textfieldFocused)
                    
                    Button("Guess a Word") {
                        guessALetter(wordToGuess)
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(characterToGuess.isEmpty)
                    
                }else if(wordsToGuess.count != 1) {
                    Button("Another Word?") {
                        playAgainHidden = true
                        
                        lettersTried = ""
                        
                        wordsToGuess.remove(at: wordsToGuess.firstIndex(of: wordToGuess)!)
                        
                        wordToGuess = wordsToGuess.randomElement()!
                        
                        revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)

                        guessesRemaining = maximumGuesses
                        
                        imageName = "flower\(guessesRemaining)"
                        
                        gameStatusMessage = "How Many Guesses To Uncover The Hidden Word?"
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)
                }else {
                    Text(gameStatusMessage)
                        .font(.largeTitle)
                        .fontDesign(.serif)
                        .multilineTextAlignment(.center)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                                .stroke(Color.blue, lineWidth: 2.0)
                                
                        }
                }
            }

            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .animation(.easeIn(duration: 0.75), value: imageName)
                
        }
        .padding(.horizontal)
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            wordsInGame = wordsToGuess.count
            
            wordToGuess = wordsToGuess.randomElement()!
            
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
            
            guessesRemaining = maximumGuesses
            
            imageName = "flower\(guessesRemaining)"
        }
        
    }
    
//    func generateRandomWord(_ lastIndex: Int) -> String {
//        var newIndex: Int
//        
//        repeat {
//            newIndex = Int.random(in: 0..<wordsToGuess.count)
//        }while newIndex == lastIndex
//        
//        return wordsToGuess[newIndex]
//    }
    
    func guessALetter(_ wordToGuess: String) {
        textfieldFocused = false
        
        var lettersGuessed = 0
        
        lettersTried += characterToGuess
        
        revealedWord = ""
        
        for letter in wordToGuess {
            
            if lettersTried.contains(letter) {
                revealedWord += "\(letter) "
                lettersGuessed += 1
            }else {
                revealedWord += "_ "
            }
        }
        
        revealedWord.removeLast()
        
        if(lettersGuessed == wordToGuess.count) {
            wordsGuessed += 1
            playAgainHidden = false
        }
        
        updateGamePlay()
    }
    
    func updateGamePlay() {
        
        if !wordToGuess.contains(characterToGuess) {
            
            guessesRemaining -= 1
            
            //Animates Crumbling leaf and plays "incorrect" sound.
            imageName = "wilt\(guessesRemaining)"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                imageName = "flower\(guessesRemaining)"
            }
            
            playSound(soundName: "incorrect")
            
        }else {
            
            playSound(soundName: "correct")
            
        }
        
        if !revealedWord.contains("_") { // Word Guessed!
            
            gameStatusMessage = "You Guessed It. It Took You \(lettersTried.count) Guesses to Guess The Word."
            
            playAgainHidden = false
            
            wordsGuessed += 1
            
            playSound(soundName: "word-guessed")
            
        }else if guessesRemaining == 0 { // Word Missed!
            
            gameStatusMessage = "Whoopsie! You Are All Out Of Guesses."
            
            wordsMissed += 1
            
            playAgainHidden = false
            
            playSound(soundName: "word-not-guessed")
            
        }else { // Keep Guessing..
            
            gameStatusMessage = "You Have Made \(lettersTried.count) Guess\(lettersTried.count == 1 ? "" : "es")"
            
        }
            
        characterToGuess = ""
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Couldn't read a soundFile named \"\(soundName)\"")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer.")
        }
        
    }
    
}

#Preview {
    ContentView()
}
