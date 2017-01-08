//
//  ClientsController.swift
//  theClocker
//
//  Created by Goran Blažič on 08/01/2017.
//
//

import Vapor
import HTTP

final class ClientsController: ResourceRepresentable {

	func index(request: Request) throws -> ResponseRepresentable {
		return try JSON(node: Client.all().makeNode())
	}

	func create(request: Request) throws -> ResponseRepresentable {
		var client = try request.client()
		try client.save()
		return client
	}

	func show(request: Request, client: Client) throws -> ResponseRepresentable {
		return client
	}

	func update(request: Request, client: Client) throws -> ResponseRepresentable {
		let new = try request.client()
		var client = client
		client.name = new.name
		try client.save()
		return client
	}

	func delete(request: Request, client: Client) throws -> ResponseRepresentable {
		try client.delete()
		return JSON([:])
	}

	func makeResource() -> Resource<Client> {
		return Resource(index: index, store: create, show: show, modify: update, destroy: delete)
	}

}

extension Request {

	func client() throws -> Client {
		guard let json = json else {
			throw Abort.badRequest
		}
		return try Client(node: json)
	}

}
