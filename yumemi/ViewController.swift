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

    @IBOutlet weak var weatherImageView: UIImageView!
    
    var yumemiAPI = YumemiWeather.self
    var loadingAPI = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ランダムな天気画像を表示する
        setWeatherImage()
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
        var weather = ""
        do {
            weather = try yumemiAPI.fetchWeather(at: "tokyo")
        } catch YumemiWeatherError.invalidParameterError {
            // TODO: YumemiWeatherError型に応じてアラートを表示
        } catch YumemiWeatherError.jsonDecodeError {
            // TODO: YumemiWeatherError型に応じてアラートを表示
        } catch YumemiWeatherError.unknownError {
            // TODO: YumemiWeatherError型に応じてアラートを表示
        } catch {
            print("想定外のエラー")
        }
        
        
        switch weather {
        case "sunny":
            weatherImageView.image = UIImage(named: "sunny");
        case "cloudy":
            weatherImageView.image = UIImage(named: "cloudy");
        case "rainy":
            weatherImageView.image = UIImage(named: "rainy");
        default:
            break
        }
        
        loadingAPI = false
    }
}

