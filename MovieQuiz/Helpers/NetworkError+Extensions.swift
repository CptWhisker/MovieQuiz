import Foundation

enum NetworkError: Error {
    case dataTaskError
    case responseError
    case clientError
    case imageError
    case decodingError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .dataTaskError:
            return NSLocalizedString("Error while launching URLSession", comment: "URLSession error")
        case .responseError:
            return NSLocalizedString("Server returned an invalid HTTP status code", comment: "Invalid response error")
        case .clientError:
            return NSLocalizedString("Server returned an empty list of movies", comment: "Invalid data error")
        case .imageError:
            return NSLocalizedString("Unable to load image", comment: "Image loading error")
        case .decodingError:
            return NSLocalizedString("Unable to decode JSON", comment: "Decoding error")
        }
    }
}
