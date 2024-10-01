//
//  quoteGuessGame.swift
//  quotes
//
//  Created by Emmanuel  Asaber on 10/1/24.
//
import SwiftUI
import AVFoundation

struct QuoteGuessGame: View {
    @StateObject private var gameViewModel = QuoteGuessGameViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    let options = ["A", "B", "C", "D"]
    
    @State private var correctSound: AVAudioPlayer?
    @State private var incorrectSound: AVAudioPlayer?
    @State private var soundsSetup: Bool = false
    
//    init() {
//        setupSounds()
//    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
            
            if gameViewModel.isLoading {
                ProgressView("Loading quotes...")
            } else if let error = gameViewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else if gameViewModel.isGameOver {
                gameOverView
            } else {
                gameView
            }
        }
        .onAppear {
            if !soundsSetup {
                soundsSetup = setupSounds()
            }
            gameViewModel.startGame()
        }
    }
    
    var gameView: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
                Spacer()
                Text("Guess The Author")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("Score: \(gameViewModel.score)")
                    .font(.headline)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.top, 30) // Adjusted padding to move score down
            .padding(.horizontal)
            
            // Question counter
            HStack {
                Text("Question \(gameViewModel.quoteIndex)/\(gameViewModel.totalQuestions)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal)
            
            // Question card
            if let currentQuote = gameViewModel.currentQuote {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black)
                    VStack {
                        Text(currentQuote.q)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .frame(height: 200)
                .padding()
                
                // Answer options
                ForEach(0..<min(4, gameViewModel.currentChoices.count), id: \.self) { index in
                    Button(action: {
                        gameViewModel.checkGuess(gameViewModel.currentChoices[index])
                        playSound(correct: gameViewModel.currentChoices[index] == currentQuote.a)
                    }) {
                        HStack {
                            Text(options[index])
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(width: 30, height: 30)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())
                            
                            Text(gameViewModel.currentChoices[index])
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if gameViewModel.showCorrectAnswer {
                                if gameViewModel.currentChoices[index] == currentQuote.a {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else if gameViewModel.selectedAnswer == gameViewModel.currentChoices[index] {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                    .disabled(gameViewModel.showCorrectAnswer)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Next button
            Button(action: {
                gameViewModel.nextQuote()
            }) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(gameViewModel.showCorrectAnswer ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!gameViewModel.showCorrectAnswer)
            .padding(.horizontal)
            .padding(.bottom, 20) // Adjusted padding to move button up
        }
    }

    var gameOverView: some View {
        ZStack {
            Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Quiz Completed!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 150, height: 150)
                    VStack {
                        Text("\(gameViewModel.score)")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                        Text("out of \(gameViewModel.totalQuestions)")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                
                Text(commentForScore(gameViewModel.score))
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Button("Play Again") {
                    gameViewModel.startGame()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Button("Back to Main") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
    
    func commentForScore(_ score: Int) -> String {
        switch score {
        case 0:
            return "Oh no! Better luck next time!"
        case 1:
            return "Not bad, but there's room for improvement!"
        case 2:
            return "Good effort! Keep practicing!"
        case 3:
            return "Well done! You're getting there!"
        case 4:
            return "Great job! Almost perfect!"
        case 5:
            return "Fantastic! You're a quote master!"
        default:
            return "Great job!"
        }
    }
    
//    private func setupSounds() {
//        if let correctSoundURL = Bundle.main.url(forResource: "correct", withExtension: "mp3") {
//            do {
//                correctSound = try AVAudioPlayer(contentsOf: correctSoundURL)
//            } catch {
//                print("Error loading correct sound: \(error.localizedDescription)")
//            }
//        }
//        
//        if let incorrectSoundURL = Bundle.main.url(forResource: "incorrect", withExtension: "mp3") {
//            do {
//                incorrectSound = try AVAudioPlayer(contentsOf: incorrectSoundURL)
//            } catch {
//                print("Error loading incorrect sound: \(error.localizedDescription)")
//            }
//        }
//    }
    
    private func setupSounds() -> Bool {
        print("Setting up sounds...")
        
        guard let correctSoundURL = Bundle.main.url(forResource: "correct", withExtension: "mp3") else {
            print("Could not find correct.mp3 in bundle")
            return false
        }
        
        guard let incorrectSoundURL = Bundle.main.url(forResource: "incorrect", withExtension: "mp3") else {
            print("Could not find incorrect.mp3 in bundle")
            return false
        }
        
        print("Sound URLs found:")
        print("Correct sound URL: \(correctSoundURL)")
        print("Incorrect sound URL: \(incorrectSoundURL)")
        
        do {
            correctSound = try AVAudioPlayer(contentsOf: correctSoundURL)
            incorrectSound = try AVAudioPlayer(contentsOf: incorrectSoundURL)
            
            correctSound?.prepareToPlay()
            incorrectSound?.prepareToPlay()
            
            print("Sound players created successfully")
            return true
        } catch {
            print("Error setting up sound players: \(error.localizedDescription)")
            return false
        }
    }
    
//    private func playSound(correct: Bool) {
//        if correct {
//            correctSound?.play()
//        } else {
//            incorrectSound?.play()
//        }
//    }
    
    private func playSound(correct: Bool) {
        print("Attempting to play sound: \(correct ? "correct" : "incorrect")")
        
        if !soundsSetup {
            print("Sounds not set up, attempting to set up now")
            soundsSetup = setupSounds()
        }
        
        if correct {
            guard let player = correctSound else {
                print("Correct sound player is nil")
                return
            }
            
            if player.play() {
                print("Correct sound played successfully")
            } else {
                print("Failed to play correct sound")
            }
        } else {
            guard let player = incorrectSound else {
                print("Incorrect sound player is nil")
                return
            }
            
            if player.play() {
                print("Incorrect sound played successfully")
            } else {
                print("Failed to play incorrect sound")
            }
        }
    }
}
