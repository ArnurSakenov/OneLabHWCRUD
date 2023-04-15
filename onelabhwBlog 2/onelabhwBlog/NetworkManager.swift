//
//  NetworkManager.swift
//  onelabhwBlog
//
//  Created by Arnur Sakenov on 05.04.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://onelabhw-b6289-default-rtdb.europe-west1.firebasedatabase.app"

    private init() {}

    func fetchPosts(completion: @escaping ([Note]) -> Void) {
        let url = "\(baseURL)/posts.json"

        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let fetchedData):
                print("Data fetched successfully:")
                
                if let fetchedPosts = fetchedData as? [String: [String: String]] {
                    let posts = fetchedPosts.map {
                        Note(postId: $0.key, title: $0.value["title"] ?? "", description: $0.value["description"] ?? "")
                    }
                    completion(posts)
                }
                
            case .failure(let error):
                print("Error fetching data:")
                print(error.localizedDescription)
            }
        }
    }

    func createPost(title: String, description: String, completion: @escaping () -> Void) {
        let url = "\(baseURL)/posts.json"
        let parameters: [String: Any] = [
            "title": title,
            "description": description
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print("Post created successfully")
                completion()
            case .failure(let error):
                print("Error creating post:")
                print(error.localizedDescription)
            }
        }
    }

    func deletePost(withId postId: String, completion: @escaping () -> Void) {
        let url = "\(baseURL)/posts/\(postId).json"

        AF.request(url, method: .delete).response { response in
            switch response.result {
            case .success:
                print("Post deleted successfully")
                completion()
            case .failure(let error):
                print("Error deleting post:")
                print(error.localizedDescription)
            }
        }
    }

    func updatePost(postID: String, title: String, description: String, completion: @escaping () -> Void) {
        let url = "\(baseURL)/posts/\(postID).json"
        let parameters: [String: Any] = [
            "title": title,
            "description": description
        ]

        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print("Post updated successfully")
                completion()
            case .failure(let error):
                print("Error updating post:")
                print(error.localizedDescription)
            }
        }
    }
}
