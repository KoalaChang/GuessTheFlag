//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by 張宇涵 on 2025/11/13.
//

import SwiftUI

enum ActiveAlert: Identifiable {
  case score
  case gameOver

  var id: Self { self }
}

struct ContentView: View {
  @State private var countries = [
    "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland",
    "Spain", "UK", "Ukraine", "US",
  ].shuffled()

  @State private var correctAnswer = Int.random(in: 0...2)

  @State private var showingScore = false
  @State private var scoreTitle = ""
  @State private var score = 0
  @State private var wrongMessage = ""
  @State private var rounds = 0
  @State private var showingGameOverAlert = false
  @State private var activeAlert: ActiveAlert?

  var body: some View {
    ZStack {
      RadialGradient(
        stops: [
          .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
          .init(
            color: Color(red: 0.76, green: 0.15, blue: 0.26),
            location: 0.3
          ),
        ],
        center: .top,
        startRadius: 200,
        endRadius: 700
      )
      .ignoresSafeArea()
      VStack {
        Spacer()

        Text("Guess the flag")
          .font(.largeTitle.bold())
          .foregroundStyle(.white)
        VStack(spacing: 15) {
          VStack {
            Text("Tap the flag of")
              .foregroundStyle(.secondary)
              .font(.subheadline.weight(.heavy))

            Text(countries[correctAnswer])
              .font(.largeTitle.weight(.semibold))
          }

          ForEach(0..<3) { number in
            Button {
              flagTapped(number)
            } label: {
              Image(countries[number])
                .clipShape(.capsule)
                .shadow(radius: 5)
            }
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 20))

        Spacer()
        Spacer()

        Text("Score: \(score)")
          .font(.title.bold())
          .foregroundStyle(.white)

        Spacer()
      }
      .padding()
    }
    .alert(item: $activeAlert) { alert in
      switch alert {
      case .score:
        return Alert(
          title: Text(scoreTitle),
          message: Text(
            scoreTitle == "Wrong"
              ? wrongMessage
              : "Your score is \(score)"
          ),
          dismissButton: .default(Text("Continue"), action: askQuestion)
        )

      case .gameOver:
        return Alert(
          title: Text("Game Over!"),
          message: Text("Your final score is \(score)"),
          dismissButton: .default(Text("Restart"), action: reset)
        )
      }
    }

  }

  func flagTapped(_ number: Int) {

    if number == correctAnswer {
      scoreTitle = "Correct"
      score += 1
    } else {
      scoreTitle = "Wrong"
      wrongMessage = "Wrong! That's the flag of \(countries[number])"
    }

    rounds += 1
    if rounds == 8 {
      activeAlert = .gameOver
      return
    }
    activeAlert = .score
  }

  func askQuestion() {
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
  }

  func reset() {
    score = 0
    rounds = 0
    askQuestion()
  }
}

#Preview {
  ContentView()
}
