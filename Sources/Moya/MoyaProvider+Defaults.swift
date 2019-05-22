import Foundation

/// These functions are default mappings to `MoyaProvider`'s properties: endpoints, requests, manager, etc.
public extension MoyaProvider {
    final class func defaultEndpointMapping(for target: Target) -> Endpoint {
        return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }

    final class func defaultRequestMapping(for endpoint: Endpoint, closure: RequestResultClosure) {
        do {
            let urlRequest = try endpoint.urlRequest()
            closure(.success(urlRequest))
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }

    final class func defaultAlamofireManager() -> Manager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders

        #warning ("Enable Instabug network logging")
        MoyaLoggingHelper.externalLogger?(configuration)
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        return manager
    }
}

public struct MoyaLoggingHelper {
     public static var externalLogger: ((_ configuration: URLSessionConfiguration) -> ())?
}
