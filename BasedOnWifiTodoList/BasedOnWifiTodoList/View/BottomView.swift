//
//  BottomView.swift
//  TodoListHackathon
//
//  Created by Daisy on 26/06/2019.
//  Copyright © 2019 고정아. All rights reserved.
//

import UIKit

class BottomView: UIView {
    
    // FIXME: - 수정 된 시간설정
    private var now: String {
        get {
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko")
            df.dateFormat = "a h:mm"
            return df.string(from: Date())
        }
    }
    
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
        addSubview(timeNowLabel)
        addSubview(wifiButton)
    }
    
    private func configureBottomItems() {
        
        wifiButton.translatesAutoresizingMaskIntoConstraints = false
        wifiButton.setImage(UIImage(named: "wifi"), for: .normal)
      
        timeNowLabel.translatesAutoresizingMaskIntoConstraints = false
        timeNowLabel.text = "수정된 날짜 \(now)"
        timeNowLabel.textColor = .lightGray
        timeNowLabel.font = UIFont.systemFont(ofSize: 15)

    }
    
    private func bottomItemsAutoLayout() {

        let margin: CGFloat = 20
        
        NSLayoutConstraint.activate([

            timeNowLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timeNowLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            timeNowLabel.trailingAnchor.constraint(equalTo: wifiButton.leadingAnchor),
            
            wifiButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            wifiButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin),
            wifiButton.widthAnchor.constraint(equalToConstant: 25),
            wifiButton.heightAnchor.constraint(equalToConstant: 25)
            
            ])
        
        
    }
  
  
}
