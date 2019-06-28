//
//  DoneTaskCell.swift
//  TodoListHackathon
//
//  Created by Daisy on 26/06/2019.
//  Copyright © 2019 고정아. All rights reserved.
//

import UIKit

class DoneTaskCell: UITableViewCell {

    let doneTaskTextfield = UITextField()
    let checkBoxButton = UIButton(type: .custom)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(doneTaskTextfield)
        addSubview(checkBoxButton)
        configureObjects()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureObjects() {
        checkBoxButton.setImage(UIImage(named: "check-box"), for: .normal)
        checkBoxButton.addTarget(self, action: #selector(checkButtonDidTapped), for: .touchUpInside)
        
        doneTaskTextfield.textColor = #colorLiteral(red: 0.458770752, green: 0.4588538408, blue: 0.4587655067, alpha: 1)
    }
    
    @objc func checkButtonDidTapped() {
        
    }
    
    private func setupLayout() {
//        let guide = safeAreaLayoutGuide
        let margin: CGFloat = 5
        
        doneTaskTextfield.translatesAutoresizingMaskIntoConstraints = false
        doneTaskTextfield.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        doneTaskTextfield.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: margin).isActive = true
        
        doneTaskTextfield.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        doneTaskTextfield.heightAnchor.constraint(equalToConstant: 100)
        
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        checkBoxButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: margin * 2).isActive = true
        checkBoxButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        checkBoxButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        checkBoxButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }

}
