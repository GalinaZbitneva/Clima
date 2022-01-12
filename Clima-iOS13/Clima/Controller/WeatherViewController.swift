//
//  ViewController.swift
//  Clima
// API key is 63ac20ad6ef2f9966259fa98553f1617
//api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
//api.openweathermap.org/data/2.5/weather?APPID=63ac20ad6ef2f9966259fa98553f1617&q=london&units=metric

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        // важно, стобы назначение делегата шло вначале, иначе приложение рухнет
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        
    }

   
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
       
        print(searchTextField.text!)
        searchTextField.endEditing(true)//скрываем клавиатуру
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print(searchTextField.text!)
        searchTextField.endEditing(true)//скрываем клавиатуру
        return true
    }
    
    //текстовое поле закончило редактироваться
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.getCityUrl(cityName: city)
        }
        searchTextField.text = "" // очищаем поле ввода после того как нажата кнопка поиска
    }
   
    
    //метод который срабатывет если юзер ничего не ввел в строку поиска и пытается выполнить поиск
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(weatherManager: WeatherManager, weather:WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            print(lat)
            print(lon)
            weatherManager.getLocationUrl(lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
