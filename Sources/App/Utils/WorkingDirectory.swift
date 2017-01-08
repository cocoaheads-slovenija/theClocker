//
//  WorkingDirectory.swift
//  theClocker
//
//  Created by Goran Blažič on 01/01/2017.
//
//

#if os(Linux)
let workingDirectory: String = "./"
#else
let workingDirectory: String = {
	return "/\(#file.characters.split(separator: "/").map(String.init).dropLast().dropLast().dropLast().dropLast().joined(separator: "/"))/"
}()
#endif
