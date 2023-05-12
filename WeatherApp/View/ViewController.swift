//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mihlali Mazomba on 2023/05/06.
//

import UIKit
import MapKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet private var backDropImage: UIImageView!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var weatherDescriptionLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    private var summaryView: UIView!
    private var weeksTempView: UIView!
    
    private var locationManager: CLLocationManager!
    
    
   lazy var viewModel = WeatherScreenViewModel(
    fetchDataInteractor: WeatherDataInteractor(),
    delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        setUpLocation()
    }
    
    private func setUpLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
       
       
       let authorizationStatus = locationManager.authorizationStatus
       if authorizationStatus == .authorizedWhenInUse
       || authorizationStatus == .authorizedAlways {
           locationManager.startUpdatingLocation()
       } else {
           locationManager.requestWhenInUseAuthorization()
       }
   }
}

extension ViewController: WeatherScreenDelegate {
    
    func showErrorMessage(error: FetchDataError) {
        stopLoadingIndicator()
        
        var errorMessage = ""
        switch error {
        case .corruptData , .badURL:
            errorMessage = "We can not process your request right now,please try again later "
        default:
            errorMessage = "Something has gone wrong, please try again"
        }
        
        let message = UIAlertController(title: "Error" , message: errorMessage, preferredStyle: .alert)
        
        let OkAction = UIAlertAction(title: "OK", style: .default) { action in
            
        }
        message.addAction(OkAction)
        self.present(message, animated: true, completion: nil)
    }
    
    func refreshView() {
        backDropImage.image = UIImage(named: viewModel.weatherData.backGroundImage ?? "")
        temperatureLabel.text = viewModel.currentTemperaturString
        weatherDescriptionLabel.text = viewModel.weatherDescription
        setupDetailView()
        setUpWeekTemperatureView()
        stopLoadingIndicator()
        self.view.backgroundColor = UIColor(viewModel.weatherBackGroundColor)
    }
    
    private func stopLoadingIndicator() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.stopAnimating()
    }
    
    private func setupDetailView() {
        
        let daySummerController = UIHostingController(rootView: DaySummaryTemperatureView(
                temperatures: viewModel.weatherDaysSummary,
                backgroundColor: viewModel.weatherBackGroundColor))
        
        summaryView = daySummerController.view!
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(daySummerController)
        view.addSubview(summaryView)
        
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: backDropImage.bottomAnchor, constant: 5),
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    
        daySummerController.didMove(toParent: self)
    }
    
    private func setUpWeekTemperatureView() {
        
        let weekViewController = UIHostingController(
            rootView: WeekTemperatureView(
                weeksTemperatures: viewModel.weeksTemperature,
                backgroundColor: viewModel.weatherBackGroundColor))
        
        weeksTempView = weekViewController.view!
        weeksTempView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(weekViewController)
        view.addSubview(weeksTempView)
        
        NSLayoutConstraint.activate([
            weeksTempView.topAnchor.constraint(equalTo: summaryView.bottomAnchor),
            weeksTempView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weeksTempView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        weekViewController.didMove(toParent: self)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager = nil
        guard let location = locations.last else { return }
        viewModel.currentLocation = location
        viewModel.fetchCurrentWeatherData()
    }
}
