//
//  WeatherModelDelegate.swift
//  yumemi
//
//  Created by riku on 2021/04/18.
//

import Foundation
import YumemiWeather

class WeatherModelDelegate: WeatherDelegate {
    
    func encodeJson(request: Request) throws -> String {
        let encoder = JSONEncoder()
        let requestData = try encoder.encode(request)
        
        guard let requestJsonString = String(data: requestData, encoding: .utf8) else {
            throw WeatherError.jsonEncodeError
        }
        return requestJsonString
    }
    
    func decodeJson(jsonString: String) throws -> Response {
        guard let responseData = jsonString.data(using: .utf8) else {
            throw WeatherError.jsonDecodeError
        }
        
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let response = try? decoder.decode(Response.self, from: responseData) else {
            throw WeatherError.jsonDecodeError
        }
        
        return response
    }
    
    func fetchWeather(area: String, date: String, completion: @escaping (Result<Response, WeatherError>) -> Void) {
        
        guard let requestJson = try? encodeJson(request: Request(area: area, date: date)) else {
            completion(.failure(WeatherError.jsonEncodeError))
            return
        }
        
        var responseJson = ""
        do {
            responseJson = try YumemiWeather.syncFetchWeather(requestJson)
        } catch YumemiWeatherError.invalidParameterError {
            completion(.failure(WeatherError.unknownError))
            return
        } catch YumemiWeatherError.jsonDecodeError {
            completion(.failure(WeatherError.unknownError))
            return
        } catch YumemiWeatherError.unknownError {
            completion(.failure(WeatherError.unknownError))
            return
        } catch let error {
            print("想定外のエラー:\(error)")
            return
        }
        
        guard responseJson != "" else {
            completion(.failure(WeatherError.unknownError))
            return
        }
        
        if let response = try? decodeJson(jsonString: responseJson) {
            completion(.success(response))
        } else {
            completion(.failure(WeatherError.jsonDecodeError))
        }
    }
}

