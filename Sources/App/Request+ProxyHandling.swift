//
//  Request+ProxyHandling.swift
//  theClocker
//
//  Created by Goran Blažič on 02/01/2017.
//
//

import HTTP
import Turnstile

// This pretty much expects a header named X-base-URL with value in the form "https://host.domain.com"

extension Request {

	var baseURL: String {
		guard let proxyBase = headers["X-base-URL"] else {
			return uri.scheme + "://" + uri.host + (uri.port == nil ? "" : ":\(uri.port!)")
		}
		return proxyBase
	}

}
