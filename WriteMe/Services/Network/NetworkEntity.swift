import Foundation

//MARK: - User
struct User: Codable {
    let id: Int64
    let accessToken: String
//    let accessTokenExpire: Int64
//    let refreshToken: String
//    let refreshTokenExpire: Int64
    
    func getTokensInfo() -> TokensInfo {
        return TokensInfo(accessToken: accessToken
//                          accessTokenExpire: accessTokenExpire,
//                          refreshToken: refreshToken,
//                          refreshTokenExpire: refreshTokenExpire
        )
    }
}

struct Token:Codable {
    let accessToken, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

struct AuthBody:Codable {
    var username:String
    var password:String
}

struct RegisterBody: Codable {
    var username: String
    var email:String
    var password: String
}

struct TokensInfo: Codable {
    let accessToken: String
//    let accessTokenExpire: Int64
//    let refreshToken: String
//    let refreshTokenExpire: Int64
}

struct TokenInfo {
    let token: String
//    let expiresAt: Int64
}

//MARK: - Result
enum Result<T> {
    case success(_ response: T)
    case serverError(_ err: ErrorResponse)
    case authError(_ err: ErrorResponse)
    case networkError(_ err: String)
}

struct ErrorResponse: Codable {
    let code: Int
    let message: String
    
    func isAuth() -> Bool {
        return Errors.isAuthError(err: message)
    }
}

// MARK: - Person
struct Person: Codable {
    let username, email: String
    let id: Int
    let projects: [Project]
}

// MARK: - Project
struct Project: Codable {
    let title, color: String
    let id: Int
    let isBaseProject: Bool
    let userID: Int
    let tasks: [Task]

    enum CodingKeys: String, CodingKey {
        case title, color, id
        case isBaseProject = "is_base_project"
        case userID = "user_id"
        case tasks
    }
}

// MARK: - Task
struct Task: Codable {
    let title, taskDescription: String
    let position, priority: Int
    let datetimeExpiration: String
    let id: Int
    let isCompleted: Bool
    let datetimeCompletion: String?
    let datetimeAdded: String
    let projectID, userID: Int

    enum CodingKeys: String, CodingKey {
        case title
        case taskDescription = "description"
        case position, priority
        case datetimeExpiration = "datetime_expiration"
        case id
        case isCompleted = "is_completed"
        case datetimeCompletion = "datetime_completion"
        case datetimeAdded = "datetime_added"
        case projectID = "project_id"
        case userID = "user_id"
    }
}

//MARK: - Errors
class Errors {
    
    //internal
    static let ERR_SERIALIZING_REQUEST = "error_serializing_request"
    static let ERR_CONVERTING_TO_HTTP_RESPONSE = "error_converting_response_to_http_response"
    static let ERR_PARSE_RESPONSE = "error_parsing_response"
    static let ERR_NIL_BODY = "error_nil_body"
    static let ERR_PARSE_ERROR_RESPONSE = "error_parsing_error_response"
    
    //server
    static let ERR_USER_EXIST = "user already exist"
    static let ERR_USER_NOT_EXIST = "user not exist"
    static let ERR_WRONG_CREDENTIALS = "wrong credentials"
    static let ERR_MISSING_AUTH_HEADER = "missing auth header or wrong header format"
    static let ERR_INVALID_ACCESS_TOKEN = "invalid access token"
    static let ERR_ACCESS_TOKEN_EXPIRED = "access token expired"
    static let ERR_INVALID_REFRESH_TOKEN = "invalid refresh token"
    static let ERR_REFRESH_TOKEN_EXPIRED = "refresh token expired"
    
    static func messageFor(err: String) -> String {
        switch err {
        case ERR_USER_EXIST:
            return "The user with given login already exists"
        case ERR_USER_NOT_EXIST:
            return "The user with given login doesn't exist"
        case ERR_WRONG_CREDENTIALS:
            return "Entered wrong login or password"
        default:
            return "An error has occured. Please check your internet connection and try again"
        }
    }
    
    static func isAuthError(err: String) -> Bool {
        return err == ERR_MISSING_AUTH_HEADER || err == ERR_INVALID_ACCESS_TOKEN ||
        err == ERR_INVALID_REFRESH_TOKEN || err == ERR_ACCESS_TOKEN_EXPIRED || err == ERR_REFRESH_TOKEN_EXPIRED
    }
}
