# OCSTORYBOARDS

A stupid little preprocessor that generates compiler-checkable identifiers
for all storyboard and segue identifiers in a Storyboard file.

## Why?

It is easy to mistype these keys and the compiler can't tell you. ocstoryboards
wraps these calls in an enum so you type almost the same, but the Swift compiler
knows which identifiers are valid and can alert you to typos or missing storyboards.

## Syntax

	ocstoryboards <storyboardFilePath>

This generates Swift code in the current directory.

## License

	Copyright 2017 by Uli Kusterer.
	
	This software is provided 'as-is', without any express or implied
	warranty. In no event will the authors be held liable for any damages
	arising from the use of this software.
	
	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:
	
	1. The origin of this software must not be misrepresented; you must not
	claim that you wrote the original software. If you use this software
	in a product, an acknowledgment in the product documentation would be
	appreciated but is not required.
	
	2. Altered source versions must be plainly marked as such, and must not be
	misrepresented as being the original software.
	
	3. This notice may not be removed or altered from any source
	distribution.
