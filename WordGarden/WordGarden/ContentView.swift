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
    @State private var wordsToGuess = 0
    @State private var WordsInGame = 0
    @State private var flowerNumber = 8
    @State private var characterToGuess = ""
    @State private var playAgainHidden = true
    @FocusState private var textfieldFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Words Guessed: \(wordsGuessed)")
                    
                    Text("Words Missed: \(wordsMissed)")
                }
                
                Spacer()
                
                VStack(alignment: .leading, content: {
                    Text("Words to Guess: \(wordsToGuess)")
                    
                    Text("Words in Game: \(WordsInGame)")
                })
                
            }
            
            Spacer()
            
            Text("_ _ _ _ _")
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
                        textfieldFocused = false
                        //MARK: Guess a word
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(characterToGuess.isEmpty)
                    
                }else {
                    Button("Another Word?") {
                        //MARK: another word
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)
                }
            }

            
            Image("flower\(flowerNumber)")
                .resizable()
                .scaledToFit()
                
        }
        .padding(.horizontal)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
