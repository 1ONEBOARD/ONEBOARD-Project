//
//  RentalModal.swift
//  OneBoardProject
//
//  Created by 김건응 on 4/25/24.
//

import UIKit

class RentalModal: UIView {
    
    
    // MARK: - Outlets
    @IBOutlet weak var rentalView: UIView!
    @IBOutlet weak var kickBoardIdLabel: UILabel!
    @IBOutlet weak var kickBoardNumberLabel: UILabel!
    @IBOutlet weak var kickBoardImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var durationTimeNumberLabel: UILabel!
    @IBOutlet weak var returnBikeButton: UIButton!
    @IBOutlet weak var rentButton: UIButton!
    @IBOutlet weak var priceBackgroundView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    // MARK: - Properties
    var rentalDataManager = RentalDataManager.shared
    var userDefaultsManager = UserDefaultsManager.shared
    
    var kickboardData: Kickboard?
    
    var cancelAction: (() -> Void)?
    var deleteAnnotation: (() -> Void)?
    var returnAlertAction: (() -> Void)?
    var returnAction: (() -> Void)?
    var returnActionWithUI: ((Int) -> Void)?
    var rentAction: (() -> Void)?
    var passthroughAreas: [CGRect] = []
    
    var isSelectedAnnotation: Bool = false
    
    
    // MARK: - init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        
        let bundle = Bundle.init(for: self.classForCoder)
        let view = bundle.loadNibNamed("RentalModalView",
                                       owner: self,
                                       options: nil)?.first as! UIView
        
        view.frame = self.bounds
        self.addSubview(view)
        
