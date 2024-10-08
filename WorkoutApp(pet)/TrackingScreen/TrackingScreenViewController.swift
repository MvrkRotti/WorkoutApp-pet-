//
//  TrackingScreenViewController.swift
//  WorkoutApp(pet)
//
//  Created by Danil Pestov on 26.09.2024.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Firebase

final class TrackingScreenViewController: UIViewController, MKMapViewDelegate {
    //MARK: - Variables
    private let viewModel: TrackingViewModel
    private let router: Router
    
    private var mapView: MKMapView!
    private let topView = TopView()
    private let bikeButton = CustomTrackingButton(type: .bike)
    private let runningButton = CustomTrackingButton(type: .running)
    private let startButton = CustomTrackingButton(type: .start)
    private let pauseButton = CustomTrackingButton(type: .pause)
    private let finishButton = CustomTrackingButton(type: .finish)
    
    private var locationManager: CLLocationManager!
    private var polyline: MKPolyline?
    
    
    //MARK: - Lifecycle
    init(viewModel: TrackingViewModel, router: Router) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        locationManagerSetttings()
        setupUI()
        setupLayoout()
        setupActions()
        addTabBarSeparator()
        setupDefaultType()
        
        viewModel.onUpdateMetrics = { [weak self] distance, time, calories in
            self?.updateTopView(distance: distance, time: time, calories: calories)
        }
        
        viewModel.onTrackingStatusChanged = { [weak self] isTracking, isPaused in
            self?.updateButtons(isTracking: isTracking, isPaused: isPaused)
        }
    }
}

private extension TrackingScreenViewController {
    func setupUI() {
        view.backgroundColor = ColorResources.white
        navBarSettingsWith(title: Const.tracking)
        
        setupViews(topView, bikeButton, runningButton, startButton, pauseButton, finishButton)
    }
    
    func setupLayoout() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 7),
            
            bikeButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 18),
            bikeButton.widthAnchor.constraint(equalTo: bikeButton.heightAnchor),
            bikeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: self.view.bounds.width / 20),
            bikeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -self.view.bounds.width / 16),
            
            runningButton.heightAnchor.constraint(equalTo: bikeButton.heightAnchor),
            runningButton.widthAnchor.constraint(equalTo: bikeButton.widthAnchor),
            runningButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -self.view.bounds.width / 20),
            runningButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -self.view.bounds.width / 16),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 15),
            startButton.centerYAnchor.constraint(equalTo: bikeButton.centerYAnchor),
            startButton.leadingAnchor.constraint(equalTo: bikeButton.trailingAnchor, constant: 10),
            startButton.trailingAnchor.constraint(equalTo: runningButton.leadingAnchor, constant: -10),
            
        ])
    }
    
    func setupMapView() {
        mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.showsUserLocation = true
        view.addSubview(mapView)
    }
    
    func locationManagerSetttings() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func setupActions() {
        bikeButton.addTarget(self, action: #selector(bikeTapped), for: .touchUpInside)
        runningButton.addTarget(self, action: #selector(reunTapped), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
    }
    
    private func updateTopView(distance: Double, time: TimeInterval, calories: Double) {
        let timeString = formatTimeInterval(time)
        let distanceString = formatDistance(distance)
        topView.updateMetrics(distance: distanceString, time: timeString, calories: calories)
    }

    private func formatTimeInterval(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: Const.totalTimeLabel, hours, minutes, seconds)
    }

    private func formatDistance(_ distance: Double) -> String {
        if distance >= 1000 {
            let kilometers = distance / 1000
            return String(format: Const.distanceLabel, kilometers)
        } else {
            return String(format: Const.distanceLabel, distance)
        }
    }
    
    
    private func updateButtons(isTracking: Bool, isPaused: Bool) {
        if isTracking {
            startButton.isHidden = true
            bikeButton.isHidden = true
            runningButton.isHidden = true
            pauseButton.isHidden = false
            finishButton.isHidden = false
            pauseButton.setTitle(isPaused ? Const.resumeButtonTitle : Const.pauseButtonTitle, for: .normal)
            
            NSLayoutConstraint.activate([
                pauseButton.heightAnchor.constraint(equalToConstant: view.bounds.height / 15),
                pauseButton.centerYAnchor.constraint(equalTo: bikeButton.centerYAnchor),
                pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                pauseButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 2.5),
                
                finishButton.heightAnchor.constraint(equalToConstant: view.bounds.height / 15),
                finishButton.centerYAnchor.constraint(equalTo: bikeButton.centerYAnchor),
                finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                finishButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 2.5),

            ])
        } else {
            startButton.isHidden = false
            pauseButton.isHidden = true
            finishButton.isHidden = true
            bikeButton.isHidden = false
            runningButton.isHidden = false
        }
    }
    
    @objc func bikeTapped() {
        viewModel.sportType = .cycling

        bikeButton.backgroundColor = ColorResources.customMainBlue
        bikeButton.tintColor = .red
        runningButton.backgroundColor = ColorResources.white
        startButton.setTitle(Const.cyclingButtonTitle, for: .normal)
    }

    @objc func reunTapped() {
        viewModel.sportType = .running

        bikeButton.backgroundColor = ColorResources.white
        runningButton.backgroundColor = ColorResources.customMainBlue
        runningButton.tintColor = .red
        startButton.setTitle(Const.runningButtonTitle, for: .normal)
    }

    @objc func startTapped() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        if viewModel.isTracking {
            viewModel.stopTracking(userId: userId)
        } else {
            viewModel.startTracking()
        }
    }
    
    @objc func pauseTapped() {
        viewModel.togglePauseTracking()
    }

    @objc func finishTapped() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        viewModel.finishTracking(userId: userId)
        updateButtons(isTracking: false, isPaused: false)
    }
    
    private func setupDefaultType() {
        viewModel.sportType = .running
        runningButton.backgroundColor = ColorResources.customMainBlue
        startButton.setTitle(Const.runningButtonTitle, for: .normal)
    }
}


extension TrackingScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }

        let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)

        guard viewModel.isTracking, !viewModel.isPaused else { return }

        if let lastLocation = viewModel.lastLocationBeforePause {
            viewModel.locations.append(lastLocation)
            viewModel.lastLocationBeforePause = nil
        }

        viewModel.locations.append(newLocation)

        if let polyline = polyline {
            mapView.removeOverlay(polyline)
        }

        let coordinates = viewModel.locations.map { $0.coordinate }
        polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline!)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = ColorResources.customMainBlue
            renderer.lineWidth = 4.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
