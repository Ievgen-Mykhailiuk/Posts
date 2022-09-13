//
//  PostListAPIService.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import Foundation

protocol PostListNetworkService {
    func request(completion: @escaping (Result<PostList, NetworkError>) -> Void)
}

class PostListAPIService: BaseNetworkService, PostListNetworkService {
    func request(completion: @escaping (Result<PostList, NetworkError>) -> Void) {
        request(from: .postList, httpMethod: .get) { (result: Result<PostList, NetworkError>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
