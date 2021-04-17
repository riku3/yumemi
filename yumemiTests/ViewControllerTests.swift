//
//  ViewControllerTests.swift
//  yumemiTests
//
//  Created by riku on 2021/04/16.
//

import XCTest
@testable import yumemi

class ViewControllerTests: XCTestCase {

    var viewController: ViewController!
    var weatherModel: WeatherModelMock!

    override func setUpWithError() throws {
        weatherModel = WeatherModelMock()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        viewController.weatherModel = weatherModel
        _ = viewController.view
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_天気予報がsunnyの場合にImageViewのImageにsunnyが設定されること() throws {
        weatherModel.request = .sunny
        
        viewController.setWeatherImage()
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewController.weatherImageView.image, UIImage(named: "sunny"))
            XCTAssertEqual(self.viewController.minTempLabel.text, "0")
            XCTAssertEqual(self.viewController.maxTempLabel.text, "10")
        }
    }
    
    func test_天気予報がcloudyの場合にImageViewのImageにsunnyが設定されること() throws {
        weatherModel.request = .cloudy
        
        viewController.setWeatherImage()
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewController.weatherImageView.image, UIImage(named: "cloudy"))
            XCTAssertEqual(self.viewController.minTempLabel.text, "10")
            XCTAssertEqual(self.viewController.maxTempLabel.text, "20")
        }
    }
    
    func test_天気予報がrainyの場合にImageViewのImageにsunnyが設定されること() throws {
        weatherModel.request = .rainy
        
        viewController.setWeatherImage()
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewController.weatherImageView.image, UIImage(named: "rainy"))
            XCTAssertEqual(self.viewController.minTempLabel.text, "20")
            XCTAssertEqual(self.viewController.maxTempLabel.text, "30")
        }
    }
}

class WeatherModelMock: WeatherModel {

    enum TestCategory {
        case sunny
        case cloudy
        case rainy
    }

    var request: TestCategory!

    func fetchWeather(area: String, date: String, completion: @escaping (Result<Response, WeatherError>) -> Void) {
        switch request {
        case .sunny:
            completion(.success(
                Response(weather: "sunny", maxTemp: 10, minTemp: 0, date: ""))
            )
        case .cloudy:
            completion(.success(
                Response(weather: "cloudy", maxTemp: 20, minTemp: 10, date: ""))
            )
        case .rainy:
            completion(.success(
                Response(weather: "rainy", maxTemp: 30, minTemp: 20, date: ""))
            )
        case .none:
            break
        }
    }
}
