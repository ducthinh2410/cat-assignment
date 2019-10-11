//
//  CatRequest.swift
//  CataaS
//
//  Created by Thinh Vo on 10.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import UIKit

struct CatRequest: APIRequestProtocol {

    typealias ResquestDataType = String
    typealias ResponseDataType = UIImage

    let configuration: APIConfiguration

    private let endpoint: String = "cat"

    init(configuration: APIConfiguration = APIConfiguration.appConfiguration) {
        self.configuration = configuration
    }

    func createRequest(_ tag: String?) throws -> URLRequest {
        let tag = tag != nil ? "/\(tag!)" : "" // Must exclude slash when there is no tag
        let urlString = "\(configuration.baseURL)/\(endpoint)\(tag)"

        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        } else {
            throw RequestError.invalidURL
        }
    }

    func parseResponse(_ data: Data) throws -> UIImage {
        return UIImage(data: data) ?? UIImage()
    }
}
