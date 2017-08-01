//
//  main.swift
//  ocstoryboards
//
//  Created by Uli Kusterer on 30.07.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//

import Foundation


class OCStoryboardsApplication: CommandLineApplication {
	override func open(url: URL) -> Bool {
		do {
			let baseName = url.deletingPathExtension().lastPathComponent + "Storyboard"
			
			let xmlDoc = try XMLDocument(contentsOf: url, options: 0)
			
			let root = xmlDoc.rootElement()
			let scenesElement = root?.elements(forName: "scenes").first
			let scenes = scenesElement?.elements(forName: "scene")
			var sourceFileContents: String = ""
			
			sourceFileContents.append("struct \(baseName) {\n")
			
			scenes?.forEach {
				let objectsElement = $0.elements(forName: "objects").first
				let objects = objectsElement?.children?.filter { $0 is XMLElement } as? [XMLElement]
				
				objects?.forEach {
					if let storyboardIdentifierElement = $0.attribute(forName: "storyboardIdentifier") {
						if let storyboardIdentifier = storyboardIdentifierElement.stringValue {
							sourceFileContents.append("    static let \(storyboardIdentifier) = \"\(storyboardIdentifier)\"\n")
						}
					}
					if let connectionsElement = $0.elements(forName: "connections").first {
						let segueElements = connectionsElement.elements(forName: "segue")
						segueElements.forEach {
							if let segueIdentifierAttribute = $0.attribute(forName: "identifier"),
								let segueIdent = segueIdentifierAttribute.stringValue {
								Swift.print("Segue: \(segueIdent)")
							}
						}
					}
				}
			}

			sourceFileContents.append("}\n")
			
			try sourceFileContents.write(toFile: baseName + ".swift", atomically: true, encoding: .utf8)

			return true
		} catch {
			print("Error opening file \(url.path)")
			return false
		}
	}
}

OCStoryboardsApplication().run()
