//
//  CurrentWeatherData.swift
//  Weather
//
//  Created by Robert Lin on 2022/12/11.
//

import Foundation

struct CurrentWeather: Codable {
    let coord: Coordinate
    let weather: [WeatherNow]
    let main: CurrentMain
    let wind: Wind
    
    var dt: Date // 現在時間
    var sys: Sys
    var timezone: Int
    var id: Int // city ID
    var name: String
}

struct Coordinate: Codable {
    var lon: Double
    var lat: Double
}

struct CurrentMain: Codable {
    var temp: Double
    var feelsLike: Double
    var tempMin: Double
    var tempMax: Double
    var humidity: Int?
    
    enum CodingKeys: String,CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}

struct WeatherNow: Codable {
    var description: String //e.g. "多雲"
    var icon: String // 圖片編號 e.g. "04d"
}

struct Wind: Codable {
    // Metric: meter/sec, Imperial: miles/hour.
    var speed: Double?
}

struct Sys: Codable{
    var sunrise: Date
    var sunset: Date
}
