//
//  MapViewController+MKMapView.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/28/24.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    // MARK: - MapView 설정
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
        
        view.image = UIImage(named: "locationRed")
        
        animateCustomViewUp()
        
        guard let annotation = view.annotation,
              let kick = annotation.subtitle,
              let kickNum = kick else {
            print("킥보드 데이터 저장 실패")
            return
        }
        
        rentalmodal.kickboardData = kickboardManager.getKickboardWithNumber(kickboardNumber: Int(kickNum) ?? 0)
        
        rentalmodal.setViewWithKickBoardData()
        
        // 어노테이션 삭제
        rentalmodal.deleteAnnotation = {
            
            // 선택된 어노테이션 삭제
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
    
    // MARK: - MapView의 줌/아웃 제한 설정
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
    
    
    // MARK: - 어노테이션 선택시 이미지 변환
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            view.image = UIImage(named: "location")
    }
    
    // MARK: - 맵이 선택되도록 설정
    func setGesture() {
        if userDefaultsManager.getUserDefaultsUserStatus() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.cancelsTouchesInView = false
            mapView.addGestureRecognizer(tapGesture)
            mapView.isUserInteractionEnabled = true
            print("제스처 인식기 설정 완료")
        }
    }
    
    // MARK: - 맵이 선택되었을 때 annotation 추가
    @objc func handleMapTap(_ gestureReconizer: UITapGestureRecognizer) {
        
        if gestureReconizer.state != .ended {
            return
        }
        
        let touchLocation = gestureReconizer.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        // 대여중 상태일 때만 어노테이션 추가
        if userDefaultsManager.getUserDefaultsUserStatus() {
            rentalmodal.isSelectedAnnotation = true
            deleteAnnotation()
            addAnnotationAtCoordinate(locationCoordinate)
        }
    }
    
    // MARK: - 어노테이션 추가
    func addAnnotationAtCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        lastAddedAnnotation = annotation
        print("어노테이션 추가됨: \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    // MARK: - 어노테이션 삭제
    func deleteAnnotation() {
        if let annotation = lastAddedAnnotation {
            mapView.removeAnnotation(annotation)
            lastAddedAnnotation = nil // 삭제 후 변수 초기화
        }
    }
    
    // MARK: - 어노테이션 생성
    func createAnnotaion() {
        var annotations: [MKAnnotation] = []
        for i in 0..<kickboardList.count {
            annotations.append(CustomAnnotation(title: kickboardList[i].kickBoardID.rawValue, subtitle: String(kickboardList[i].kickBoardNumber), coordinate: CLLocationCoordinate2D(latitude: kickboardList[i].kickBoardLocation.0, longitude: kickboardList[i].kickBoardLocation.1), kickBoard: kickboardList[i]))
        }
        mapView.addAnnotations(annotations)
    }
}
