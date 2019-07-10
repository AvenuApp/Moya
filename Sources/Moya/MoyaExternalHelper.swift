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
    
    static let manager: Manager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        
        MoyaExternalHelper.externalLogger?(configuration)
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        manager.retrier = MoyaExternalHelper.requestRetrier
        
        return manager
        
    }()
}
