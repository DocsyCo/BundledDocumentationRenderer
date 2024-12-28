//
//  BundledDocumentationRenderer.swift
//  Docsy
//
//  Copyright © 2024 Noah Kamara.
//

import DocumentationKit
import Foundation

public enum BundledAppSourceError: Error {
    case missingBundleResource
}

public struct BundledAppSourceProvider: FileServerProvider {
    let bundle: Bundle
    let fileManager = FileManager.default

    /// Creates a `BundledDocumentationRenderer` that serves files
    public init() {
        self.bundle = .module
    }

    func resource(at path: String) throws -> Data {
        let resourcesURL = bundle.resourceURL?.appending(component: "BundledResources")

        guard let resourcesURL else {
            throw BundledAppSourceError.missingBundleResource
        }

        let contents = try fileManager.contents(of: resourcesURL.appending(path: path))

        return contents
    }
}

enum BundleAppSourceError: Error {
    case invalidAppSourcePath(String)
    case notFound
}

public extension BundledAppSourceProvider {
    func data(for path: String) async throws -> Data {
        let firstComponent = path
            .trimmingCharacters(in: .init(charactersIn: "/"))
            .split(separator: "/")
            .first

        guard let firstComponent else {
            throw BundleAppSourceError.invalidAppSourcePath("/")
        }

        if path.hasSuffix("index.html") {
            do {
                return try resource(at: "index.html")
            } catch {
                throw BundleAppSourceError.notFound
            }
        }

        return switch firstComponent {
        case "js": try resource(at: path)
        case "css": try resource(at: path)
        case "img": try resource(at: path)
        default: throw BundleAppSourceError.invalidAppSourcePath("/" + firstComponent)
        }
    }
}
