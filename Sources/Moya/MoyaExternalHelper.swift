//
//  MoyaExternalHelper.swift
//  Moya
//
//  Created by Andrei Marcu on 10/07/2019.
//

import Foundation
import Alamofire

public struct MoyaExternalHelper {
    public static var externalLogger: ((_ configuration: URLSessionConfiguration) -> ())?
    public static var requestRetrier: RequestRetrier?
    public static var requestAdapter: RequestAdapter?
    
    static let manager: Manager = {
        let manager = MoyaExternalHelper.getManager()
        return manager
    }()
    
    public static func getManager(withTimeoutInterval timeoutIntervalForRequest: TimeInterval?,
                                  headers: [AnyHashable : Any] = Manager.defaultHTTPHeaders,
                                  requestRetrier: RequestRetrier = MoyaExternalHelper.requestRetrier,
                                  requestAdapter: RequestAdapter = MoyaExternalHelper.requestAdapter) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        if let timeoutIntervalForRequest = timeoutIntervalForRequest {
            configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        }
        
        MoyaExternalHelper.externalLogger?(configuration)
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        manager.retrier = requestRetrier
        manager.adapter = requestAdapter

        return manager
    }
}
