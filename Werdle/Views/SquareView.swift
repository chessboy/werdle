//
//  SqaureView.swift
//  Werdle
//
//  Created by Rob Silverman on 6/26/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import SwiftUI

struct SquareView: View {
    
    var width: CGFloat
    var columns: [GridItem] = []
    @Binding var game: Game
    @State var shakeOffset = 0.0
    
    var body: some View {
        
        VStack {
            ForEach(game.wordGuesses, id: \.id) { wordGuess in
                HStack {
                    ForEach(wordGuess.letterGuesses, id: \.id) { letterGuess in
                        LetterSquareView(width: width, wordGuessBad: game.lastWordWasBad && wordGuess.id == game.guessIndex, letterGuess: letterGuess)
                    }
                    .offset(x: game.lastWordWasBad && wordGuess.id == game.guessIndex ? shakeOffset : 0)
                    .onChange(of: game.lastWordWasBad) { newValue in
                        withAnimation(.linear(duration: 0.075).repeatCount(3)) {
                            shakeOffset = -12
                        }
                        AppDelegate.afterDelay(0.225) {
                            withAnimation(.linear(duration: 0.075).repeatCount(3)) {
                                shakeOffset = 0
                                AppDelegate.afterDelay(0.225) { game.lastWordWasBad = false }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SquareView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        
        @State(initialValue: Game()) var game: Game
        
        var body: some View {
            GeometryReader { geo in
                
                VStack {
                    Spacer()
                    SquareView(width: min(geo.size.width, geo.size.height), game: self.$game)
                        .frame(height: min(geo.size.width, geo.size.height))
                        .preferredColorScheme(.dark)
                    Spacer()
                }
            }
        }
    }
}
