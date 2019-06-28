//
//  ContentsCell.swift
//  TodoListHackathon
//
//  Created by Daisy on 26/06/2019.
//  Copyright © 2019 고정아. All rights reserved.
//

import UIKit

class ContentsCell: UITableViewCell {

    let contentsTextfield = UITextField()
    let checkBoxButton = UIButton(type: .custom)
    
    var th: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contentsTextfield)
        addSubview(checkBoxButton)
        setupLayout()
        configureObjects()
        backgroundColor = .orange
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    private func sendToDoneSection() {
        
    }
    
    private func configureObjects() {
        // FIXME: - 이미지로 변경
        checkBoxButton.setTitle("□", for: .normal)
        checkBoxButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .normal)
        checkBoxButton.addTarget(self, action: #selector(checkButtonDidTapped), for: .touchUpInside)
        checkBoxButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        contentsTextfield.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        contentsTextfield.delegate = self
//        contentsTextfield.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
    }
    
    @objc func checkButtonDidTapped() {
        print("CheckButton Tapped")
        DataManager.shared.setTodoListIsComplete(th!, true)
        noti.post(name: NSNotification.Name(rawValue: "checkButtonDidTapped"), object: nil)
    }
    
    private func setupLayout() {
        let guide = safeAreaLayoutGuide
        let margin: CGFloat = 0
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        checkBoxButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: margin).isActive = true
        checkBoxButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkBoxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkBoxButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        contentsTextfield.translatesAutoresizingMaskIntoConstraints = false
        contentsTextfield.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentsTextfield.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor).isActive = true
        
        contentsTextfield.widthAnchor.constraint(equalTo: guide.widthAnchor).isActive = true
        contentsTextfield.heightAnchor.constraint(equalToConstant: 100)

    }
}

extension ContentsCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { print("textFieldDidEndEditing");
            return false   }
        
        DataManager.shared.setTodoListTodo(th!,text)
        
        return true
    }
}
