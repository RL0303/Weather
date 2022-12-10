//
//  CurrentViewController.swift
//  Weather
//
//  Created by Robert Lin on 2022/12/10.
//

import UIKit
import CoreLocation

class CurrentViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
//    @IBOutlet weak var currentWeatherImg: UIImageView!
//    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var tempLabel: UILabel!
//    @IBOutlet weak var weatherDescLabel: UILabel!
//    @IBOutlet weak var tempFeelLabel: UILabel!
//    @IBOutlet weak var windLabel: UILabel!
//    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var dataView: UIView!
//    @IBOutlet weak var locationBtn: UIButton!
//    @IBOutlet weak var forecastBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var localTimeLabel: UILabel!
    
//    var weatherInfo: CurrentWeather?
    let gradientLayer = CAGradientLayer()
    let locationManager = CLLocationManager()
//    var currentLocation: CLLocation?

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
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
