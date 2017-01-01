//
//  TrustProxyMiddleware.swift
//  theClocker
//
//  Created by Goran Blažič on 01/01/2017.
//
//

import HTTP

/**
 Modifies the Request object to take the values of things that may be forwarded
 in a HTTP proxy, like behind Nginx, Heroku or AWS ELB.
 */
class TrustProxyMiddleware: Middleware {

	func respond(to request: Request, chainingTo next: Responder) throws -> Response {
		if let urlScheme = request.headers["X-Forwarded-Proto"] {
			request.uri.scheme = urlScheme
		}
		return try next.respond(to: request)
	}

}
