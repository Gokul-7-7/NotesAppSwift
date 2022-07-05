//
//  NetworkService.swift
//  Notes
//
//  Created by Gokul on 19/05/22.
//

import Foundation

final class NetworkService {
    
    private let urlSession: URLSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    func request(url: String, query: String?, httpMethod: String, completion: @escaping (Result<[BackendNotes], Error>) -> Void) {
        
        dataTask?.cancel()
        
        guard var urlComponents = URLComponents(string: url) else {
            return
        }
        
        if let urlQuery = query {
            urlComponents.query = urlQuery
        }
        
        guard let validUrl = urlComponents.url else {
            return
        }
        
        var urlRequest = URLRequest(url: validUrl)
        urlRequest.httpMethod = httpMethod
        
        dataTask = urlSession.dataTask(with: urlRequest, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            do {
                self?.dataTask = nil
            }
            
            guard error == nil else {
                let error = NSError(domain: "invalid endpoint", code: 900013, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            if let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                
                let decodedData = try? decoder.decode([BackendNotes].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData ?? []))
                }
                
                return
            } else {
                let error = NSError(domain: "invalid response", code: 900014, userInfo: nil)
                completion(.failure(error))
            }
        })
        
        dataTask?.resume()
    }
}
