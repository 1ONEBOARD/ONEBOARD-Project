//
//  RentalModal.swift
//  OneBoardProject
//
//  Created by 김건응 on 4/25/24.
//

import UIKit

class RentalModal: UIView {
    
    @IBOutlet weak var rentalView: UIView!
    @IBOutlet weak var kickBoardIdLabel: UILabel!
    @IBOutlet weak var kickBoardNumberLabel: UILabel!
    @IBOutlet weak var kickBoardImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var durationTimeNumberLabel: UILabel!
    @IBOutlet weak var returnBikeButton: UIButton!
    @IBOutlet weak var rentButton: UIButton!
    
    var rentalDataManager = RentalDataManager.shared
    var userDefaultsManager = UserDefaultsManager.shared
    var cancelAction: (() -> Void)?
    var setKickBoardData: (() -> Void)?
    var kickboardData: Kickboard?
    var deleteAnnotation: (() -> Void)?
    var returnButtonAction: (() -> Void)?
    var rentalmodalReady: ((RentalModal) -> Void)?
    var passthroughAreas: [CGRect] = []
    
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
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 해당 포인트가 통과 영역 안에 있는지 확인
        for area in passthroughAreas {
            if area.contains(point) {
                // 터치 이벤트를 무시하고 뒤에 있는 뷰로 전달
                return nil
            }
        }
        
        // 기본 동작 수행
        return super.hitTest(point, with: event)
    }
    
    func setupView() {
        
        // background 둥글게
        rentalView.layer.maskedCorners = CACornerMask.init(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        rentalView.layer.cornerRadius = 20
        
        cancelButton.layer.borderWidth = 1
        
        if userDefaultsManager.getUserDefaultsUserStatus() {
            durationTimeLabel.text = "이용시간"
            durationTimeNumberLabel.text = "\(userDefaultsManager.calculateKickboardTotalTime())"
            cancelButton.isHidden = true
            rentButton.isHidden = true
            durationTimeLabel.isHidden = false
            durationTimeNumberLabel.isHidden = false
            returnBikeButton.isHidden = false
            kickBoardImageView.isHidden = true
        }else {
            cancelButton.isHidden = false
            rentButton.isHidden = false
            durationTimeLabel.isHidden = true
            durationTimeNumberLabel.isHidden = true
            returnBikeButton.isHidden = true
            kickBoardImageView.isHidden = false
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        cancelAction?()
    }
    
    @IBAction func rentButtonTapped(_ sender: UIButton) {
        
        userDefaultsManager.setUserDefaults(userStatus: true)
        setupView()
        
        // 어노테이션 삭제
        deleteAnnotation?()
        guard let kickboardData = kickboardData else {
            print("kickboardData 저장 싪패")
            return
        }
        var now = ""
        now.setDate(Date())
        print("현재 시간은 \(now)")
        userDefaultsManager.setRentalKickboardData(kickboardId: kickboardData.kickBoardID, kickboardNumber: kickboardData.kickBoardNumber, rentalStartTime: now)
    }
    
    @IBAction func returnBikeButtonTapped(_ sender: UIButton) {
        let userID = userDefaultsManager.getUserDefaultsUserID()
        let kickboardID = userDefaultsManager.getUserDefaultsKickboardID()
        let kickboardNumber = userDefaultsManager.getUserDefaultsKickboardNumber()
        let rentalStartTime = userDefaultsManager.getUserDefaultsKickboardStartTime()
        let rentalTotalTime = userDefaultsManager.calculateKickboardTotalTime()
        let rentalPrice = userDefaultsManager.calculateKickboardRentalPrice()
        let rental = Rental(userID: userID, kickBoardID: kickboardID, kickBoardNumber: kickboardNumber, rentalStartTime: rentalStartTime, rentalTotalTime: rentalTotalTime, rentalPrice: rentalPrice)
        
        rentalDataManager.createRentalData(data: rental)
        
        userDefaultsManager.setUserDefaults(userStatus: false)
        setupView()
        returnButtonAction?()
    }
}

