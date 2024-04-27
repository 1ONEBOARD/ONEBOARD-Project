//
//  MapViewController.swift
//  OneBoardProject
//
//  Created by CaliaPark on 4/22/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    // MARK: - Properties
    var mapView: MKMapView!
    let manager = CLLocationManager()
    var kickboardManager = KickboardDataManager()
    var userDefaultsManager = UserDefaultsManager.shared
    var kickboardList = [Kickboard]()
    var rentalmodal: RentalModal!
    var rentalKickboardData: Kickboard?
    var bottomConstraint = NSLayoutConstraint()
    var lastAddedAnnotation: MKAnnotation?

    
    // MARK: - UI
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
    
    var rentalMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "반납할 장소를 클릭해주세요."
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지도에 띄어질 킥보드 데이터 설정
        setupKickboardData()
        
        // MapView 설정
        setupMapView()
        
        // UserPage의 뒤로가기 버튼UI 설정
        setupBackButton()
        
        // RentalView 설정
        setupRentalModal()
        
        // ButtonUI 설정
        setupButton()
        
        // RentalViewLabel 설정
        setupRentalViewLabel()
        
        // 1초 지날때마다 타이머 업데이트
        NotificationCenter.default.addObserver(self, selector: #selector(handleTimerUpdate), name: .timerUpdated, object: nil)
        
        // Label 설정
        setupLabel()
        
        // rental창의 렌트 버튼 클릭시 실행되는 액션
        rentalmodal.rentAction = {
            self.setGesture()
            self.rentalMessageLabel.isHidden = false
        }
        
        // rental창의 취소 버튼 클릭시 실행되는 액션
        rentalmodal.cancelAction = {
            self.animateCustomViewDown()
            self.setupButton()
        }
        
        // rental창의 반납 버튼 클릭시 실행되는 액션1
        rentalmodal.returnActionWithUI = { rentalPrice in
            self.lastAddedAnnotation = nil
            self.animateCustomViewDown()
            self.rentalMessageLabel.isHidden = true
            self.showPaymentAlert(rentalPrice)
        }
        
        // rental창의 반납 버튼 클릭시 실행되는 액션2
        rentalmodal.returnAlertAction = {
            self.showNoticeAlert()
        }
    }
    
    // MARK: - Layout 설정
    
    // Button UI 설정
    func setupButton() {
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: rentalmodal.topAnchor, constant: -60)
        ])
    }
    
    // rentalMessageLabel 설정
    func setupLabel() {
        view.addSubview(rentalMessageLabel)
        rentalMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        rentalMessageLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            rentalMessageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            rentalMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rentalMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rentalMessageLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - backButton 설정
    func setupBackButton() {
        let backImage = UIImage(named: "lessthan")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage

        // Back 버튼 타이틀 제거
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = .black
        self.navigationItem.backBarButtonItem = backButton
    }
    
    
    // MARK: - 킥보드 데이터 설정
    func setupKickboardData() {
        kickboardList = kickboardManager.getKickboardData()
    }
    
    // MARK: - RentalView 설정
    func setupRentalModal() {
        rentalmodal = RentalModal()
        rentalmodal.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rentalmodal)
        
        setupInitialRentalView(for: rentalmodal)
    }

    func setupInitialRentalView(for rentalView: UIView) {
        NSLayoutConstraint.activate([
            rentalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rentalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rentalView.heightAnchor.constraint(equalToConstant: 278),
        ])
        
        if userDefaultsManager.getUserDefaultsUserStatus() {    // 사용자가 대여중이라면 RentalView 올라옴
            self.setGesture()
            bottomConstraint = rentalView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            bottomConstraint.isActive = true
        }else {                                                 // 사용자가 대여중이 아니라면 RentalView 내려감
            bottomConstraint = rentalView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 278)
            bottomConstraint.isActive = true
        }
    }

    
    // MARK: - RentalView 위로 올리기
    func animateCustomViewUp() {
        // 애니메이션을 통해 뷰를 화면 안으로 이동
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    // MARK: - RentalView 아래로 내리기
    func animateCustomViewDown() {
        // 뷰의 하단 제약조건을 화면 아래로 설정 (여기서는 뷰의 높이만큼 내려갑니다)
        bottomConstraint.constant = 278
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - RentalView의 라벨 설정
    func setupRentalViewLabel() {
        if userDefaultsManager.getUserDefaultsUserStatus() {
            rentalmodal.setViewWithUserDefaults()
        }else {
            rentalmodal.setViewWithKickBoardData()
        }
    }
    
    // MARK: - 액션

    // 프로필 버튼 액션
    @objc func myProfileButtonTapped() {
        let storyboard = UIStoryboard(name: "UserStoryboard", bundle: nil)
        if let modalVC = storyboard.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController {
            navigationController?.pushViewController(modalVC, animated: true)
        }
    }
    
    // 내 위치 버튼 액션
    @objc func myLocationButtonTapped() {
        let center = CLLocationCoordinate2D(latitude: 37.5024, longitude: 127.0445)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)
    }
    
    // 1초마다 label 업데이트 액션
    @objc func handleTimerUpdate() {
        // UI 업데이트는 메인 스레드에서 실행
        DispatchQueue.main.async {
            let time = TimerManager.shared.elapsedTime
            self.rentalmodal.durationTimeNumberLabel.text = "\(time/60)분 \(time%60)초"
            self.rentalmodal.totalPriceLabel.text = UserViewController().setPriceLabel(price: 500 + ( time / 60 ) * 180 )
        }
    }
    
    // MARK: - 얼럿창
    
    // 반납할 장소를 선택하라는 주의 얼럿창
    func showNoticeAlert() {
        let alert = UIAlertController(title: "Notice", message: "반납할 장소를 선택해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 결제 얼럿창
    func showPaymentAlert(_ rentalPrice: Int) {
        let alert = UIAlertController(title: "Payment", message: "\(UserViewController().setPriceLabel(price: rentalPrice))을 결제합니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
