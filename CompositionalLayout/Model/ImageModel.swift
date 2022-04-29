//
//  ImageModel.swift
//  CompositionalLayout
//
//  Created by Chirag on 4/29/22.
//

import Foundation
import SwiftUI
struct ImageModel: Identifiable, Codable, Hashable {
    var id: String
    var download_url: String
    enum Codingkeys: String, CodingKey {
        case id
        case download_url
    }
}
