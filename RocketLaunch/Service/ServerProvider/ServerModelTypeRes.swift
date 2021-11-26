//
//  ServerModelTypeRes.swift
//  RocketLaunch
//
//  Created by Django on 2021/11/26.
//

import Foundation

public protocol ServerModelTypeRes: Codable { }
extension Optional: ServerModelTypeRes where Wrapped: ServerModelTypeRes { }
extension Array: ServerModelTypeRes where Element: ServerModelTypeRes { }