        setupView()
        updateViewWithUserStatus()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - View setting
    func setupView() {
        
        // backgroundView 둥글게
        rentalView.layer.maskedCorners = CACornerMask.init(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        rentalView.layer.cornerRadius = 20
        
        // cancelButton의 테두리 설정
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.gcoo.cgColor
        
        rentButton.backgroundColor = UIColor.gcoo
        rentButton.tintColor = UIColor.gcoo
        
        returnBikeButton.backgroundColor = UIColor.gcoo
        returnBikeButton.tintColor = UIColor.gcoo
        
        priceBackgroundView.layer.cornerRadius = 5
    }
    
    func setupKickboardImageView(kickBoardID: KickboardID) {
        switch kickBoardID {
        case .oneBaseA1:
            kickBoardImageView.image = UIImage(named: KickboardID.oneBaseA1.rawValue)
        case .oneBaseA2:
            kickBoardImageView.image = UIImage(named: KickboardID.oneBaseA2.rawValue)
        case .oneProA1:
            kickBoardImageView.image = UIImage(named: KickboardID.oneProA1.rawValue)
        case .oneProA2:
            kickBoardImageView.image = UIImage(named: KickboardID.oneProA2.rawValue)
        }
    }
    
    
    // MARK: - 대여중이 아닐 때 킥보드 데이터에 따른 view 세팅
    func setViewWithKickBoardData() {
        
        // 킥보드 라벨 설정
        guard let kickboardData = kickboardData else {
            print("킥보드 데이터가 없습니다.")
            return
        }
        
        kickBoardIdLabel.text = kickboardData.kickBoardID.rawValue
        kickBoardNumberLabel.text = "\(kickboardData.kickBoardNumber)"
        
        setupKickboardImageView(kickBoardID: kickboardData.kickBoardID)
    }
    
    
    // MARK: - 대여중일때 유저 정보에 따른 view 세팅
    func setViewWithUserDefaults() {
        
        let kickboardID = userDefaultsManager.getUserDefaultsKickboardID()
        kickBoardIdLabel.text = kickboardID
        kickBoardNumberLabel.text = "\(userDefaultsManager.getUserDefaultsKickboardNumber())"
        
        // ImageView 설정
        setupKickboardImageView(kickBoardID: KickboardID(rawValue: kickboardID) ?? .oneBaseA1)
    }
    
    
    // MARK: - 유저가 대여중 여부에 따른 RentalView 업데이트
    func updateViewWithUserStatus() {
        
        if userDefaultsManager.getUserDefaultsUserStatus() {
            
            durationTimeLabel.text = "이용시간"
            durationTimeNumberLabel.text = "0분 0초"
            
            cancelButton.isHidden = true
            rentButton.isHidden = true
            kickBoardImageView.isHidden = true
            
            durationTimeLabel.isHidden = false
            durationTimeNumberLabel.isHidden = false
            returnBikeButton.isHidden = false
            totalPriceLabel.isHidden = false
        }else {
            
            cancelButton.isHidden = false
            rentButton.isHidden = false
            kickBoardImageView.isHidden = false
            
            durationTimeLabel.isHidden = true
            durationTimeNumberLabel.isHidden = true
            returnBikeButton.isHidden = true
            totalPriceLabel.isHidden = true
        }
    }
    
    
    // MARK: - View 취소 버튼
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        // view 내리고, button 위치 세팅
        cancelAction?()
    }
    
    
    // MARK: - 킥보드 대여 버튼
    @IBAction func rentButtonTapped(_ sender: UIButton) {
        
        // 유저 대여중 상태 업데이트
        userDefaultsManager.setUserDefaults(userStatus: true)
    
        // modalView 세팅
        updateViewWithUserStatus()
        
        // 현재 대여중인 킥보드 어노테이션 삭제
        deleteAnnotation?()
        
        // 반납장소 선택이 가능하도록 제스처 설정
        rentAction?()
        
        // 현재 대여중인 킥보드 데이터 정보 저장
        guard let kickboardData = kickboardData else {
            print("kickboardData 저장 싪패")
            return
        }
        
        // 현재 시간을 "yyyy.MM.dd hh:mm a"꼴로 변환
        var now = ""
        now.setDate(Date())
        
        // 현재 대여중인 킥보드 정보 UserDefaults에 업데이트
        userDefaultsManager.setRentalKickboardData(kickboardId: kickboardData.kickBoardID.rawValue, 
                                                   kickboardNumber: kickboardData.kickBoardNumber,
                                                   rentalStartTime: now)
        
        // 타이머 시작
        TimerManager.shared.startTimer()
    }
    
    
    // MARK: - 킥보드 반납 버튼
    @IBAction func returnBikeButtonTapped(_ sender: UIButton) {
        if isSelectedAnnotation {
            isSelectedAnnotation = false
            
            // UserDefaults에서 유저 정보와 현재 대여중인 킥보드 정보 가져오기
            let userID = userDefaultsManager.getUserDefaultsUserID()
            let kickboardID = userDefaultsManager.getUserDefaultsKickboardID()
            let kickboardNumber = userDefaultsManager.getUserDefaultsKickboardNumber()
            let rentalStartTime = userDefaultsManager.getUserDefaultsKickboardStartTime()
            let currentTime = TimerManager.shared.elapsedTime / 60
            let rentalPrice = 500 + currentTime * 180
            
            // RentalList 코어 데이터에 값 업로드
            let rental = Rental(userID: userID, kickBoardID: kickboardID, kickBoardNumber: kickboardNumber, rentalStartTime: rentalStartTime, rentalTotalTime: currentTime, rentalPrice: rentalPrice)
            
            rentalDataManager.createRentalData(data: rental)
            
            // 유저 대여중 상태 업데이트
            userDefaultsManager.setUserDefaults(userStatus: false)
            
            // modalView 세팅
            updateViewWithUserStatus()
            
            // 반납한 킥보드 어노테이션 맵에 추가
            returnAction?()
            
            // 타이머 종료
            NotificationCenter.default.removeObserver(self)
            TimerManager.shared.stopTimer()
            
            // RentalView 내리기
            returnActionWithUI?(rentalPrice)
            
        }else {
            returnAlertAction?()
            print("어노테이션이 선택되지 않음")
        }
    }
}

