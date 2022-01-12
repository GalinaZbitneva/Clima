//
//  WeatherManager.swift
//  Clima
//
//  Created by Галина Збитнева on 19.09.2021.

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, weather:WeatherModel)
}

struct WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?APPID=63ac20ad6ef2f9966259fa98553f1617&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func getCityUrl(cityName:String){
        let cityUrl = url + "&q=" + cityName
        print(cityUrl)
        performRequest(urlString: cityUrl)
    }
    
    func getLocationUrl(lat:String, lon:String){
       let locationUrl = url + "&lat=" + lat + "&lon=" + lon
        performRequest(urlString: locationUrl)
    }
    
    func performRequest(urlString: String){
        //1.Create a URL
        
        if let url = URL(string: urlString){
            //2.Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        //те мы получили структуру типа WeatherModel
                        delegate?.didUpdateWeather(weatherManager: self, weather: weather)
                        
                    }
                }
            }
            
            //4.start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            //print (Int(decodedData.main.temp))// temperature
            let id = decodedData.weather[0].id // 0 индекс так как у нас всего один элемент id в массиве weather
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
           return weather
             
        } catch {
            print(error)
            return nil
        }
        
    }
    
    
}
