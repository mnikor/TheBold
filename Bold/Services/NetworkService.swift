//
//  NetworkService.swift
//  Bold
//
//  Created by Admin on 10/1/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SDWebImage

class NetworkService {
    static let shared = NetworkService()
    
    private let baseURL = "https://the-bold-staging.herokuapp.com/api/v1"
    
    private var headers: [String : String] {
        var headers = [String: String]()
        if let token = SessionManager.shared.token {
            headers.updateValue(token, forKey: "X-Auth-Token")
        }
        //        if let apiToken = SessionManager.shared.apiToken {
        //            headers.updateValue(apiToken, forKey: "X-Api-Token")
        //        }
        headers.updateValue("asqwjeqehqk", forKey: "X-Api-Token")
        return headers
    }
    
    lazy var theBoldCache : SDImageCache = {
        let cache = SDImageCache(namespace: "theBold")
        cache.config.maxDiskAge = 2678400
        cache.config.shouldCacheImagesInMemory = true
        SDImageCachesManager.shared.caches = [cache]
        SDWebImageManager.defaultImageCache = SDImageCachesManager.shared
        return cache
    }()
    
    func cacheImage(url: URL?) -> UIImage? {
        let cacheKey = SDWebImageManager.shared.cacheKey(for: url)
        return theBoldCache.imageFromCache(forKey: cacheKey)
    }
    
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    private var isReachableOnEthernetOrWiFi: Bool {
        return reachabilityManager?.isReachableOnEthernetOrWiFi ?? false
    }
    
    private var isReachableOnWWAN: Bool {
        return reachabilityManager?.isReachableOnWWAN ?? false
    }
    
    private var downloadEnabled: Bool {
        return (SettingsService.shared.downloadOnWiFiOnly && isReachableOnEthernetOrWiFi) || (!SettingsService.shared.downloadOnWiFiOnly)
    }
    
    private init() { }
    
    func facebookAuth(facebookToken: String) {
        sendRequest(endpoint: Endpoint.authFacebook.rawValue, method: .post, parameters: [RequestParameter.facebookToken: facebookToken]) { result in
            print("request sended")
        }
    }
    
    func login(email: String, password: String, completion: ((Result<Profile>) -> Void)?) {
        sendRequest(endpoint: Endpoint.signIn.rawValue,
                    method: .post,
                    parameters: [RequestParameter.usersEmail: email,
                                 RequestParameter.usersPassword: password]) { result in
                                    switch result {
                                    case .failure(let error):
                                        completion?(.failure(error))
                                    case .success(let jsonData):
                                        guard let accessToken = jsonData["access_token"].string,
                                        let expirationTimeInterval = jsonData["token_expiration_time"].double
                                            else { return }
                                        let expirationDate = Date(timeIntervalSinceNow: expirationTimeInterval)
                                        SessionManager.shared.updateToken(accessToken, expireDate: expirationDate)
                                        guard let profile = Profile.mapJSON(jsonData)
                                            else {
                                                completion?(.failure(ServerErrorFactory.unknown))
                                                return
                                        }
                                        completion?(.success(profile))
                                    }
        }
    }
    
    func signUp(firstName: String?, lastName: String?, email: String, password: String, acceptTerms: Bool, completion: ((Result<Profile>) -> Void)?) {
        var params: [String: Any] = [:]
        if let firstName = firstName {
            params.updateValue(firstName, forKey: RequestParameter.usersFirstName)
        }
        if let lastName = lastName {
            params.updateValue(lastName, forKey: RequestParameter.usersLastName)
        }
        params.updateValue(email, forKey: RequestParameter.usersEmail)
        params.updateValue(password, forKey: RequestParameter.usersPassword)
        params.updateValue(acceptTerms, forKey: RequestParameter.acceptTerms)
        sendRequest(endpoint: Endpoint.signUp.rawValue,
                    method: .post,
                    parameters: params) { result in
                        switch result {
                        case .failure(let error):
                            completion?(.failure(error))
                        case .success(let jsonData):
                            print("successful request")
                            guard let profile = Profile.mapJSON(jsonData)
                                else {
                                    completion?(.failure(ServerErrorFactory.unknown))
                                    return
                            }
                            completion?(.success(profile))
                        }
        }
    }
    
    func profile(completion: ((Result<Profile>) -> Void)?) {
        guard downloadEnabled else { return }
        sendRequest(endpoint: Endpoint.profile.rawValue,
                    method: .get,
                    parameters: [:]) { result in
                        switch result {
                        case .failure(let error):
                            completion?(.failure(error))
                        case .success(let jsonData):
                            print("request sended")
                            guard let profile = Profile.mapJSON(jsonData)
                                else {
                                    completion?(.failure(ServerErrorFactory.unknown))
                                    return
                            }
                            completion?(.success(profile))
                        }
        }
    }
    
