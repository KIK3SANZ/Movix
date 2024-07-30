import Foundation

class APIClient {
    static let shared = APIClient()
    private let session: URLSession
    private let token: String

    private init() {
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration)
        self.token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String ?? ""
    }
    
    init(session: URLSession, token: String) {
        self.session = session
        self.token = token
    }

    func performRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                let httpError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"])
                completion(.failure(httpError))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedResponse = try decoder.decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch let DecodingError.keyNotFound(key, context) {
                let keyNotFoundError = NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Key '\(key)' not found: \(context.debugDescription)"])
                completion(.failure(keyNotFoundError))
            }catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

