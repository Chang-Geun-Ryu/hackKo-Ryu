//
//  BottomView.swift
//  TodoListHackathon
//
//  Created by Daisy on 26/06/2019.
//  Copyright © 2019 고정아. All rights reserved.
//

import UIKit

class BottomView: UIView {
    
    //시간설정
    private var now: String {
        get {
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko")
            df.dateFormat = "a h:mm"
            return df.string(from: Date())
        }
    }
    
    let settingButton = UIButton(type: .custom)
    let timeNowLabel = UILabel()
    let wifiButton = UIButton(type: .custom)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bottomItemsAddSubView()
        configureBottomItems()
        bottomItemsAutoLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bottomItemsAddSubView() {
        addSubview(settingButton)
        addSubview(timeNowLabel)
        addSubview(wifiButton)
    }
    
    private func configureBottomItems() {
        
        wifiButton.translatesAutoresizingMaskIntoConstraints = false
        //        wifiButton.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
        wifiButton.setTitle("Y", for: .normal)
        wifiButton.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)
      
      

        timeNowLabel.translatesAutoresizingMaskIntoConstraints = false
        timeNowLabel.text = "수정된 날짜 \(now)"
        timeNowLabel.textColor = .lightGray
        timeNowLabel.font = UIFont.systemFont(ofSize: 15)
        
        // FIXME: - 이미지 파일로 변경
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.setTitle("☑︎", for: .normal)
        settingButton.setTitleColor(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), for: .normal)
    }
    
    private func bottomItemsAutoLayout() {
        
        let guide = safeAreaLayoutGuide
        let margin: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            settingButton.topAnchor.constraint(equalTo: guide.topAnchor),
            settingButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: margin * 2),

            timeNowLabel.topAnchor.constraint(equalTo: guide.topAnchor),
            timeNowLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            
            wifiButton.topAnchor.constraint(equalTo: guide.topAnchor),
            wifiButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor , constant: -(margin * 2)),
            
            ])
        
        
    }
  
  
}