    func editProfile(firstName: String? = nil, lastName: String? = nil, completion: ((Result<Profile>) -> Void)?) {
        guard downloadEnabled else { return }
        var params: [String: Any] = [:]
        if let firstName = firstName {
            params.updateValue(firstName, forKey: RequestParameter.usersFirstName)
        }
        if let lastName = lastName {
            params.updateValue(lastName, forKey: RequestParameter.usersLastName)
        }
        
        sendRequest(endpoint: Endpoint.profile.rawValue,
                    method: .put,
                    parameters: params) { result in
                                    switch result {
                                    case .failure(let error):
                                        completion?(.failure(error))
                                    case .success(let jsonData):
                                        print("request sended")
                                        guard let profile = Profile.mapJSON(jsonData)
                                            else {
                                                completion?(.failure(ServerErrorFactory.unknown))
                                                return
                                        }
                                        completion?(.success(profile))
                                    }
        }
    }
    
    func uploadImage(imageData: Data, completion: ((Result<Profile>) -> Void)?) {
        guard downloadEnabled else { return }
        var headers = self.headers
        headers.updateValue("multipart/form-data", forKey: "Content-type")
        
        sendMultipartRequest(endpoint: Endpoint.profile.rawValue,
                             method: .put,
                             parameters: [:],
                             imageData: imageData,
                             headers: headers) { result in
                                switch result {
                                case .failure(let error):
                                    // TODO: - error handling
                                    break
                                case .success(let jsonData):
                                    guard let profile = Profile.mapJSON(jsonData)
                                        else {
                                            completion?(.failure(ServerErrorFactory.unknown))
                                            return
                                    }
                                    completion?(.success(profile))
                                }
        }
    }
    
    func deleteUsersImage(completion: ((Result<Profile>) -> Void)?) {
        guard downloadEnabled else { return }
        sendRequest(endpoint: Endpoint.deleteImage.rawValue, method: .delete, parameters: [:]) { result in
            switch result {
            case .failure(let error):
                completion?(.failure(error))
            case .success(let jsonData):
                print("successful request")
                guard let profile = Profile.mapJSON(jsonData)
                    else {
                        completion?(.failure(ServerErrorFactory.unknown))
                        return
                }
                completion?(.success(profile))
            }
        }
    }
    
    func likeContent(of type: ContentType, with id: Int) {
        guard downloadEnabled else { return }
        sendRequest(endpoint: String(format: Endpoint.likeContentObject.rawValue, type.rawValue, id),
                method: .put,
                parameters: [:]) { result in
                    switch result {
                    case .failure(let error):
                        break
                    case .success(let data):
                        print("requestSended")
                    }
        }
    }
    
    func unlikeContent(of type: ContentType, with id: Int) {
        guard downloadEnabled else { return }
        sendRequest(endpoint: String(format: Endpoint.unlikeContentObject.rawValue, type.rawValue, id),
                method: .put,
                parameters: [:]) { result in
                    switch result {
                    case .failure(let error):
                        break
                    case .success(let data):
                        print("requestSended")
                    }
        }
    }
    
    func getContent(with type: ContentType, completion: ((Result<[ActivityContent]>) -> Void)?) {
        guard downloadEnabled else { return }
        sendRequest(endpoint: String(format: Endpoint.contentObjectsWithType.rawValue, type.rawValue),
                    method: .get,
                    parameters: [:]) { result in
                        switch result {
                        case .failure(let error):
                            completion?(.failure(error))
                        case .success(let data):
                            guard let dataArray = data.array
                                else {
                                    completion?(.failure(ServerErrorFactory.unknown))
                                    return
                            }
                            let contentArray = dataArray.compactMap { ActivityContent.mapJSON($0) }
                            completion?(.success(contentArray))
                        }
        }
    }
    
    func getContent(of type: ContentType, with id: Int, completion: ((Result<ActivityContent>) -> Void)?) {
        guard downloadEnabled else { return }
        sendRequest(endpoint: String(format: Endpoint.contentObject.rawValue, type.rawValue, id),
                    method: .get,
                    parameters: [:]) { result in
                        switch result {
                        case .failure(let error):
                            completion?(.failure(error))
                        case .success(let jsonData):
                            guard let content = ActivityContent.mapJSON(jsonData)
                                else {
                                    completion?(.failure(ServerErrorFactory.unknown))
                                    return
                            }
                            completion?(.success(content))
                        }
        }
    }
    
    func getAllGroup(with type: ContentType, completion: ((Result<[ActivityGroup]>) -> Void)?) {
        guard downloadEnabled else { return }
        sendRequest(endpoint: String(format: Endpoint.contentGroupAllWithType.rawValue, type.rawValue),
                    method: .get,
                    parameters: [:]) { (result) in
                        switch result {
                        case .failure(let error):
                            completion?(.failure(error))
                        case .success(let jsonData):
                            guard let dataArray = jsonData.array
                                else {
                                    completion?(.failure(ServerErrorFactory.unknown))
                                    return
                            }
                            let groupArray = dataArray.compactMap { ActivityGroup.mapJSON($0) }
                            completion?(.success(groupArray))
                        }
        }
    }
    
