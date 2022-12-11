//
//  CurrentViewController.swift
//  Weather
//
//  Created by Robert Lin on 2022/12/10.
//

import UIKit
import CoreLocation

class CurrentViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var currentWeatherImg: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
//    @IBOutlet weak var tempFeelLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var forecastBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var localTimeLabel: UILabel!
    
    var weatherInfo: CurrentWeather?
    let gradientLayer = CAGradientLayer()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLoaction()
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        dataView.layer.borderWidth = 1
        dataView.layer.borderColor = UIColor.black.cgColor
        dataView.layer.cornerRadius = 20
        
        searchBar.delegate = self
        searchBar.isHidden = true
        
    }
    
    func setupLoaction() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil{
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            fetchDataFromCoordinate()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //收鍵盤
        searchBar.resignFirstResponder()
        if let locataionString = searchBar.text,
           !locataionString.isEmpty {
            //updateWeatherForLocation 用搜尋地點抓取資料更新
            fetchDataFromCity(city: locataionString)
            searchBar.isHidden = true
        }
    }
    
    func fetchDataFromCity(city: String) {
        let urlstr = "https://api.openweathermap.org/data/2.5/\(API.weather)?q=\(city)&appid=\(API.apiKey)&units=\(API.units)&lang=\(API.lang)"

        if let url = URL(string: urlstr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970 // 解析時間

                if let data = data {
                    do {
                        let searchResponse = try decoder.decode(CurrentWeather.self, from: data)
                        self.weatherInfo = searchResponse
                        self.showCurrentWeatherInfo()
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func fetchDataFromCoordinate() {
        
        guard let currentLocation = currentLocation else { return  }
        let lon = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        print("lon:\(lon) | lat:\(lat)")
        
        let urlstr = "https://api.openweathermap.org/data/2.5/\(API.weather)?lat=\(lat)&lon=\(lon)&appid=\(API.apiKey)&units=\(API.units)&lang=\(API.lang)"
        
        if let url = URL(string: urlstr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970 // 解析時間

                if let data = data {
                    do {
                        let searchResponse = try decoder.decode(CurrentWeather.self, from: data)
                        self.weatherInfo = searchResponse
                        self.showCurrentWeatherInfo()
                        
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func showCurrentWeatherInfo() {
        if let weatherIcon = self.weatherInfo?.weather.first?.icon,
           let weatherDesc = self.weatherInfo?.weather.first?.description,
           let cityName = self.weatherInfo?.name,
           let date = self.weatherInfo?.dt,
           let localTime = self.weatherInfo?.dt,
           let temp = self.weatherInfo?.main.temp,
//           let tempFeel = self.weatherInfo?.main.feelsLike,
           let tempMin = self.weatherInfo?.main.tempMin,
           let tempMax = self.weatherInfo?.main.tempMax,
           let hum = self.weatherInfo?.main.humidity,
           let wind = self.weatherInfo?.wind.speed,
           let suffix = self.weatherInfo?.weather.first?.icon.suffix(1)
            {
            DispatchQueue.main.async {
                self.currentWeatherImg.image = UIImage(named: weatherIcon)
                self.weatherDescLabel.text = weatherDesc.capitalized
                self.locationLabel.text = cityName.capitalized
                self.dateLabel.text = "Today: \(self.dateFormate(date))"
                self.localTimeLabel.text = self.timeFormate(localTime)
                self.tempLabel.text = "\(Int(temp))ºC"
//                self.tempFeelLabel.text = "\(self.tempFormate(tempFeel))℃"
                self.tempMinLabel.text = "\(Int(tempMin))ºC    ~"
                self.tempMaxLabel.text = "\(Int(tempMax))ºC"
                self.humLabel.text = "\(hum) %"
                self.windLabel.text = String(format: "%.2f", wind) + " m/s"
                
                
//                if (suffix == "n") {
//                    self.setDarkBlueGradient()
//                }else{
//                    self.setLightBlueGradient()
//                }
            }
        }
    }
    
    // miss
    
//    func tempFormate(_ f: Double) -> String {
//        // 華氏轉換攝氏公式 ℃ = (℉-32)*5/9
//        let c = (f - 32) * 5 / 9
//
//        let tempString = String(format: "%.1f", c)
//        return tempString
//    }
    
    func dateFormate(_ date: Date?) -> String {
        guard let inputDate = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let timezone = weatherInfo?.timezone
        formatter.timeZone = TimeZone(secondsFromGMT: timezone!)
        
        return formatter.string(from: inputDate)
    }
    
    func timeFormate(_ date :Date?) -> String {
        guard let inputDate = date else { return "" }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timezone = weatherInfo?.timezone
        formatter.timeZone = TimeZone(secondsFromGMT: timezone!)
        return formatter.string(from: inputDate)
    }
    
    @IBAction func tapLocationBtn(_ sender: UIButton) {
        fetchDataFromCoordinate()
    }
    
    @IBAction func tapSearchBtn(_ sender: UIButton) {
        searchBar.isHidden = false
    }
    
    // miss

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
