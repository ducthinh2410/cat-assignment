//
//  APIRequestLoader.swift
//  CataaS
//
//  Created by Thinh Vo on 10.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

enum APIRequestLoaderError: Error {
    case notFound
    case unknown
}

class APIRequestLoader<T: APIRequestProtocol> {

    let request: T
    let session: URLSession

    init(request: T, session: URLSession = URLSession.shared) {
        self.request = request
        self.session = session
    }

    func loadRequest(requestData: T.ResquestDataType?,
                     completionHandler: @escaping (T.ResponseDataType?, Error?) -> Void) {

        do {
            let urlRequest = try request.createRequest(requestData)
            let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                guard let data = data else {
                    completionHandler(nil, error)
                    return
                }

                if let httpURLResponse = response as? HTTPURLResponse,
                    !(200..<299).contains(httpURLResponse.statusCode) {

                    if httpURLResponse.statusCode == 404 {
                        completionHandler(nil, APIRequestLoaderError.notFound)
                    } else {
                        completionHandler(nil, APIRequestLoaderError.unknown)
                    }

                    return
                }

                do {
                    let responseData = try self.request.parseResponse(data)
                    completionHandler(responseData, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
            dataTask.resume()
        } catch {
            completionHandler(nil, error)
        }
    }
}
