//
//  ViewController.swift
//  yumemi
//
//  Created by riku on 2021/04/02.
//

import UIKit
import YumemiWeather

class ViewController: UIViewController {
    
//    enum Weather: String {
//        case sunny = "sunny"
//        case cloudy = "cloudy"
//        case rainy = "rainy"
//    }
    
    struct Request:Codable {
        let area:String
        let date:String
    }
    
    struct Response:Codable {
        let weather:String
        let maxTemp:Int
        let minTemp:Int
        let date:String
    }

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    var yumemiAPI = YumemiWeather.self
    var loadingAPI = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapReload(_ sender: UIButton) {
        // ランダムな天気画像を表示する
        setWeatherImage()
    }
    
    private func setWeatherImage() {
        guard !loadingAPI else {
            return
        }
        loadingAPI = true
        
        // Simple ver: session2
//        let weather = yumemiAPI.fetchWeather()
        
        // Request
        let request = Request(area: "tokyo", date: "2020-04-01T12:00:00+09:00")
        var requestJson = ""
        var response:Response?
        var responseJson = ""
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(request)
            requestJson = String(data: data, encoding: .utf8)!
        } catch {
            print(error.localizedDescription)
        }
        
        // APIよりデータ取得
        do {
            // Throws ver: session3
//            weather = try yumemiAPI.fetchWeather(at: "tokyo")"
            responseJson = try yumemiAPI.fetchWeather(requestJson)
        } catch YumemiWeatherError.invalidParameterError {
            displayAlert(errorName: "invalidParameterError")
        } catch YumemiWeatherError.jsonDecodeError {
            displayAlert(errorName: "jsonDecodeError")
        } catch YumemiWeatherError.unknownError {
            displayAlert(errorName: "unknownError")
        } catch {
            print("想定外のエラー")
        }
        
        guard responseJson != "" else {
            loadingAPI = false
            return
        }
        
        // Response
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            response = try decoder.decode(Response.self, from: responseJson.data(using: .utf8)!)
        } catch {
            print(error.localizedDescription)
        }
        
        switch response?.weather {
        case "sunny":
            weatherImageView.image = UIImage(named: "sunny");
        case "cloudy":
            weatherImageView.image = UIImage(named: "cloudy");
        case "rainy":
            weatherImageView.image = UIImage(named: "rainy");
        default:
            break
        }
            
        minTempLabel.text = response?.minTemp.description
        maxTempLabel.text = response?.maxTemp.description
        
        loadingAPI = false
    }
    
    private func displayAlert(errorName: String) {
        let alert = UIAlertController(title: "エラーが発生しました", message: errorName, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

