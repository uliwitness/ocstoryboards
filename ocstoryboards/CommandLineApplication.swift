//
//  CommandLineApplication.swift
//  ocstoryboards
//
//  Created by Uli Kusterer on 30.07.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//


import Foundation


class CommandLineApplication {
	var urls: [URL] = []
	
	init() {
		// Imitate Cocoa command line storage so we can use the same code to retrieve
		//	them we would use for Cocoa.
		var currKey: String?
		var argDict: [String:String] = [:]
		var isFirst = true
		
		CommandLine.arguments.forEach { currArgument in
			if isFirst {
				isFirst = false
				return	// continue, but exit this block's invocation.
			}
			if currArgument.hasPrefix("-") {
				if let currKey = currKey {
					argDict[currKey] = ""
				}
				currKey = currArgument;
			} else if let nonOptionalCurrKey = currKey {
				argDict[nonOptionalCurrKey] = currArgument
				currKey = nil
			} else {
				urls.append(URL(fileURLWithPath: currArgument))
			}
		}
		
		UserDefaults.standard.setVolatileDomain(argDict, forName: UserDefaults.argumentDomain);
	}
	
	func run() {
		_ = open(urls: urls)
	}
	
	open func open(url: URL) -> Bool {
		return false;
	}
	
	open func open(urls: [URL]) -> Bool {
		var success = false
		urls.forEach { if !open(url: $0) { success = false } }
		return success
	}
}
