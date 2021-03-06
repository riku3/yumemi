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

protocol WeatherDelegate {
    func fetchWeather(area: String, date: String, completion: @escaping (Result<Response, WeatherError>) -> Void)
}

enum Weather: String, Codable {
    case sunny
    case cloudy
    case rainy
}

enum WeatherError: Error {
    case jsonEncodeError
    case jsonDecodeError
    case unknownError
}

struct Request: Codable {
    let area: String
    let date: String
}

struct Response: Codable {
    let weather: Weather
    let maxTemp: Int
    let minTemp: Int
    let date: String
}

class ViewController: UIViewController {
    
    var weatherModel: WeatherModel!
    var activityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    var weatherDelegate: WeatherDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setWeatherImage), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        activityIndicatorView.center = view.center
        activityIndicatorView.style = UIActivityIndicatorView.Style.large
        activityIndicatorView.color = .purple
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
    }
    
    deinit {
        print("deinit")
    }
    
    @IBAction func tapClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapReload(_ sender: UIButton) {
        // ランダムな天気画像を表示する
        setWeatherImage()
    }
    
    @objc func setWeatherImage() {
        // FIXME: タップしてインジケーターが表示されるまでラグがある
        self.activityIndicatorView.startAnimating()
        // DelegateのAPI取得と重複しているため、コメントアウト
//        weatherModel.fetchWeather(area: "tokyo", date: "2020-04-01T12:00:00+09:00") { result in
//            DispatchQueue.main.async {
//                self.activityIndicatorView.stopAnimating()
//                self.handleWeather(result: result)
//            }
//        }
        weatherDelegate?.fetchWeather(area: "tokyo", date: "2020-04-01T12:00:00+09:00") { result in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.handleWeather(result: result)
            }
        }
    }
    
    func handleWeather(result: Result<Response, WeatherError>) {
        switch result {
        case .success(let response):
            weatherImageView.set(weather: response.weather)
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

private extension UIImageView {
    func set(weather: Weather) {
        switch weather {
        case .sunny:
            self.image = UIImage(named: "sunny")
        case .cloudy:
            self.image = UIImage(named: "cloudy")
        case .rainy:
            self.image = UIImage(named: "rainy")
        }
    }
}

