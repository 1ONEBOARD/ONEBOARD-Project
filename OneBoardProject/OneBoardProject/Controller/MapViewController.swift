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
    var userDefaultsManager = UserDefaultsManager.shared
    var kickboardList = [Kickboard]()
    var rentalmodal: RentalModal!
    var rentalKickboardData: Kickboard?
    
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
        setupRentalModal()
        rentalmodal.cancelAction = {
            self.deleteRentalModal()
            self.buttonStackView.removeFromSuperview()
            self.setupButton()
        }
        print(userDefaultsManager.getUserDefaultsUserStatus())
    }
    
    func setupRentalModal() {
        rentalmodal = RentalModal()
    }
    func pushRentalModal() {
        view.addSubview(rentalmodal)
        rentalmodal.frame = view.bounds
    }
    
    func deleteRentalModal() {
        rentalmodal.removeFromSuperview()
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
        
        // 대여중일때 맵뷰에서 위치 선택하여 반납
        if UserDefaults.standard.bool(forKey: "userStatus") == true {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
            mapView.addGestureRecognizer(tapGesture)
        }
        
        let center = CLLocationCoordinate2D(latitude: 37.5024, longitude: 127.0445)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)
        createAnnotaion()
    }
    
    @objc func handleMapTap(_ gestureReconizer: UITapGestureRecognizer) {
        if gestureReconizer.state != .ended {
            return
        }
        let touchLocation = gestureReconizer.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        pushRentalModal()
        
        rentalmodal.returnButtonAction = {
            self.addAnnotationAtCoordinate(locationCoordinate)
        }
//        let alert = UIAlertController(title: "반납하기", message: "이곳에 반납하시겠습니까?", preferredStyle: .alert)
//        let success = UIAlertAction(title: "확인", style: .default) { action in
//            self.addAnnotationAtCoordinate(locationCoordinate)
//            UserDefaults.standard.setValue(false, forKey: "userStatus")
//        }
//        let cancel = UIAlertAction(title: "취소", style: .cancel)
//             
//        alert.addAction(success)
//        alert.addAction(cancel)
//        
//        self.present(alert, animated: true, completion: nil)
    }
    
    func addAnnotationAtCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    func createAnnotaion() {
        var annotations: [MKAnnotation] = []
        for i in 0..<kickboardList.count {
            annotations.append(CustomAnnotation(title: kickboardList[i].kickBoardID, subtitle: String(kickboardList[i].kickBoardNumber), coordinate: CLLocationCoordinate2D(latitude: kickboardList[i].kickBoardLocation.0, longitude: kickboardList[i].kickBoardLocation.1), kickBoard: kickboardList[i]))
        }
        mapView.addAnnotations(annotations)
    }
    
    // 맵뷰 줌 아웃 제한
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let maxRegionSpan: CLLocationDegrees = 0.01
        var span = mapView.region.span

        span.latitudeDelta = min(span.latitudeDelta, maxRegionSpan)
        span.longitudeDelta = min(span.longitudeDelta, maxRegionSpan)

        if mapView.region.span.latitudeDelta > maxRegionSpan || mapView.region.span.longitudeDelta > maxRegionSpan {
            let newRegion = MKCoordinateRegion(center: mapView.region.center, span: span)
            mapView.setRegion(newRegion, animated: true)
        }
    }
    
    func setupButton() {
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60)
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
        let center = CLLocationCoordinate2D(latitude: 37.5024, longitude: 127.0445)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "Custom"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            annotationView?.image = UIImage(named: "location")
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
            annotationView?.rightCalloutAccessoryView = button
        }
        return annotationView
    }
    
    
    // MARK: - annotation 선택시 모달창 띄움
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        buttonStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -300).isActive = true
        
        UIView.animate(withDuration: 0.5) {
            self.buttonStackView.layoutIfNeeded()
        }
        
        view.image = UIImage(named: "locationRed")
        
        pushRentalModal()
        
        
        guard let annotation = view.annotation,
              let kick = annotation.subtitle,
              let kickNum = kick else {
            print("킥보드 데이터 저장 실패")
            return
        }
        
        
        rentalmodal.kickboardData = kickboardManager.getKickboardWithNumber(kickboardNumber: Int(kickNum) ?? 0)
        
        // 어노테이션 삭제
        rentalmodal.deleteAnnotation = {
            if let annotation = view.annotation {
                UIView.animate(withDuration: 0.2, animations: { view.alpha = 0 }) { (finished) in
                    if finished {
                        mapView.removeAnnotation(annotation)
                        view.alpha = 1
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            view.image = UIImage(named: "location")
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
