//
//  WeatherModel.swift
//  yumemi
//
//  Created by riku on 2021/04/15.
//

import Foundation
import YumemiWeather

class WeatherModelImpl: WeatherModel {
    
    var loadingAPI = false
    
    func fetchWeather(area: String, date: String, completion: @escaping (Result<Response, WeatherError>) -> Void) {
        guard !loadingAPI else {
            return
        }
        loadingAPI = true
        
        // Request
//        let request = Request(area: "tokyo", date: "2020-04-01T12:00:00+09:00")
        let request = Request(area: area, date: date)
        var requestJson = ""
        var responseJson = ""
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(request)
            requestJson = String(data: data, encoding: .utf8)!
        } catch {
            completion(.failure(WeatherError.jsonEncodeError))
            print(error.localizedDescription)
            return
        }
        
        // APIよりデータ取得
        do {
            responseJson = try YumemiWeather.fetchWeather(requestJson)
        } catch YumemiWeatherError.invalidParameterError {
            completion(.failure(WeatherError.unknownError))
            return
        } catch YumemiWeatherError.jsonDecodeError {
            completion(.failure(WeatherError.unknownError))
            return
        } catch YumemiWeatherError.unknownError {
            completion(.failure(WeatherError.unknownError))
            return
        } catch {
            print("想定外のエラー")
            return
        }
        
        guard responseJson != "" else {
            loadingAPI = false
            return
        }
        
        // Response
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            if let response = try decoder.decode(Response.self, from: responseJson.data(using: .utf8)!) as Response? {
                completion(.success(response))
            }
        } catch {
            completion(.failure(WeatherError.jsonDecodeError))
            print(error.localizedDescription)
            return
        }
        loadingAPI = false
    }
}
