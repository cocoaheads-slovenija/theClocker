//
//  Client.swift
//  theClocker
//
//  Created by Goran Blažič on 08/01/2017.
//
//

import Vapor

final class Client: Model {

	var id: Node?
	var exists: Bool = false

	var name: String

	init(name: String) {
		id = nil
		self.name = name
	}

	init(node: Node, in context: Context) throws {
		id = try node.extract("id")
		name = try node.extract("name")
	}

	func makeNode(context: Context) throws -> Node {
		return try Node(node: [
			"id": id,
			"name": name
		])
	}

	static func prepare(_ database: Database) throws {
		try database.create("clients") { clients in
			clients.id()
			clients.string("name", optional: false)
		}
	}

	static func revert(_ database: Database) throws {
		try database.delete("clients")
	}

}
