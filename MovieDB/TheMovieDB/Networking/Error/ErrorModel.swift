//
//  ErrorModel.swift
//  MovieDB
//
//  Created by Nestor Contreras Miranda on 17/11/22.
//

import Foundation

struct ErrorModel: Codable {
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case message = "status_message"
    }
}
