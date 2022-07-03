//
//  LetterSquareView.swift
//  Werdle
//
//  Created by Robert Silverman on 7/1/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import SwiftUI

struct LetterSquareView: View {
    
    var width: CGFloat
    var wordGuessBad: Bool
    var letterGuess: LetterGuess

    var body: some View {
                        
        ZStack {
            Rectangle().foregroundColor(wordGuessBad ? Colors.squareBadWord : letterGuess.eval.color).border(wordGuessBad ? Colors.squareBadWord : letterGuess.eval.borderColor, width: 2)
                .frame(width: width/6, height: width/6, alignment: .center)
            Text(letterGuess.letter)
                .appFont(.black, size: 45)
                .foregroundColor(letterGuess.eval == .blank ? Colors.textDark : Colors.textLight)
                .rotation3DEffect(.degrees(letterGuess.eval == .blank ? 0 : -180), axis: (x: 0, y: 1, z: 0), perspective: 0.25)
        }
        .rotation3DEffect(.degrees(letterGuess.eval == .blank ? 0 : 180), axis: (x: 0, y: 1, z: 0), perspective: 0.25)
        .animation(.linear(duration: 0.75).delay(0.075 * Double(letterGuess.id)), value: letterGuess.eval)
    }
}

struct LetterSquareView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {

        var body: some View {
            GeometryReader { geo in
                
                VStack {
                    Spacer()
                    LetterSquareView(width: min(geo.size.width, geo.size.height), wordGuessBad: false, letterGuess: LetterGuess(id: 0, letter: "A", eval: .inPosition))
                        .frame(height: min(geo.size.width, geo.size.height))
                        .preferredColorScheme(.dark)

                    Spacer()
                }
            }
        }
    }
}
