//
//  ClockerUser.swift
//  theClocker
//
//  Created by Goran Blažič on 01/01/2017.
//
//

import HTTP
import Fluent
import Turnstile
import TurnstileCrypto
import TurnstileWeb
import Auth

final class ClockerUser: User {

	var exists: Bool = false

	var id: Node?
	var username: String
	var password = ""
	var facebookID = ""
	var apiKeyID = URandom().secureToken
	var apiKeySecret = URandom().secureToken

	class func authenticate(credentials: Credentials) throws -> User {
		var user: ClockerUser?

		switch credentials {
		// Fetches a user, and checks that the password is present, and matches.
		case let credentials as UsernamePassword:
			let fetchedUser = try ClockerUser.query().filter("username", credentials.username).first()
			if let password = fetchedUser?.password, password != "", (try? BCrypt.verify(password: credentials.password, matchesHash: password)) == true {
				user = fetchedUser
			}
		// Fetches the user by session ID. Used by the Vapor session manager.
		case let credentials as Identifier:
			user = try ClockerUser.find(credentials.id)
		// Fetches the user by Facebook ID. If the user doesn't exist, autoregisters it.
		case let credentials as FacebookAccount:
			if let existing = try ClockerUser.query().filter("facebook_id", credentials.uniqueID).first() {
				user = existing
			} else {
				user = try ClockerUser.register(credentials: credentials) as? ClockerUser
			}
		// Authenticates via API Keys
		case let credentials as APIKey:
			user = try ClockerUser.query().filter("api_key_id", credentials.id).filter("api_key_secret", credentials.secret).first()
		default:
			throw UnsupportedCredentialsError()
		}

		if let user = user {
			return user
		} else {
			throw IncorrectCredentialsError()
		}
	}

	class func register(credentials: Credentials) throws -> User {
		var newUser: ClockerUser

		switch credentials {
		case let credentials as UsernamePassword:
			newUser = ClockerUser(credentials: credentials)
		case let credentials as FacebookAccount:
			newUser = ClockerUser(credentials: credentials)
		default:
			throw UnsupportedCredentialsError()
		}

		if try ClockerUser.query().filter("username", newUser.username).first() == nil {
			try newUser.save()
			return newUser
		} else {
			throw AccountTakenError()
		}
	}

	init(credentials: UsernamePassword) {
		username = credentials.username
		password = BCrypt.hash(password: credentials.password)
	}

	init(credentials: FacebookAccount) {
		username = "fb" + credentials.uniqueID
		facebookID = credentials.uniqueID
	}

	// MARK: - Fluent stuff

	init(node: Node, in context: Context) throws {
		id = node["id"]
		username = try node.extract("username")
		password = try node.extract("password")
		facebookID = try node.extract("facebook_id")
		apiKeyID = try node.extract("api_key_id")
		apiKeySecret = try node.extract("api_key_secret")
	}

	func makeNode(context: Context) throws -> Node {
		return try Node(node: [
			"id": id,
			"username": username,
			"password": password,
			"facebook_id": facebookID,
			"api_key_id": apiKeyID,
			"api_key_secret": apiKeySecret
		])
    }

	class func prepare(_ database: Database) throws {
		try database.create("clockerusers") { users in
			users.id()
			users.string("username")
			users.string("password")
			users.string("facebook_id")
			users.string("api_key_id")
			users.string("api_key_secret")
		}
	}

	static func revert(_ database: Database) throws {
		try database.delete("clockerusers")
	}

}

extension Request {
	func user() throws -> ClockerUser {
		guard let user = try auth.user() as? ClockerUser else {
			throw "Invalid user type"
		}
		return user
	}
}

extension String: Error {
}
