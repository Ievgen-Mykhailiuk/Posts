//
//  Post.swift
//  Posts
//
//  Created by Евгений  on 13/09/2022.
//

import Foundation

struct Post: Codable {
    let post: PostDetailsModel
}

struct PostDetailsModel: Codable {
    let id: Int
    let timeShamp: Double
    let title: String
    let text: String
    let imageUrl: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case timeShamp = "timeshamp"
        case title, text
        case imageUrl = "postImage"
        case likesCount = "likes_count"
    }
}
