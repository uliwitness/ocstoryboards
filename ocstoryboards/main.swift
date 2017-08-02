//
//  main.swift
//  ocstoryboards
//
//  Created by Uli Kusterer on 30.07.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//

import Foundation


class OCStoryboardsApplication: CommandLineApplication {
	func identifierFromString(_ str: String) -> String {
		var finalIdentifier = str.replacingOccurrences(of: " ", with: "_")
		finalIdentifier = finalIdentifier.replacingOccurrences(of: "\r", with: "_")
		finalIdentifier = finalIdentifier.replacingOccurrences(of: "\n", with: "_")
		let notIdentCharset = CharacterSet(charactersIn: "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_").inverted
		while let range = finalIdentifier.rangeOfCharacter(from: notIdentCharset ) {
			finalIdentifier = finalIdentifier.replacingCharacters(in: range, with: "_")
		}
		while let range = finalIdentifier.range(of: "__") {
			finalIdentifier = finalIdentifier.replacingCharacters(in: range, with: "_")
		}
		if let range = finalIdentifier.rangeOfCharacter(from: .decimalDigits),
			range.lowerBound == finalIdentifier.startIndex {
			finalIdentifier = "_".appending(finalIdentifier)
		}
		return finalIdentifier
	}
	
	override func open(url: URL) -> Bool {
		do {
			let baseName = url.deletingPathExtension().lastPathComponent
			let className = baseName + "Storyboard"
			
			let xmlDoc = try XMLDocument(contentsOf: url, options: 0)
			
			let root = xmlDoc.rootElement()
			let scenesElement = root?.elements(forName: "scenes").first
			let scenes = scenesElement?.elements(forName: "scene")
			var sourceFileContents: String = ""
			
			sourceFileContents.append("enum \(className) {\n")
			sourceFileContents.append("    static let identifier = \"\(baseName)\"\n")
			
			scenes?.forEach {
				let objectsElement = $0.elements(forName: "objects").first
				let objects = objectsElement?.children?.filter { $0 is XMLElement } as? [XMLElement]
				
				objects?.forEach {
					if let storyboardIdentifierElement = $0.attribute(forName: "storyboardIdentifier") {
						if let storyboardIdentifier = storyboardIdentifierElement.stringValue {
							sourceFileContents.append("    static let \(identifierFromString(storyboardIdentifier)) = \"\(storyboardIdentifier)\"\n")
						}
					}
					if let connectionsElement = $0.elements(forName: "connections").first {
						let segueElements = connectionsElement.elements(forName: "segue")
						segueElements.forEach {
							if let segueIdentifierAttribute = $0.attribute(forName: "identifier"),
								let segueIdent = segueIdentifierAttribute.stringValue {
								sourceFileContents.append("    static let \(identifierFromString(segueIdent))Segue = \"\(segueIdent)\"\n")
							}
						}
					}
				}
			}

			sourceFileContents.append("}\n")
			
			try sourceFileContents.write(toFile: className + ".swift", atomically: true, encoding: .utf8)

			return true
		} catch {
			print("Error opening file \(url.path)")
			return false
		}
	}
}

OCStoryboardsApplication().run()
