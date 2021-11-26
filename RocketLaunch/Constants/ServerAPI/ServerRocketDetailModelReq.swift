//
//  ServerRocketDetailModelReq.swift
//  RocketLaunch
//
//  Created by Django on 2021/11/26.
//

import Foundation

/// use this model to request the detail of the rocket
public struct ServerRocketDetailModelReq: Codable {
    /// rocket id
    let id: String
}
