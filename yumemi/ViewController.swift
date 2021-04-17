//
//  ViewController.swift
//  yumemi
//
//  Created by riku on 2021/04/02.
//

import UIKit

protocol WeatherModel {
    func fetchWeather(area: String, date: String, completion: @escaping (Result<Response, WeatherError>) -> Void)
}

enum WeatherError: Error {
    case jsonEncodeError
    case jsonDecodeError
    case unknownError
}

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

class ViewController: UIViewController {
    
    var weatherModel: WeatherModel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setWeatherImage), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @IBAction func tapClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapReload(_ sender: UIButton) {
        // ランダムな天気画像を表示する
        setWeatherImage()
    }
    
    @objc func setWeatherImage() {
        weatherModel.fetchWeather(area: "tokyo", date: "2020-04-01T12:00:00+09:00") { result in
            DispatchQueue.main.async {
                self.handleWeather(result: result)
            }
        }
    }
    
    func handleWeather(result: Result<Response, WeatherError>) {
        switch result {
        case .success(let response):
            switch response.weather {
            case "sunny":
                weatherImageView.image = UIImage(named: "sunny");
            case "cloudy":
                weatherImageView.image = UIImage(named: "cloudy");
            case "rainy":
                weatherImageView.image = UIImage(named: "rainy");
            default:
                break
            }
            minTempLabel.text = response.minTemp.description
            maxTempLabel.text = response.maxTemp.description
        case .failure(let error):
            let message: String
            switch error {
            case .jsonEncodeError:
                message = "jsonEncodeError"
            case .jsonDecodeError:
                message = "jsonDecodeError"
            case .unknownError:
                message = "unknownError"
            }
            displayAlert(errorName: message)
        }
    }
    
    private func displayAlert(errorName: String) {
        let alert = UIAlertController(title: "エラーが発生しました", message: errorName, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

