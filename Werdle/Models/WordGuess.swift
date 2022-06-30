//
//  WordGuess.swift
//  Werdle
//
//  Created by Rob Silverman on 6/29/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import Foundation

struct WordGuess: Identifiable {
	var id: Int = 0
	var letterGuesses: [LetterGuess] = []
	var correct: Bool = false
	var bad: Bool = false
	
	static func emptyGuess(index: Int) -> WordGuess {
		var letterGuesses: [LetterGuess] = []
		
		for i in 0..<5 {
			letterGuesses.append(LetterGuess(id: i, letter: "", eval: .blank))
		}
		
		return WordGuess(id: index, letterGuesses: letterGuesses, correct: false)
	}
	
	var word: String {
		return letterGuesses.map({ $0.letter }).joined()
	}
	
	var hasEmptyLetters: Bool {
		return letterGuesses.filter({ $0.letter.isEmpty }).count > 0
	}
	
	static func evaluateWord(_ word: String, target: String, guessIndex: Int) -> WordGuess {
		
		guard word.count == 5 else {
			print("word.count != 5")
			return WordGuess.emptyGuess(index: guessIndex)
		}
		
		guard target.count == 5 else {
			print("target.count != 5")
			return WordGuess.emptyGuess(index: guessIndex)
		}

		//print("evaluate word: \(word), target: \(target)")
		
		let wordLetters = word.map { String($0) }
		let targetLetters = target.map { String($0) }

		var letterGuesses: [LetterGuess] = []
		
		for i in 0..<5 {
			var eval: LetterEval = .wrongPosition
			let wordLetter = wordLetters[i]

			if !target.contains(wordLetter) {
				eval = .missing
			} else if wordLetter == targetLetters[i] {
				eval = .correct
			}

			letterGuesses.append(LetterGuess(id: i, letter: wordLetter, eval: eval))
		}
		
		let incorrect = letterGuesses.filter({ $0.eval != .correct }).count > 0
		var wordGuess = WordGuess(id: guessIndex, letterGuesses: letterGuesses, correct: !incorrect)
		wordGuess.cleanupWrongPositionEvals(target: target)
		
		return wordGuess
	}

	private mutating func cleanupWrongPositionEvals(target: String) {
		// check for multiple wrong positions of the same letter and prune accordingly to match target count
		for var letterGuess in letterGuesses.reversed() {
			if letterGuess.eval == .wrongPosition {
				
				let letterInTargetCount = target.numberOfOccurrencesOf(string: letterGuess.letter)
				let letterInGuessCorrectCount = letterGuesses.filter{ $0.eval == .correct && $0.letter == letterGuess.letter }.count
				let letterInGuessWrongPositionCount = letterGuesses.filter{ $0.eval == .wrongPosition && $0.letter == letterGuess.letter }.count

				//print("target \(letterGuess.letter) count: \(letterInTargetCount)")
				//print("guesses correct \(letterGuess.letter) count: \(letterInGuessCorrectCount)")
				//print("guesses wrong \(letterGuess.letter) count: \(letterInGuessWrongPositionCount)")

				if letterInTargetCount - letterInGuessCorrectCount < letterInGuessWrongPositionCount {
					//print("marking: \(letterGuess) as missing")
					letterGuess.eval = .missing
					letterGuesses[letterGuess.id] = letterGuess
				}
			}
		}
	}
}
