//
//  AlamofireService.swift
//  WeatherTest
//
//  Created by Александр Минк on 30.05.2025.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    
    case requestFailed
    case invalidData
    case decodingFailure
    case serverError(String)
    case noInternetConnection
    case unauthorized
    case forbidden
    case notFound
    case cityNotFound
    
    var title: String {
        
        switch self {
        case .requestFailed:
            return "Request failed"
        case .invalidData:
            return "Invalid data"
        case .decodingFailure:
            return "Decoding failure"
        case .serverError(let string):
            return string
        case .noInternetConnection:
            return "No internet connection"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not found"
        case .cityNotFound:
            return "Город не найден"
        }
    }
}

protocol AlamofireServiceInput {
    
    func request(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        disableCertificateCheck: Bool,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    )
}

final class AlamofireService {
    
    // MARK: - Properties
    
    static let shared = AlamofireService()
    
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Private methods
    
    private func isNetworkReachable() -> Bool {
        NetworkReachabilityManager()?.isReachable ?? false
    }
    
}


// MARK: - AlamofireServiceInput
extension AlamofireService: AlamofireServiceInput {
    
    // MARK: - Public methods
    
    func request(
        url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        disableCertificateCheck: Bool = false,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        
        guard isNetworkReachable() else {
            completion(.failure(.noInternetConnection))
            return
        }
        
        var session = Session.default
        
        if disableCertificateCheck {
            let configuration = URLSessionConfiguration.af.default
            configuration.urlCredentialStorage = nil
            session = Session(configuration: configuration)
        }
        
        session.request(url,
                        method: method,
                        parameters: parameters,
                        headers: headers
        )
        .validate(statusCode: 200..<600)
        .responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                let networkError = self.networkError(statusCode: response.response?.statusCode, error: error)
                completion(.failure(networkError))
            }
        }
    }
    
    
    // MARK: - Private methods
    
    private func networkError(statusCode: Int?, error: AFError) -> NetworkError {
        
        if let statusCode = statusCode {
            switch statusCode {
            case 401:
                return .unauthorized
            case 403:
                return .forbidden
            case 404:
                return .notFound
            case 400...600:
                return .serverError(error.localizedDescription)
            default:
                return .requestFailed
            }
        }
        return .requestFailed
    }
    
}
