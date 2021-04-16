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
        // FIXME: cast error
        weatherModel = WeatherModelMock()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        viewController.weatherModel = weatherModel
        _ = viewController.view
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
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
                Response(weather: "cloudy", maxTemp: 10, minTemp: 0, date: ""))
            )
        case .rainy:
            completion(.success(
                Response(weather: "rainy", maxTemp: 10, minTemp: 0, date: ""))
            )
        case .none:
            break
        }
    }
}
