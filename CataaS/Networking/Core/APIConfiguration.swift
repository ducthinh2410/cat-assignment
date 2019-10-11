//
//  APIConfiguration.swift
//  CataaS
//
//  Created by Thinh Vo on 10.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

final class APIConfiguration {

    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }
}

extension APIConfiguration {
    static let appConfiguration = APIConfiguration(baseURL: "https://cataas.com")
}
