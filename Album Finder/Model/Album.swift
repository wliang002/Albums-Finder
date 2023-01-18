//
//  Album.swift
//  Album Finder
//
//  Created by Emily Liang on 1/17/23.
//

import Foundation

struct Album: Codable {
    var id: Int
    var title: String
    var userId: Int

    func toDictionary() -> [String: Any] {
        return ["id": id, "title": title, "userId": userId]
    }
}
