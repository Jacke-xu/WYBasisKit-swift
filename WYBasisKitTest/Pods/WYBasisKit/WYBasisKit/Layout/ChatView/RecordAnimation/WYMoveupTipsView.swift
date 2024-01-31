//
//  WYMoveupTipsView.swift
//  WYBasisKit
//
//  Created by Miraitowa on 2023/8/31.
//

import UIKit

public class WYMoveupTipsView: UIView {
    
    /// 提示文本View
    public var tipsView: UILabel = UILabel()
    
    /// 移动按钮
    public var moveuplView: UIButton = UIButton(type: .custom)
    
    public init() {
        super.init(frame: .zero)
        
        tipsView.backgroundColor = .clear
        tipsView.textAlignment = .center
        tipsView.font = recordAnimationConfig.tipsInfoForMoveup.font
        tipsView.textColor = recordAnimationConfig.tipsInfoForMoveup.color
        addSubview(tipsView)
        tipsView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(tipsView.font.lineHeight)
        }

        addSubview(moveuplView)
        moveuplView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(tipsView.snp.bottom).offset(recordAnimationConfig.moveupButtonCenterOffsetY.onExternal)
            make.width.height.equalTo(recordAnimationConfig.moveupButtonDiameter.onExternal)
            make.bottom.equalToSuperview()
        }
        moveuplView.wy_cornerRadius(recordAnimationConfig.moveupButtonDiameter.onExternal / 2).wy_showVisual()
    }
    
    /// 刷新取消录音或者转文字按钮状态
    public func refresh(isRight: Bool) {
        
        moveuplView.isSelected = !moveuplView.isSelected
        
        moveuplView.transform = CGAffineTransform(rotationAngle: isRight ? recordAnimationConfig.moveupViewDeviationAngle : -recordAnimationConfig.moveupViewDeviationAngle)
        
        if moveuplView.isSelected == true {
            
            tipsView.text = isRight ? recordAnimationConfig.transferViewText.tips : recordAnimationConfig.cancelRecordViewText.tips
            
            moveuplView.backgroundColor = isRight ? recordAnimationConfig.transferViewColor.onInterior : recordAnimationConfig.cancelRecordViewColor.onInterior
            moveuplView.setBackgroundImage(isRight ? recordAnimationConfig.transferViewImage.onInterior : recordAnimationConfig.cancelRecordViewImage.onInterior, for: .normal)
            moveuplView.setBackgroundImage(isRight ? recordAnimationConfig.transferViewImage.onInterior : recordAnimationConfig.cancelRecordViewImage.onInterior, for: .selected)
            moveuplView.setTitle(isRight ? recordAnimationConfig.transferViewText.onInterior : recordAnimationConfig.cancelRecordViewText.onInterior, for: .normal)
            moveuplView.setTitle(isRight ? recordAnimationConfig.transferViewText.onInterior : recordAnimationConfig.cancelRecordViewText.onInterior, for: .selected)
            moveuplView.titleLabel?.font = isRight ? recordAnimationConfig.transferViewTextInfoForExternal.font : recordAnimationConfig.cancelRecordViewTextInfoForExternal.font
            moveuplView.setTitleColor(isRight ? recordAnimationConfig.transferViewTextInfoForExternal.color : recordAnimationConfig.cancelRecordViewTextInfoForExternal.color, for: .normal)
            moveuplView.setTitleColor(isRight ? recordAnimationConfig.transferViewTextInfoForExternal.color : recordAnimationConfig.cancelRecordViewTextInfoForExternal.color, for: .selected)
            moveuplView.snp.updateConstraints { make in
                make.width.height.equalTo(recordAnimationConfig.moveupButtonDiameter.onInterior)
            }
            moveuplView.wy_clearVisual()
            moveuplView.wy_cornerRadius(recordAnimationConfig.moveupButtonDiameter.onInterior / 2).wy_showVisual()
            
        }else {
            
            tipsView.text = ""
            
            moveuplView.backgroundColor = isRight ? recordAnimationConfig.transferViewColor.onExternal : recordAnimationConfig.cancelRecordViewColor.onExternal
            moveuplView.setBackgroundImage(isRight ? recordAnimationConfig.transferViewImage.onExternal : recordAnimationConfig.cancelRecordViewImage.onExternal, for: .normal)
            moveuplView.setBackgroundImage(isRight ? recordAnimationConfig.transferViewImage.onExternal : recordAnimationConfig.cancelRecordViewImage.onExternal, for: .selected)
            moveuplView.setTitle(isRight ? recordAnimationConfig.transferViewText.onInterior : recordAnimationConfig.cancelRecordViewText.onInterior, for: .normal)
            moveuplView.setTitle(isRight ? recordAnimationConfig.transferViewText.onInterior : recordAnimationConfig.cancelRecordViewText.onInterior, for: .selected)
            moveuplView.titleLabel?.font = isRight ? recordAnimationConfig.transferViewTextInfoForInterior.font : recordAnimationConfig.cancelRecordViewTextInfoForInterior.font
            moveuplView.setTitleColor(isRight ? recordAnimationConfig.transferViewTextInfoForInterior.color : recordAnimationConfig.cancelRecordViewTextInfoForInterior.color, for: .normal)
            moveuplView.setTitleColor(isRight ? recordAnimationConfig.transferViewTextInfoForInterior.color : recordAnimationConfig.cancelRecordViewTextInfoForInterior.color, for: .selected)
            moveuplView.snp.updateConstraints { make in
                make.width.height.equalTo(recordAnimationConfig.moveupButtonDiameter.onExternal)
                moveuplView.wy_clearVisual()
                moveuplView.wy_cornerRadius(recordAnimationConfig.moveupButtonDiameter.onExternal / 2).wy_showVisual()
            }
        }
        backgroundColor = .orange
        tipsView.backgroundColor = .blue
        moveuplView.backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
