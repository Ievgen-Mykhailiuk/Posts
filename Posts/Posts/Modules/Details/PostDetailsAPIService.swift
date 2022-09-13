//
//  PostDetailsAPIService.swift
//  Posts
//
//  Created by Евгений  on 13/09/2022.
//

import Foundation

protocol PostDetailsNetworkService {
    func request(with postId: Int, completion: @escaping (Result<Post, NetworkError>) -> Void)
}

final class PostDetailsAPIService: BaseNetworkService, PostDetailsNetworkService {
    func request(with postId: Int, completion: @escaping (Result<Post, NetworkError>) -> Void) {
        request(from: .post(id: postId), httpMethod: .get) { (result: Result<Post, NetworkError>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
