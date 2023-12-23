//
//  ContentView.swift
//  WordGarden
//
//  Created by zabakha on 15/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    
    @State private var gameStatusMessage = "How Many Guesses To Uncover The Hidden Word?"
    @State private var flowerNumber = 8
    
    @State private var characterToGuess = ""
    @State private var revealedWord = ""
    @State private var wordToGuess = ""
    @State private var lettersTried = ""
    
    @State private var playAgainHidden = true
    @FocusState private var textfieldFocused: Bool
    
    @State private var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Words Guessed: \(wordsGuessed)")
                    
                    Text("Words Missed: \(wordsMissed)")
                }
                
                Spacer()
                
                VStack(alignment: .leading, content: {
                    Text("Words to Guess: \(wordsGuessed)")
                    
                    Text("Words in Game: \(wordsGuessed)")
                })
                
            }
            
            Spacer()
            
            Text(gameStatusMessage)
                .font(.title2)
                .multilineTextAlignment(.center)
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
                        
                        guessALetter(wordToGuess)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)
                }else {
                    Text("You Guessed All The Words There Was...")
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

            
            Image("flower\(flowerNumber)")
                .resizable()
                .scaledToFit()
                
        }
        .padding(.horizontal)
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            wordToGuess = wordsToGuess.randomElement()!
            
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
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
        
        characterToGuess = ""
        
        if(lettersGuessed == wordToGuess.count) {
            wordsGuessed += 1
            playAgainHidden = false
        }
    }
}

#Preview {
    ContentView()
}
