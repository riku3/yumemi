//
//  PresentViewController.swift
//  yumemi
//
//  Created by riku on 2021/04/13.
//

import UIKit

class PresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // FIXME: Safe Are?の幅が大きい
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        nextVC.weatherModel = WeatherModelImpl()
        nextVC.weatherDelegate = WeatherModelDelegate()
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
}
