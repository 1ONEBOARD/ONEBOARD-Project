//
//  MapViewController.swift
//  OneBoardProject
//
//  Created by CaliaPark on 4/22/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    let manager = CLLocationManager()
    var kickboardManager = KickboardDataManager()
    var kickboardList = [Kickboard]()
    
    var myLocationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "myLocation"), for: .normal)
        button.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var myProfileButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "myProfile"), for: .normal)
        button.addTarget(self, action: #selector(myProfileButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var buttonStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [myLocationButton, myProfileButton])
        stview.axis = .vertical
        stview.distribution = .fillEqually
        stview.alignment = .fill
        return stview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKickboardData()
        setupMapView()
        setupButton()
        setupBackButton()
    }
    
    func setupKickboardData() {
        kickboardList = kickboardManager.getKickboardData()
    }
    
    func setupMapView() {
        mapView = MKMapView(frame: self.view.bounds)
        self.view.addSubview(mapView)
        
        mapView.preferredConfiguration = MKStandardMapConfiguration()
        self.manager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        
        let center = CLLocationCoordinate2D(latitude: 37.5024, longitude: 127.0445)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)
        createAnnotaion()
    }
    
    func createAnnotaion() {
        var annotations: [MKAnnotation] = []
        for i in 0..<kickboardList.count {
            annotations.append(CustomAnnotation(title: kickboardList[i].kickBoardID, subtitle: String(kickboardList[i].kickBoardNumber), coordinate: CLLocationCoordinate2D(latitude: kickboardList[i].kickBoardLocation.0, longitude: kickboardList[i].kickBoardLocation.1), kickBoard: kickboardList[i]))
        }
        mapView.addAnnotations(annotations)
    }
    
    func setupButton() {
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
    }
    
    func setupBackButton() {
        let backImage = UIImage(named: "lessthan")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage

        // Back 버튼 타이틀 제거
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = .black
        self.navigationItem.backBarButtonItem = backButton
    }
    
    @objc func myProfileButtonTapped() {
        let storyboard = UIStoryboard(name: "UserStoryboard", bundle: nil)
        if let modalVC = storyboard.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController {
            navigationController?.pushViewController(modalVC, animated: true)
        }
    }
    
    @objc func myLocationButtonTapped() {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "Custom"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "location")
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        }
        return annotationView
    }
    
    
    // MARK: - annotation 선택시 모달창 띄움
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let storyboard = UIStoryboard(name: "UserStoryboard", bundle: nil)
        if let modalViewController = storyboard.instantiateViewController(withIdentifier: "RentalViewController") as? RentalViewController {
            modalViewController.modalPresentationStyle = .overCurrentContext
            guard let annotation = view.annotation, 
                  let kick = annotation.subtitle,
                  let kickNum = kick else { return }
            modalViewController.rentalKickboardData = kickboardManager.getKickboardWithNumber(kickboardNumber: Int(kickNum) ?? 0)
            self.present(modalViewController, animated: true, completion: nil)
        }
    }
}

class CustomAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var kickBoard: Kickboard
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, kickBoard: Kickboard) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.kickBoard = kickBoard
    }
}
