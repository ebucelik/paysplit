//
//  OneSignalClient.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 20.10.24.
//

import Foundation

class OneSignalClient {
    private let headers = [
      "accept": "application/json",
      "Authorization": "Basic ZTljYzRjZjktNzI5MS00M2Q4LWExOTMtM2M0OWE1NDQ4ZGRi",
      "content-type": "application/json"
    ]

    static let shared = OneSignalClient()

    static let appId = "6553c2ff-801a-40b9-9c99-1bc248523b21"

    fileprivate init() {}

    struct OneSignalError: Codable {
        let errors: [String]
    }

    func sendPush(with message: String,
                  username: String = "",
                  title: String,
                  id: Int) {

        let oneSignalPush = OneSignalPush(
            appId: OneSignalClient.appId,
            includeAliases: OneSignalPush.ExternalId(
                externalId: ["\(id)"]
            ),
            targetChannel: "push",
            headings: [
                "en": title,
                "de": title.localize(defaultLanguage: "de")
            ],
            contents: [
                "en": username + message,
                "de": username + message.localize(defaultLanguage: "de")
            ]
        )

        do {
            let postData = try JSONEncoder().encode(oneSignalPush)

            let request = NSMutableURLRequest(
                url: NSURL(string: "https://onesignal.com/api/v1/notifications")! as URL,
                cachePolicy: .useProtocolCachePolicy,
                timeoutInterval: 10.0
            )
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data

            let session = URLSession.shared
            let dataTask = session.dataTask(
                with: request as URLRequest,
                completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print(error as Any)
                    } else {
                        if let data = data {
                            do {
                                print(try JSONDecoder().decode(OneSignalError.self, from: data))
                            } catch {
                                print("error")
                            }
                        }
                    }
                }
            )

            dataTask.resume()
        } catch {
            print("Error")
        }
    }
}
