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
        backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureObjects() {
        // FIXME: - 이미지로 변경
        checkBoxButton.setTitle("□", for: .normal)
        checkBoxButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .normal)
        checkBoxButton.addTarget(self, action: #selector(checkButtonDidTapped), for: .touchUpInside)
        checkBoxButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    }
    
    @objc func checkButtonDidTapped() {
        
    }
    
    private func setupLayout() {
        let guide = safeAreaLayoutGuide
        let margin: CGFloat = 0
        
        doneTaskTextfield.translatesAutoresizingMaskIntoConstraints = false
        doneTaskTextfield.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        doneTaskTextfield.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor).isActive = true
        
        doneTaskTextfield.widthAnchor.constraint(equalTo: guide.widthAnchor).isActive = true
        doneTaskTextfield.heightAnchor.constraint(equalToConstant: 100)
        
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        checkBoxButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: margin).isActive = true
        checkBoxButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkBoxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkBoxButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }

}
