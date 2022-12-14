//
//  ForecastTableViewController.swift
//  Weather
//
//  Created by Robert Lin on 2022/12/10.
//

import UIKit

class ForecastTableViewController: UITableViewController {
    
    var cityName: String?
    var forecastInfo: ForecastWeather?
    var forecastRow = [ForecastWeather.List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchForecastDataFromCity(city: cityName!)
        print("Forecast Report Location: \(cityName!)")
    }

    func fetchForecastDataFromCity(city: String) {
        let urlstr = "https://api.openweathermap.org/data/2.5/\(API.forecast)?q=\(city)&appid=\(API.apiKey)&units=\(API.units)&lang=\(API.lang)"
        print(urlstr)
        
        if let url = URL(string: urlstr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                if let data = data {
                    do {
                        let searchResponse = try decoder.decode(ForecastWeather.self, from: data)
                        self.forecastInfo = searchResponse
                        DispatchQueue.main.async {
                            self.forecastRow = (self.forecastInfo?.list)!
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastRow.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ForecastTableViewCell.self)", for: indexPath) as? ForecastTableViewCell else { return UITableViewCell() }
        
        //???????????????animated??????false???????????????????????????
        tableView.deselectRow(at: indexPath, animated: true)
        
        let forecastMain = forecastRow[indexPath.row].main
        let forecastWeather = forecastRow[indexPath.row].weather
        let forecastTime = forecastRow[indexPath.row].dt
//        let forcastDtText = forecastItem[indexPath.row].dtText
        
        cell.weatherImg.image = UIImage(named: forecastWeather[0].icon)
        cell.tempMinLabel.text = "?????? \(Int(forecastMain.tempMin))??C" //String(format: "?????? %.0f??C", forecastMain.tempMin)
        cell.tempMaxLabel.text = "?????? \(Int(forecastMain.tempMax))??C" //String(format: "?????? %.0f??C", forecastMain.tempMax)
        cell.humidityLabel.text = "???? \(forecastMain.humidity)%"// + String(forecastMain.humidity)
        cell.timeLabel.text = timeFormate(forecastTime)
        
        let suffix = forecastWeather[0].icon.suffix(1)
        if suffix == "n" {
            cell.backgroundColor = .black
            cell.tempMinLabel.textColor = .white
            cell.tempMaxLabel.textColor = .white
            cell.humidityLabel.textColor = .white
            cell.timeLabel.textColor = .white
        }
        if suffix == "d" {
            cell.backgroundColor = .white
            cell.tempMinLabel.textColor = .black
            cell.tempMaxLabel.textColor = .black
            cell.humidityLabel.textColor = .black
            cell.timeLabel.textColor = .black
        }
//        print("\(forcastDtText) \(forecastWeather[0].icon) ")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
//
//    func tempFormate(f: Double) -> String {
//        // ???????????????????????? ??? = (???-32)*5/9
//        let c = (f - 32) * 5 / 9
//
//        let tempString = String(format: "%.0f", c)
//        return tempString
//    }
    
    func timeFormate(_ date: Date?) -> String {
        guard let inputDate = date else { return "" }
        let formatter = DateFormatter()
        let timezone = forecastInfo?.city.timezone
        formatter.timeZone = TimeZone(secondsFromGMT: timezone!)
        // https://nsdateformatter.com/
//        formatter.dateFormat = "MM/dd E h:mm a"
        formatter.dateFormat = "MM/dd E HH:mm"
        return formatter.string(from: inputDate)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
