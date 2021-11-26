//
//  ServerLaunchesListModelRes.swift
//  RocketLaunch
//
//  Created by Django on 2021/11/26.
//

import Foundation

/// the result of the rocket detail
public struct ServerLaunchesListModelRes: ServerModelTypeRes {
    let fairings: FairingModel?
    let links: LinkModel
    let static_fire_date_utc: String?
    let static_fire_date_unix: Int?
    let net: Bool
    let window: Int?
    let rocket: String
    let success: Bool?
    let failures: [FailureModel]
    let details: String?
    let crew: [String]
    let ships: [String]
    let capsules: [String]
    let payloads: [String]
    let launchpad: String
    let flight_number: Int
    let name: String
    let date_utc: String
    let date_unix: UInt64
    let date_local: String
    let date_precision: String
    let upcoming: Bool
    let cores: [CoreModel]
    let auto_update: Bool
    let tbd: Bool
    let launch_library_id: String?
    let id: String
}

extension ServerLaunchesListModelRes {
    public struct FairingModel: Codable {
        let reused: Bool?
        let recovery_attempt: Bool?
        let recovered: Bool?
        let ships: [String]
    }
}

extension ServerLaunchesListModelRes {
    public struct LinkModel: Codable {
        let patch: PatchModel
        let reddit: RedditModel
        let flickr: FlickrModel
        let presskit: String?
        let webcast: String?
        let youtube_id: String?
        let article: String?
        let wikipedia: String?

        public struct PatchModel: Codable {
            let small: String?
            let large: String?
        }
        public struct RedditModel: Codable {
            let campaign: String?
            let launch: String?
            let media: String?
            let recovery: String?
        }
        public struct FlickrModel: Codable {
            let small: [String]
            let original: [String]
        }
    }
}

extension ServerLaunchesListModelRes {
    public struct FailureModel: Codable {
        let time: Int
        let altitude: Int?
        let reason: String
    }
}

extension ServerLaunchesListModelRes {
    public struct CoreModel: Codable {
        let core: String?
        let flight: Int?
        let gridfins: Bool?
        let legs: Bool?
        let reused: Bool?
        let landing_attempt: Bool?
        let landing_success: Bool?
        let landing_type: String?
        let landpad: String?
    }
}


/*
 "fairings":{
          "reused":false,
          "recovery_attempt":false,
          "recovered":false,
          "ships":[
             
          ]
       },
       "links":{
          "patch":{
             "small":"https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png",
             "large":"https://images2.imgbox.com/40/e3/GypSkayF_o.png"
          },
          "reddit":{
             "campaign":null,
             "launch":null,
             "media":null,
             "recovery":null
          },
          "flickr":{
             "small":[
                
             ],
             "original":[
                
             ]
          },
          "presskit":null,
          "webcast":"https://www.youtube.com/watch?v=0a_00nJ_Y88",
          "youtube_id":"0a_00nJ_Y88",
          "article":"https://www.space.com/2196-spacex-inaugural-falcon-1-rocket-lost-launch.html",
          "wikipedia":"https://en.wikipedia.org/wiki/DemoSat"
       },
       "static_fire_date_utc":"2006-03-17T00:00:00.000Z",
       "static_fire_date_unix":1142553600,
       "net":false,
       "window":0,
       "rocket":"5e9d0d95eda69955f709d1eb",
       "success":false,
       "failures":[
          {
             "time":33,
             "altitude":null,
             "reason":"merlin engine failure"
          }
       ],
       "details":"Engine failure at 33 seconds and loss of vehicle",
       "crew":[
          
       ],
       "ships":[
          
       ],
       "capsules":[
          
       ],
       "payloads":[
          "5eb0e4b5b6c3bb0006eeb1e1"
       ],
       "launchpad":"5e9e4502f5090995de566f86",
       "flight_number":1,
       "name":"FalconSat",
       "date_utc":"2006-03-24T22:30:00.000Z",
       "date_unix":1143239400,
       "date_local":"2006-03-25T10:30:00+12:00",
       "date_precision":"hour",
       "upcoming":false,
       "cores":[
          {
             "core":"5e9e289df35918033d3b2623",
             "flight":1,
             "gridfins":false,
             "legs":false,
             "reused":false,
             "landing_attempt":false,
             "landing_success":null,
             "landing_type":null,
             "landpad":null
          }
       ],
       "auto_update":true,
       "tbd":false,
       "launch_library_id":null,
       "id":"5eb87cd9ffd86e000604b32a"
 */
