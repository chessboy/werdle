//
//  FileUtil.swift
//  Werdle
//
//  Created by Rob Silverman on 6/27/22.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import Foundation

class Dataset {
	
	static let shared = Dataset()
	private var words: [String] = []
	
	private init() {
		loadDataSet()
	}
		
	public var randomWord: String {
		return words.randomElement() ?? "HELLO"
	}
	
	public func containsWord(_ word: String) -> Bool {
		return words.contains(word)
	}
	
	private func loadDataSet() {
		guard let csvPath = Bundle.main.path(forResource: Constants.datasetFilename, ofType: "csv") else { return }

		do {
			let data = try String(contentsOfFile: csvPath, encoding: .utf8)
			var rows = data.components(separatedBy: .whitespacesAndNewlines)
			rows = rows.filter({ !$0.isEmpty })
			
			for row in rows {
				let word = row.components(separatedBy: ",").joined()
				// print("row: -|\(row)|-, word: \(word)")
				words.append(word.uppercased())
			}
			
		} catch{
			print(error)
		}
	}
}
