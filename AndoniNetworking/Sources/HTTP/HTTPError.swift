//
//  HTTPError.swift
//  AndoniNetworking
//
//  Created by Andoni Da silva on 25/9/23.
//

import Foundation

public enum HTTPError: Error {
    case unauthorized
    case badRequest
    case notFound
    case forbidden
    case serverError
}
