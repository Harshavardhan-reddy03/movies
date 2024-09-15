//
//  APIManager.swift
//  assessment
//
//  Created by Harsha on 08/09/24.
//

import Foundation

class APIManager{
    static let shared = APIManager()
    // This function is used to call the get method
    func performGetRequest<T:Decodable>(endPointName: String,queryParams:[String:Any]? = nil, resultType: T.Type, completion: @escaping(_ result: T?, Error?)-> Void) {
                
        do{
            //Settingup the url
            let endpoint = APIEndPoints()
            var urlString = endpoint.baseUrl + endPointName
            if let queryParams = queryParams {
                let queryString = queryParams.map { "\($0)=\($1)" }.joined(separator: "&")
                urlString += "?\(queryString)"
            }
            let url = URL(string: urlString)! // API url
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            //Making the http request
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    print("Get Mahatria Messages API call returned status: \(httpResponse.statusCode) \(httpResponse.description) url \(url)")
                    completion(nil, nil)
                    return
                }
                //Data decoding
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(T.self, from: data)
                    completion(response, nil)
                } catch {
                    print("api response failed")
                    completion(nil, error)
                }
            }.resume()
        }
    }
}
