//
//  ServerRocketDetailModelRes.swift
//  RocketLaunch
//
//  Created by Django on 2021/11/26.
//

import Foundation

/// the result of the rocket detail
public struct ServerRocketDetailModelRes: ServerModelTypeRes {
    let height: DigitalModel
    let diameter: DigitalModel
    let mass: MassModel
    let first_stage: FirstStageModel
    let second_stage: SecondStageModel
    let engines: EngineModel
    let landing_legs: LandingLegModel
    let payload_weights: [PayloadWeightModel]
    let flickr_images: [String]
    let name: String
    let type: TypeEnum
    let active: Bool
    let stages: Int
    let boosters: Int
    let cost_per_launch: Int
    let success_rate_pct: Int
    let first_flight: String
    let country: String
    let company: String
    let wikipedia: String
    let description: String
    let id: String
}

extension ServerRocketDetailModelRes {
    public struct ThrustModel: Codable {
        let kN: Int
        let lbf: Int
    }
    public struct DigitalModel: Codable {
        let meters: Double?
        let feet: Double?
    }
}

extension ServerRocketDetailModelRes {
    public struct MassModel: Codable {
        let kg: Int
        let lb: Int
    }
}

extension ServerRocketDetailModelRes {
    public struct FirstStageModel: Codable {
        let thrust_sea_level: ThrustModel
        let thrust_vacuum: ThrustModel
        let reusable: Bool
        let engines: Int
        let fuel_amount_tons: Double
        let burn_time_sec: Int?
    }
}

extension ServerRocketDetailModelRes {
    public struct SecondStageModel: Codable {
        let thrust: ThrustModel
        let payloads: PayloadModel
        let reusable: Bool
        let engines: Int
        let fuel_amount_tons: Double
        let burn_time_sec: Int?

        public struct PayloadModel: Codable {
            let composite_fairing: CompositeFairingModel
            let option_1: String

            public struct CompositeFairingModel: Codable {
                let height: DigitalModel
                let diameter: DigitalModel
            }
        }
    }
}

extension ServerRocketDetailModelRes {
    public struct EngineModel: Codable {
        let isp: IspModel
        let thrust_sea_level: ThrustModel
        let thrust_vacuum: ThrustModel
        let number: Int
        let type: ServerRocketDetailModelRes.TypeEnum
        let version: String
        let layout: String?
        let engine_loss_max: Int?
        let propellant_1: String
        let propellant_2: String
        let thrust_to_weight: Double

        public struct IspModel: Codable {
            let sea_level: Int
            let vacuum: Int
        }
    }
}

extension ServerRocketDetailModelRes {
    public struct LandingLegModel: Codable {
        let number: Int
        let material: String?
    }
}

extension ServerRocketDetailModelRes {
    public struct PayloadWeightModel: Codable {
        let id: String
        let name: String
        let kg: Int
        let lb: Int
    }
}

extension ServerRocketDetailModelRes {
    public enum TypeEnum: String, Codable {
        case merlin
        case rocket
        case raptor
    }
}

/*
 "height":{
          "meters":22.25,
          "feet":73
       },
       "diameter":{
          "meters":1.68,
          "feet":5.5
       },
       "mass":{
          "kg":30146,
          "lb":66460
       },
       "first_stage":{
          "thrust_sea_level":{
             "kN":420,
             "lbf":94000
          },
          "thrust_vacuum":{
             "kN":480,
             "lbf":110000
          },
          "reusable":false,
          "engines":1,
          "fuel_amount_tons":44.3,
          "burn_time_sec":169
       },
       "second_stage":{
          "thrust":{
             "kN":31,
             "lbf":7000
          },
          "payloads":{
             "composite_fairing":{
                "height":{
                   "meters":3.5,
                   "feet":11.5
                },
                "diameter":{
                   "meters":1.5,
                   "feet":4.9
                }
             },
             "option_1":"composite fairing"
          },
          "reusable":false,
          "engines":1,
          "fuel_amount_tons":3.38,
          "burn_time_sec":378
       },
       "engines":{
          "isp":{
             "sea_level":267,
             "vacuum":304
          },
          "thrust_sea_level":{
             "kN":420,
             "lbf":94000
          },
          "thrust_vacuum":{
             "kN":480,
             "lbf":110000
          },
          "number":1,
          "type":"merlin",
          "version":"1C",
          "layout":"single",
          "engine_loss_max":0,
          "propellant_1":"liquid oxygen",
          "propellant_2":"RP-1 kerosene",
          "thrust_to_weight":96
       },
       "landing_legs":{
          "number":0,
          "material":null
       },
       "payload_weights":[
          {
             "id":"leo",
             "name":"Low Earth Orbit",
             "kg":450,
             "lb":992
          }
       ],
       "flickr_images":[
          "https://imgur.com/DaCfMsj.jpg",
          "https://imgur.com/azYafd8.jpg"
       ],
       "name":"Falcon 1",
       "type":"rocket",
       "active":false,
       "stages":2,
       "boosters":0,
       "cost_per_launch":6700000,
       "success_rate_pct":40,
       "first_flight":"2006-03-24",
       "country":"Republic of the Marshall Islands",
       "company":"SpaceX",
       "wikipedia":"https://en.wikipedia.org/wiki/Falcon_1",
       "description":"The Falcon 1 was an expendable launch system privately developed and manufactured by SpaceX during 2006-2009. On 28 September 2008, Falcon 1 became the first privately-developed liquid-fuel launch vehicle to go into orbit around the Earth.",
       "id":"5e9d0d95eda69955f709d1eb"
 */
