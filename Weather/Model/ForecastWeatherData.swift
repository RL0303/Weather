//
//  ForecastWeatherData.swift
//  Weather
//
//  Created by Robert Lin on 2022/12/13.
//

import Foundation

struct ForecastWeather: Codable {
    var list: [List]
    let city: City
    struct List: Codable {
        let dt : Date
        var main: ForecastMain
        var weather: [WeatherForecast]
        enum CodingKeys: String,CodingKey {
            case dt
            case main
            case weather
        }
        struct ForecastMain: Codable {
            let temp: Double
            let tempMin: Double
            let tempMax: Double
            let humidity: Int

            enum CodingKeys: String,CodingKey {
                case temp
                case tempMin = "temp_min"
                case tempMax = "temp_max"
                case humidity
                
            }
        }
        struct WeatherForecast: Codable {
            let main: String //Rain
            let description: String //小雨
            let icon: String //10d
        }
    }
    
    struct City: Codable {
        let id: Int
        let name: String
        let population: Int
        let timezone: Int
        let sunrise: Date
        let sunset: Date
    }
    
    
}
