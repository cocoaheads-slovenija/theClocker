//
//  BasicAuthMiddleware.swift
//  theClocker
//
//  Created by Goran Blažič on 01/01/2017.
//
//

import Vapor
import HTTP
import Turnstile

/**
 Takes a Basic Authentication header and turns it into a set of API Keys, 
 and attempts to authenticate against it.
 */
class BasicAuthMiddleware: Middleware {

	func respond(to request: Request, chainingTo next: Responder) throws -> Response {
		if let apiKey = request.auth.header?.basic {
			try? request.auth.login(apiKey, persist: false)
		}
		return try next.respond(to: request)
	}

}
