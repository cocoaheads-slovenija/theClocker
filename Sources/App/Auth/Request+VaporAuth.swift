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

	// Base URL returns the hostname, scheme, and port in a URL string form.
	var baseURL: String {
		return uri.scheme + "://" + uri.host + (uri.port == nil ? "" : ":\(uri.port!)")
	}

	// Exposes the Turnstile subject, as Vapor has a facade on it. 
	var subject: Subject {
		return storage["subject"] as! Subject
	}

}
