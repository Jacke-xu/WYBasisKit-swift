//
//  WYTimer.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit

public class WYTimer {
    
    /// 计时器
    private var timer: Timer?
    
    /// 倒计时
    private var totalSeconds: Int = 0
    
    /// 倒计时回调
    private var timerHandler: ((_ duration: Int) -> Void)?

    /**
    开始倒计时

    @param totalTime 需要倒计时的时长，单位 "秒"
    @param handler 倒计时block，里面返回的是剩余时长，单位 "秒"
    */
    public func wy_begin(totalTime: Int, handler: @escaping (_ duration: Int) -> Void) {
        
        totalSeconds = totalTime

        timerHandler = handler
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block:{ [weak self] (timer: Timer) -> Void in
            self?.wy_beginCountdown()
        })
        // 把定时器加入到RunLoop里面，保证持续运行，不被表视图滑动事件这些打断
        RunLoop.current.add(timer!, forMode: .common)
        
        NotificationCenter.default.addObserver(self, selector: #selector(wy_didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(wy_didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    /// 更新倒计时剩余时间，单位 "秒"
    public func wy_updateTime(remaining: Int) {
        totalSeconds = remaining
    }
    
    /// 取消倒计时
    public func wy_cancel() {
        
        timer?.invalidate()
        timer = nil
    }
    
    /// 传入一个秒数，返回时分秒格式的字符串
    public class func wy_format(second: Int) -> String {
        
        var cu_hour = String(second / 3600)
        var cu_minute = String((second - (Int(cu_hour)! * 3600)) / 60)
        var cu_second = String((second - (Int(cu_minute)! * 60) - (Int(cu_hour)! * 3600)))
        
        if ((Int(cu_hour)!) < 10) {
            
            cu_hour = "0".appending(cu_hour)
        }
        
        if ((Int(cu_minute)!) < 10) {
            
            cu_minute = "0".appending(cu_minute)
        }
        
        if ((Int(cu_second)!) < 10) {
            
            cu_second = "0".appending(cu_second)
        }
        
        return cu_hour + ":" + cu_minute + ":" + cu_second
    }

    /// 传入一个秒数，返回有几个小时
    public class func wy_formatFewHours(second: Int) -> String {
        
        return String((second / 3600))
    }

    /// 传入一个秒数，返回有多少分钟
    public class func wy_formatFewMinute(second: Int) -> String {
        
        let cu_hour = String(second / 3600)
        return String(((second - (Int(cu_hour)! * 3600)) / 60))
    }
    
    /// 倒计时方法
    private func wy_beginCountdown() {

        totalSeconds -= 1
        
        if (timerHandler != nil) {
            
            timerHandler!(totalSeconds)
        }
        
        if totalSeconds <= 0 {
            
            wy_cancel()
        }
    }
    
    @objc private func wy_didEnterBackground() {
        
        if (timer != nil) {
            
            UserDefaults.standard.set(Date(), forKey: "stopRunTime")
            UserDefaults.standard.synchronize()
        }
    }
    
    @objc private func wy_didBecomeActive() {
        
        let lastRunTime = UserDefaults.standard.object(forKey: "stopRunTime")
        if ((lastRunTime != nil) && (timer != nil)) {
            
            let stopRunTime = lastRunTime as! Date
            
            let different = Int(Date().timeIntervalSince(stopRunTime))
            
            totalSeconds -= different
            
            UserDefaults.standard.removeObject(forKey: "stopRunTime")
            UserDefaults.standard.synchronize()
            
            if totalSeconds > 0 {
                
                wy_cancel()
                
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block:{ [weak self] (timer: Timer) -> Void in
                    self?.wy_beginCountdown()
                })
                // 把定时器加入到RunLoop里面，保证持续运行，不被表视图滑动事件这些打断
                RunLoop.current.add(timer!, forMode: .common)
            }
        }
    }
    
    deinit {
        wy_cancel()
    }
}
