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
            displayAlert(errorName: "invalidParameterError")
        } catch YumemiWeatherError.jsonDecodeError {
            displayAlert(errorName: "jsonDecodeError")
        } catch YumemiWeatherError.unknownError {
            displayAlert(errorName: "unknownError")
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
    
    private func displayAlert(errorName: String) {
        let alert = UIAlertController(title: "エラーが発生しました", message: errorName, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

