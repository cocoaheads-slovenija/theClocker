//
//  Request+VaporAuth.swift
//  theClocker
//
//  Created by Goran Blažič on 01/01/2017.
//
//

import HTTP
import Turnstile

extension Request {

	// Exposes the Turnstile subject, as Vapor has a facade on it. 
	var subject: Subject {
		return storage["subject"] as! Subject
	}

}
