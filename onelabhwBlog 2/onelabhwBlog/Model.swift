//
//  Model.swift
//  onelabhwBlog
//
//  Created by Arnur Sakenov on 04.04.2023.
//

import Foundation
struct Posts: Codable {
    let notes: [Note]
}

// MARK: - Note
struct Note: Codable {
    let postId: String
    let title, description: String
}
