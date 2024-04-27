//
//  TimerManager.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/28/24.
//

import Foundation

class TimerManager {
    
    static let shared = TimerManager()
    private init() {}
    
    var timer: Timer?
    var elapsedTime: Int = 0
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.timerDidFire()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        elapsedTime = 0
        print("Timer stopped")
    }
    
    private func timerDidFire() {
        elapsedTime += 1
        print("Timer updated: \(elapsedTime) seconds")
        NotificationCenter.default.post(name: .timerUpdated, object: nil)
    }
}
extension Notification.Name {
    static let timerUpdated = Notification.Name("timerUpdated")
}
