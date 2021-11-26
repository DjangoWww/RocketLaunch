//
//  ServerTrusManager.swift
//  RocketLaunch
//
//  Created by Django on 2021/11/26.
//

import Alamofire

/// ServerTrusManager
public final class ServerTrusManager: Alamofire.ServerTrustManager {
    init() {
        let allHostsMustBeEvaluated = false
        let evaluators = [String.emptyString: DisabledEvaluator()]
        super.init(allHostsMustBeEvaluated: allHostsMustBeEvaluated,
                   evaluators: evaluators)
    }
}
