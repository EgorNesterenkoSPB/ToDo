import Foundation

class Requester {
    static let shared = Requester()
    
    static private let ACCESS_TOKEN_LIFE_THRESHOLD_SECONDS: Int64 = 10
    
    private var accessToken = UserDefaultsWorker.shared.getAccessToken()
    private var refreshToken = UserDefaultsWorker.shared.getRefreshToken()
    
    private init() {}
    
    private func onTokensRefreshed(tokens: TokensInfo) {
        UserDefaultsWorker.shared.saveAuthTokens(tokens: tokens)
        
//        accessToken = TokenInfo(token: tokens.accessToken, expiresAt: tokens.accessTokenExpire)
        accessToken = TokenInfo(token: tokens.accessToken)
//        refreshToken = TokenInfo(token: tokens.refreshToken, expiresAt: tokens.refreshTokenExpire)
    }
    
    func dropTokens() {
        accessToken = TokenInfo(token: "")
//        accessToken = TokenInfo(token: "", expiresAt: 0)
//        refreshToken = TokenInfo(token: "", expiresAt: 0)
    }
    
    private func formRequest(url: URL,data: Data = Data(),method: String = "POST",contentType: String = "application/json",refreshTokens: Bool = false,ignoreJwtAuth: Bool = false,isFormData:Bool = false) -> URLRequest {
        
        var request = URLRequest(url:url,cachePolicy:.reloadIgnoringLocalCacheData)
        request.httpMethod = method
        if !isFormData {
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = data
        }
        
        if refreshTokens {
            request.addValue("Bearer \(refreshToken.token)", forHTTPHeaderField: "Authorization")
        } else if !accessToken.token.isEmpty && !ignoreJwtAuth {
            request.addValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    private func formRefreshTokensRequest() -> URLRequest {
        return formRequest(url: Resources.Endpoint.refreshTokens.absoluteURL, refreshTokens: true)
    }
    
    private func renewAuthHeader(request: URLRequest) -> URLRequest {
        var newRequest = request
        newRequest.setValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Authorization")
        return newRequest
    }
    
    private var needReAuth: Bool {
//        let current = Date().timestampMillis()
//
//        let expires = accessToken.expiresAt
//
//        return current + Requester.ACCESS_TOKEN_LIFE_THRESHOLD_SECONDS > expires
        false
    }
    
    func request<T: Decodable>(request: URLRequest, onResult: @escaping (Result<T>) -> Void) {
        
        if (needReAuth && !refreshToken.token.isEmpty) {
            authAndDoRequest(request: request, onResult: onResult)
        } else {
            doRequest(request: request, onResult: onResult)
        }
    }
    
    
    func authAndDoRequest<T: Decodable>(request: URLRequest, onResult: @escaping (Result<T>) -> Void) {
        
        let refreshRequest = formRefreshTokensRequest()
        
        let task = URLSession.shared.dataTask(with: refreshRequest) { [self] (data, response, error) -> Void in
            
            if let error = error {
                DispatchQueue.main.async { onResult(.networkError(error.localizedDescription)) }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                
                //should never happen
                DispatchQueue.main.async {
                    onResult(.authError(ErrorResponse(code: 0, message: Errors.ERR_CONVERTING_TO_HTTP_RESPONSE)))
                }
                return
            }
            
            guard let data = data else {
                //should never happen
                DispatchQueue.main.async {
                    onResult(.authError(ErrorResponse(code: httpResponse.statusCode, message: Errors.ERR_NIL_BODY)))
                }
                return
            }
            
            if httpResponse.isSuccessful() {
                do {
                    let response = try JSONDecoder().decode(TokensInfo.self, from: data)
                    
                    onTokensRefreshed(tokens: response)
                    
                    let newRequest = renewAuthHeader(request: request)
                    
                    doRequest(request: newRequest, onResult: onResult)
                    return
                } catch {
                    //should never happen
                    DispatchQueue.main.async {
                        onResult(.authError(ErrorResponse(code: 0, message: Errors.ERR_PARSE_RESPONSE)))
                    }
                    return
                }
            } else {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        onResult(.authError(errorResponse))
                    }
                    return
                } catch {
                    DispatchQueue.main.async {
                        onResult(.authError(ErrorResponse(code: 0, message: error.localizedDescription)))
                    }
                    return
                }
            }
        }
        task.resume()
    }
    
    func doRequest<T: Decodable>(request: URLRequest, onResult: @escaping (Result<T>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                DispatchQueue.main.async { onResult(.networkError(error.localizedDescription)) }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                
                //should never happen
                DispatchQueue.main.async { onResult(.networkError(Errors.ERR_CONVERTING_TO_HTTP_RESPONSE)) }
                return
            }
            
            guard let data = data else {
                //should never happen
                DispatchQueue.main.async {
                    onResult(.serverError(ErrorResponse(code: httpResponse.statusCode, message: Errors.ERR_NIL_BODY)))
                }
                return
            }
            if httpResponse.isSuccessful() {
                let responseBody: Result<T> = self.parseResponse(data: data)
                DispatchQueue.main.async { onResult(responseBody) }
            } else {
                let responseBody: Result<T> = self.parseError(data: data)
                DispatchQueue.main.async { onResult(responseBody) }
            }
        }
        task.resume()
    }
    
    private func parseResponse<T: Decodable>(data: Data) -> Result<T> {
        do {
            return .success(try JSONDecoder().decode(T.self, from: data))
        } catch {
            return parseError(data: data)
        }
    }
    
    private func parseError<T>(data: Data) -> Result<T> {
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            
            if (errorResponse.isAuth()) {
                return .authError(errorResponse)
            } else {
                return .serverError(errorResponse)
            }
        } catch {
            return .serverError(ErrorResponse(code: 0, message: Errors.ERR_PARSE_ERROR_RESPONSE))
        }
    }
    
    private func handleAuthResponse(response: Result<Token>, onResult: @escaping (Result<Token>) -> Void) {
        
        if case .success(let user) = response {
//            self.onTokensRefreshed(tokens: user.getTokensInfo())
        }
        onResult(response)
    }
    
    func register(authBody: RegisterBody, onResult: @escaping (Result<Person>) -> Void) {
        let url = Resources.Endpoint.register.absoluteURL
        let body = try! JSONEncoder().encode(authBody)
        let request = formRequest(url: url, data: body, method: "POST", ignoreJwtAuth: true)
        
        self.doRequest(request: request) {result in
            onResult(result)
        }
    }
    
    func login(authBody: AuthBody, onResult: @escaping (Result<Token>) -> Void) {
        let url = Resources.Endpoint.login.absoluteURL
        let body = try! JSONEncoder().encode(authBody)
        var request = formRequest(url: url, data: body, method: "POST",ignoreJwtAuth: true,isFormData: true)
        do {
            try request.setMultipartFormData(["username":authBody.username,"password":authBody.password], encoding: .utf8)
        } catch let error {
            
        }
        
    
        self.doRequest(request: request) { [self] result in
            self.handleAuthResponse(response: result, onResult: onResult)
        }
    }
    
    func getInfo(onResult: @escaping (Result<[Person]>) -> Void) {
        let url = Resources.Endpoint.getInfo.absoluteURL
        let request = formRequest(url: url, data: Data(), method: "GET")
        self.request(request: request, onResult: onResult)
    }
}
