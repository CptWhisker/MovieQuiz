import Foundation

enum NetworkError: Error {
    case codeError
    case clientError
    case imageError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .codeError:
            return NSLocalizedString("Server returned an invalid HTTP status code", comment: "Invalid response error")
        case .clientError:
            return NSLocalizedString("Server returned an empty list of movies", comment: "Invalid data error")
        case .imageError:
            return NSLocalizedString("Unable to load image", comment: "Image loading error")
        }
    }
}

struct NetworkClient {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