    func changePassword(currentPassword: String, newPassword: String) {
        guard downloadEnabled else { return }
        var params: [String: Any] = [:]
        params.updateValue(currentPassword, forKey: RequestParameter.currentPassword)
        params.updateValue(newPassword, forKey: RequestParameter.password)
        sendRequest(endpoint: Endpoint.updatePassword.rawValue,
                    method: .put,
                    parameters: params) { result in
                        switch result {
                        case .failure(let error):
                            break
                        case.success(let jsonData):
                            print("successful request")
                        }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (JSON?, Error?) -> Void) {
        let params: [String: Any] = [RequestParameter.email: email]
        sendRequest(endpoint: Endpoint.resetPassword.rawValue,
                    method: .put,
                    parameters: params) { result in
                        switch result {
                        case .failure(let error):
                            completion(nil, error)
                        case .success(let jsonData):
                            completion(jsonData, nil)
                        }
        }
    }
    
    func confirmPasswordReset(resetToken: String, newPassword: String) {
        var params: [String: Any] = [:]
        params.updateValue(resetToken, forKey: RequestParameter.resetPasswordToken)
        params.updateValue(newPassword, forKey: RequestParameter.password)
        sendRequest(endpoint: Endpoint.updatePasswordWithToken.rawValue,
                    method: .put,
                    parameters: params) { result in
                        switch result {
                        case .failure(let error):
                            break
                        case .success(let jsonData):
                            print("successful request")
                        }
        }
    }
    
    func registerDevice(deviceToken: String) {
        var params: [String: Any] = [:]
        params.updateValue(deviceToken, forKey: RequestParameter.deviceToken)
        params.updateValue("ios", forKey: RequestParameter.devicePlatform)
        sendRequest(endpoint: Endpoint.registerDevice.rawValue,
                    method: .post,
                    parameters: params) { result in
                        switch result {
                        case .failure(let error):
                            break
                        case .success(let jsonData):
                            print("successful request")
                        }
        }
    }
    
    func unregisterDevice(deviceToken: String) {
        var params: [String: Any] = [:]
        params.updateValue(deviceToken, forKey: RequestParameter.deviceToken)
        params.updateValue("ios", forKey: RequestParameter.devicePlatform)
        sendRequest(endpoint: Endpoint.unregisterDevice.rawValue,
                    method: .delete,
                    parameters: params) { result in
                        switch result {
                        case .failure(let error):
                            break
                        case .success(let jsonData):
                            print("successful request")
                        }
        }
    }
    
    private func sendMultipartRequest(endpoint: String, method: HTTPMethod, parameters: [String: Any], imageData: Data?, headers: [String: String], completion: ((Result<JSON>) -> Void)?) {
        let url = baseURL + endpoint
        let encodingType: ParameterEncoding = URLEncoding.default
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!,
                                         withName: key as String)
            }
            
            if let data = imageData {
                multipartFormData.append(data,
                                         withName: RequestParameter.usersImage,
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(),
           to: url,
           method: method,
           headers: headers) { result in
            switch result {
            case .success(request: let uploadRequest, streamingFromDisk: let streamingFromDisk, streamFileURL: let streamFileURL):
                uploadRequest.responseJSON { [weak self] response in
                    guard let self = self else { return }
                    completion?(self.parseResponse(response))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func loadFile(with urlString: String?, completion: @escaping (((path: String, url: String)?) -> Void)) {
        let fileLoader = FileLoader(downloadCompletion: completion)
        fileLoader.load(from: urlString ?? "")
    }
    
    private func sendRequest(endpoint: String, method: HTTPMethod, parameters: [String : Any], completion: ((Result<JSON>) -> Void)?) {
        let encodingType: ParameterEncoding = URLEncoding.default //(method == .get) ? URLEncoding.default : JSONEncoding.default
        Alamofire.request(baseURL + endpoint,
                          method: method,
                          parameters: parameters,
                          encoding: encodingType,
                          headers: headers).responseJSON { [weak self] response in
                            guard let self = self else { return }
                            completion?(self.parseResponse(response))
        }
    }
    
    private func parseResponse(_ response: DataResponse<Any>) -> Result<JSON> {
        let data = JSON(response.result.value as Any)
        guard let statusCode = response.response?.statusCode else {
            return .failure(ServerErrorFactory.unknown)
        }
        if !(200..<300).contains(statusCode) {
            let error = ServerError(type: statusCode, json: data) ?? ServerErrorFactory.unknown
            print(data)
            return .failure(error)
        }
        return .success(data)
    }
    
}
