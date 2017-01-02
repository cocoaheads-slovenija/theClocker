import Vapor
import VaporMemory
import Auth
import HTTP
import Cookies
import Turnstile
import TurnstileCrypto
import TurnstileWeb
import Fluent
import Foundation

let drop = Droplet()

try drop.addProvider(VaporMemory.Provider.self)

drop.middleware.append(AuthMiddleware<ClockerUser>())
drop.middleware.append(TrustProxyMiddleware())

drop.preparations.append(ClockerUser.self)


// MARK: - index page

drop.get { request in
	let user = try? request.user()

	var dashboardView = try Node(node: [
		"authenticated": user != nil,
		"baseURL": request.baseURL
	])
	dashboardView["account"] = try user?.makeNode()

	return try drop.view.make("index", dashboardView)
}


// MARK: - login / logout

drop.get("login") { request in
	return try drop.view.make("login")
}

drop.post("login") { request in
	guard let username = request.formURLEncoded?["username"]?.string, let password = request.formURLEncoded?["password"]?.string else {
		return try drop.view.make("login", ["flash": "Missing username or password"])
	}
	let credentials = UsernamePassword(username: username, password: password)
	do {
		try request.auth.login(credentials)
		return Response(redirect: "/")
	} catch let e {
		return try drop.view.make("login", ["flash": "Invalid username or password"])
	}
}

drop.post("logout") { request in
	request.subject.logout()
	return Response(redirect: "/")
}


// MARK: - register

drop.get("register") { request in
	return try drop.view.make("register")
}

drop.post("register") { request in
	guard let username = request.formURLEncoded?["username"]?.string, let password = request.formURLEncoded?["password"]?.string else {
		return try drop.view.make("register", ["flash": "Missing username or password"])
	}
	let credentials = UsernamePassword(username: username, password: password)

	do {
		try _ = ClockerUser.register(credentials: credentials)
		try request.auth.login(credentials)
		return Response(redirect: "/")
	} catch let e as TurnstileError {
		return try drop.view.make("register", Node(node: ["flash": e.description]))
	}
}


// MARK: - Facebook auth

if let clientID = drop.config["app", "facebookClientID"]?.string, let clientSecret = drop.config["app", "facebookClientSecret"]?.string {
	let facebook = Facebook(clientID: clientID, clientSecret: clientSecret)

	drop.get("login", "facebook") { request in
		let state = URandom().secureToken
		let response = Response(redirect: facebook.getLoginLink(redirectURL: request.baseURL + "/login/facebook/consumer", state: state).absoluteString)
		response.cookies["OAuthState"] = state
		return response
	}

	drop.get("login", "facebook", "consumer") { request in
		guard let state = request.cookies["OAuthState"] else {
			return Response(redirect: "/login")
		}
		let account = try facebook.authenticate(authorizationCodeCallbackURL: request.uri.description, state: state) as! FacebookAccount
		try request.auth.login(account)
		return Response(redirect: "/")
	}
} else {
	drop.get("login", "facebook") { request in
		return "You need to configure Facebook Login first!"
	}
}


// MARK: - Protected API

let protect = ProtectMiddleware(error: Abort.custom(status: .unauthorized, message: "Unauthorized"))

drop.grouped(BasicAuthMiddleware(), protect).group("api") { api in
	api.get("me") { request in
		return try JSON(node: request.user().makeNode())
	}
}


// MARK: - Run the server

drop.run()
