//
//  ServerAPI.swift
//  RocketLaunch
//
//  Created by Django on 2021/11/26.
//

import Moya

/// Server API
public enum ServerAPI {
    /// get launchesList
    case getLaunchesList
    /// get rocket details
    case getRocketDetail(_ model: ServerRocketDetailModelReq)
}

// MARK: - TargetType
extension ServerAPI: TargetType {
    public var headers: [String : String]? {
        return nil
    }

    public var baseURL: URL {
        return "https://api.spacexdata.com".urlValue!
    }

    public var path: String {
        switch self {
        case .getLaunchesList:
            return "v4/launches"
        case .getRocketDetail:
            return "/v4/rockets"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getLaunchesList,
             .getRocketDetail:
            return .get
        }
    }

    public var sampleData: Data {
        return String.emptyString.data(using: .utf8)!
    }

    public var task: Task {
        switch self {
        case .getLaunchesList:
            return .requestPlain
        case .getRocketDetail(let model):
            let param = model.dictValue() ?? [:]
            return .requestParameters(
                parameters: param,
                encoding: URLEncoding.queryString
            )
        }
    }
}
